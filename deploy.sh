#!/usr/bin/env bash
set -euo pipefail

# Deploys the current branch to the VPS: pulls latest, rebuilds containers,
# installs backend dependencies.
#
# Requires the "amt-solo-vps" entry in ~/.ssh/config
# (root@185.192.96.141, IdentityFile ~/.ssh/amt_solo_vps).

VPS_HOST="amt-solo-vps"
REMOTE_PATH="/opt/campaignManagement"

# alias.sh assigns to $UID, which bash treats as readonly — run it under zsh
# (the VPS's default shell) instead of forcing bash.
ssh "$VPS_HOST" zsh -s <<REMOTE
set -eo pipefail
cd "$REMOTE_PATH"
git pull

. ./alias.sh
dcud
rcomposer install --no-interaction
REMOTE
