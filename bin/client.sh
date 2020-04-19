#!/usr/bin/env bash

set -e

# shellcheck source=./common.sh
. "${BASH_SOURCE%/*}/common.sh"

printf "Username: "
read -r USERNAME

CONFIG_DIR="./clients"
CONFIG_PATH="$CLIENTS_DIR/$USERNAME".ovpn

if [ "$USERNAME" = "" ]; then
    echo "Username was empty"
    exit 1
fi

mkdir -p $CONFIG_DIR
info "+ Start user generation"
docker-compose run --rm openvpn easyrsa build-client-full "$USERNAME" nopass
docker-compose run --rm openvpn ovpn_getclient "$USERNAME" >
