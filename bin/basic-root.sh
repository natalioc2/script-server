#!/usr/bin/env bash
set -euo pipefail

B1='\033[38;5;21m'
B2='\033[38;5;27m'
B3='\033[38;5;33m'
B4='\033[38;5;39m'
B5='\033[38;5;45m'
B6='\033[38;5;51m'
NC='\033[0m'

echo ""
printf "${B4}:::::  Instalación de utilidades para Debian Server   :::::${NC}\n"

# Verificar privilegios
if [[ "${EUID}" -ne 0 ]]; then
  printf "${B3}[!] Este script debe ejecutarse con sudo o como root.${NC}\n"
  exit 1
fi

printf "\n${B4}[+] Actualizando paquetes...${NC}\n"
apt update && apt full-upgrade -y

printf "\n${B4}[+] Instalando utilidades del sistema...${NC}\n"
apt install -y lolcat figlet

printf "\n${B4}[+] Instalando herramientas básicas del sistema...${NC}\n"
apt install -y curl wget git tree

printf "\n${B4}[+] Instalando herramientas de compresión y archivos...${NC}\n"
apt install -y zip unzip p7zip-full

printf "\n${B4}[+] Instalando herramientas de monitoreo...${NC}\n"
apt install -y fastfetch

printf "\n${B4}[+] Instalando herramientas de servidor y backup...${NC}\n"
apt install -y rsync cron zsh

printf "\n${B4}[+] Limpiando paquetes innecesarios...${NC}\n"
apt autoremove -y
apt autoclean -y

printf "\n${B5}[+] Instalación completada correctamente${NC}\n"
echo ""
