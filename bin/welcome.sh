#!/usr/bin/env bash

B4='\033[38;5;39m'
NC='\033[0m'

[[ -f /etc/os-release ]] && . /etc/os-release

DISTRO_NAME="${PRETTY_NAME:-Linux}"
KERNEL="$(uname -r)"

printf "${B4}"
cat <<'EOF'
      ____       __    _                ______     _      _
     / __ \___  / /_  (_)___ _____     /_  __/____(_)  __(_)__
    / / / / _ \/ __ \/ / __ `/ __ \     / / / ___/ / |/_/ / _ \
   / /_/ /  __/ /_/ / / /_/ / / / /    / / / /  / />  </ /  __/
  /_____/\___/_.___/_/\__,_/_/ /_/    /_/ /_/  /_/_/|_/_/\___/
EOF
printf "${NC}\n"

echo -e "Welcome to ${B4}${DISTRO_NAME}${NC} kernel ${B4}${KERNEL}${NC}"
echo
