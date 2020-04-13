#!/usr/bin/env bash

PUBLIC_IP=$(curl -s https://ipinfo.io/ip)

printf "This server's public address [%s]: " "$PUBLIC_IP"
read -r ADDRESS
ADDRESS=${ADDRESS:-$PUBLIC_IP}

docker-compose run --rm openvpn ovpn_genconfig  -C "AES-256-CBC" -a "SHA384" -u "tcp://$ADDRESS:443"
docker-compose run --rm openvpn ovpn_initpki
