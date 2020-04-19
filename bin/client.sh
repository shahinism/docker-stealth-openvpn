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

function create_user {
    info "+ Start user generation..."
    docker-compose run --rm openvpn easyrsa build-client-full "$USERNAME" nopass
    success "+ User generation complet"
}

function download_user {
    info "+ Downloading user client..."
    docker-compose run --rm openvpn ovpn_getclient "$USERNAME" > "$CONFIG_PATH"
    success "+ User profile downloaded at $CONFIG_PATH"
}

case $1 in
    "get")
        download_user
        ;;
    *)
        create_user
        download_user
        ;;
esac
