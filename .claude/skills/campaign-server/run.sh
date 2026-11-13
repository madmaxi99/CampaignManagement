#!/usr/bin/env bash
# Runs campaign.py against the production server (nginx listens on 127.0.0.1:8070 there,
# so the app is reached through an SSH tunnel). The DM password is read from the server's
# .env into the environment of this process only and is never printed.
#
#   run.sh import [--dry-run] | sync | check | edit <type> <key> field=value ...
#
# Set BASE_URL to skip the tunnel and password lookup (e.g. BASE_URL=http://127.0.0.1:8070 for
# the local dev app, which reads DM_PASSWORD from the project's .env).
set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd)"

if [[ -n "${BASE_URL:-}" ]]; then
    exec python3 -I "$here/campaign.py" "$@"
fi

host="${VPS_HOST:-amt-solo-vps}"
port="${TUNNEL_PORT:-18070}"
remote="${REMOTE_PATH:-/opt/campaignManagement}"

# A dry run sends nothing, so it needs neither the tunnel nor the password.
if [[ "${1:-}" == "import" && "${2:-}" == "--dry-run" ]]; then
    exec python3 -I "$here/campaign.py" "$@"
fi

DM_PASSWORD="$(ssh -o BatchMode=yes "$host" "grep -m1 '^DM_PASSWORD=' $remote/.env | cut -d= -f2-" | sed -e "s/^['\"]//" -e "s/['\"]\$//")"
export DM_PASSWORD
if [[ -z "$DM_PASSWORD" ]]; then
    echo "ERROR: DM_PASSWORD not found in $remote/.env on $host" >&2
    exit 1
fi

ssh -o BatchMode=yes -o ExitOnForwardFailure=yes -N -L "$port:127.0.0.1:8070" "$host" &
tunnel=$!
trap 'kill "$tunnel" 2>/dev/null || true' EXIT

for _ in $(seq 1 20); do
    curl -s -o /dev/null "http://127.0.0.1:$port/dm/login" && break
    sleep 0.5
done

BASE_URL="http://127.0.0.1:$port" python3 -I "$here/campaign.py" "$@"
