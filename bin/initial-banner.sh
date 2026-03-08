#!/bin/bash

# --- 1. CONFIGURACIÓN DE COLORES (Paleta Azul) ---

B1='\033[38;5;21m'
B2='\033[38;5;27m'
B3='\033[38;5;33m'
B4='\033[38;5;39m'
B5='\033[38;5;45m'
B6='\033[38;5;51m'
NC='\033[0m'


# --- 2. RECOLECCIÓN DE DATOS ---
# Cargar metadatos del sistema
[[ -f /etc/os-release ]] && source /etc/os-release

DISTRO=${ID:-debian}
CODENAME=${VERSION_CODENAME:-trixie}
DISTRO_NAME=${PRETTY_NAME:-Debian GNU/Linux 13}
KERNEL=$(uname -r)
BOARD_NAME="Linux"

# Red (LAN y WAN con timeout para evitar lentitud)
LAN_IP=$(hostname -I | awk '{print $1}')
WAN_IP=$(curl -s --max-time 1 ifconfig.me || echo "offline")

# --- 3. IMPRESIÓN DEL LOGO ---

echo -e "\033[38;5;39m"
cat <<'EOF'
      ____       __    _                ______     _      _     
     / __ \___  / /_  (_)___ _____     /_  __/____(_)  __(_)__  
    / / / / _ \/ __ \/ / __ `/ __ \     / / / ___/ / |/_/ / _ \ 
   / /_/ /  __/ /_/ / / /_/ / / / /    / / / /  / />  </ /  __/ 
  /_____/\___/_.___/_/\__,_/_/ /_/    /_/ /_/  /_/_/|_/_/\___/  
EOF
echo -e "\033[0m"

# --- 4. INFORMACIÓN DE SISTEMA ---
# Usando B4 para resaltar nombres y B3 para estados (estilo Armbian)
echo -e "Welcome to ${B4}${BOARD_NAME}${NC} running ${B4}${DISTRO_NAME}${NC} kernel ${B4}${KERNEL}${NC}"
echo ""

echo -e " Packages:      ${DISTRO^} ${B3}stable${NC} (${CODENAME})"
echo -e " Support:       ${B3}for advanced users${NC} (rolling release)"
echo -e " IPv4:          ${B4}(LAN) ${NC}${LAN_IP} ${B4}(WAN) ${NC}${WAN_IP}${NC}"
echo ""
