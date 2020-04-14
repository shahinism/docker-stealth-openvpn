#!/usr/bin/env bash

RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

function message {
    echo -e "${1}${2}${NC}"
}

function success {
    message "$GREEN" "$1"
}

function error {
    message "$RED" "$1"
}

function info {
    message "$BLUE" "$1"
}
