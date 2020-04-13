#!/usr/bin/env bash

CLIENTS_DIR="./clients"
printf "Username: "
read -r USERNAME

if [ "$USERNAME" = "" ]; then
    echo "Username was empty"
    exit 1
fi

mkdir -p $CLIENTS_DIR

docker-compose run --rm openvpn easyrsa build-client-full "$USERNAME" nopass
docker-compose run --rm openvpn ovpn_getclient "$USERNAME" > "$CLIENTS_DIR/$USERNAME".ovpn
