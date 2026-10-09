#!/usr/bin/env bash
set -euo pipefail

# Deploys the current branch to the VPS: pulls latest, rebuilds containers,
# installs backend dependencies, applies pending database migrations, makes the upload directories writable.
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
rphp bin/migrate.php

# Uploads (character portraits, campaign images) are written by the php-fpm
# worker, whose user differs from the owner of the checkout on the VPS.
# Only directories are opened up, so git sees no file mode changes.
dc exec -T -u root php-fpm sh -c 'mkdir -p public/images/characters/uploads public/images/bestiary public/images/items public/images/npcs public/images/places && find public/images -type d -exec chmod 777 {} +'
REMOTE
