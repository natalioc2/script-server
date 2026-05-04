#!/usr/bin/env bash

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

[[ -f /etc/os-release ]] && . /etc/os-release

DISTRO_NAME="${PRETTY_NAME:-Linux}"
KERNEL="$(uname -r)"
HOSTNAME="$(hostname)"

echo
echo -e "Welcome to ${B5}${HOSTNAME}${NC} :: ${B4}${DISTRO_NAME}${NC} :: kernel ${B4}${KERNEL}${NC}"