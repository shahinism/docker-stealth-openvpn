#!/usr/bin/env bash

set -e

# shellcheck source=./common.sh
. "${BASH_SOURCE%/*}/common.sh"

OVPN_CONF_DIR="./ovpn-data-store/"
OVPN_CONF_PATH="${OVPN_CONF_DIR}/openvpn.conf"

STUNNEL_CONF_PATH="./stunnel.conf"
info "+ Initializing OpenVPN config..."

PUBLIC_IP=$(curl -s https://ipinfo.io/ip)
printf "This server's public address [%s]: " "$PUBLIC_IP"
read -r ADDRESS
ADDRESS=${ADDRESS:-$PUBLIC_IP}

docker-compose run --rm openvpn ovpn_genconfig  -C "AES-256-CBC" -a "SHA384" -u "tcp://$ADDRESS:443"
docker-compose run --rm openvpn ovpn_initpki

cat >> "$OVPN_CONF_PATH" <<EOF
push "route ${ADDRESS} 255.255.255.255 net_gateway"
EOF

success "+ OpenVPN configuration succeeded"
info "+ Initializing stunnel config for clients..."

cat > "$STUNNEL_CONF_PATH" << EOF
client = yes

[stunnel.nl]
accept = 127.0.0.1:41194
connect = ${ADDRESS}:993
EOF

success "+ Stunnel config is available at ${STUNNEL_CONF_PATH}"
