#!/usr/bin/env bash

CLIENTS_DIR="./clients"
printf "Username: "
read -r USERNAME

if [ "$USERNAME" = "" ]; then
    echo "Username was empty"
    exit 1
fi

docker-compose run --rm openvpn easyrsa revoke ${USERNAME}
docker-compose run --rm openvpn easyrsa gen-crl
rm -rfv "$CLIENTS_DIR/$USERNAME".ovpn
