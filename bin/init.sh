#!/usr/bin/env bash

set -e

STUNNEL_CONF_PATH="./stunnel.conf"
GREEN='\033[0;32m'
NC='\033[0m'

function message {
    echo -e "${1}${2}${NC}"
}

function success {
    message "$GREEN" "$1"
}

success "+ Initializing OpenVPN config..."

PUBLIC_IP=$(curl -s https://ipinfo.io/ip)
printf "This server's public address [%s]: " "$PUBLIC_IP"
read -r ADDRESS
ADDRESS=${ADDRESS:-$PUBLIC_IP}

docker-compose run --rm openvpn ovpn_genconfig  -C "AES-256-CBC" -a "SHA384" -u "tcp://$ADDRESS:443"
docker-compose run --rm openvpn ovpn_initpki

success "+ OpenVPN configuration succeeded"
success "+ Initializing stunnel config for clients..."

cat > "$STUNNEL_CONF_PATH" << _EOF_
client = yes

[stunnel.nl]
accept = 127.0.0.1:41194
connect = ${ADDRESS}:993
_EOF_

success "+ Stunnel config is available at ${STUNNEL_CONF_PATH}"
