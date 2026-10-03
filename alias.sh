export UID="$(id -u)"
export GID="$(id -g)"

alias dc="docker compose -f provisioning/docker-compose.yml --env-file .env -p campaign-management"
alias dcu="dc up --build"
alias dcud="dc up -d --build"
alias dcd="dc down"
alias dcv="dc down -v"
alias dcr="dc restart"
alias dcl="dc logs -f"

alias rcomposer="dc exec php-fpm composer"
alias rphp="dc exec php-fpm php"
