#!/usr/bin/env bash

B4='\033[38;5;39m'
NC='\033[0m'

[[ -f /etc/os-release ]] && . /etc/os-release

DISTRO_NAME="${PRETTY_NAME:-Linux}"
KERNEL="$(uname -r)"

if command -v figlet > /dev/null 2>&1; then
    figlet -f slant "Debian Trixie" | lolcat
else
    echo "DEBIAN TRIXIE"
fi

echo
echo -e "Welcome to ${B4}${DISTRO_NAME}${NC} kernel ${B4}${KERNEL}${NC}"
echo