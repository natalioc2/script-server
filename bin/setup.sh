#!/usr/bin/env bash
set -euo pipefail

# ── Colores (paleta azul) ──
B3='\033[38;5;33m'
B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

# ── Detectar directorio del repo ──
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR"

# ── Banner ──
echo ""
printf "${B4}:::::  Configuración del sistema Skynet  :::::${NC}\n"
echo ""

# ── Detectar privilegios ──
ES_ROOT=false
[[ "${EUID:-$(id -u)}" -eq 0 ]] && ES_ROOT=true

if $ES_ROOT; then
    printf "${B3}[!] Ejecutando como root${NC}\n"
else
    printf "${B3}[!] Ejecutando como usuario normal${NC}\n"
fi
echo ""

PS3=$(printf "${B5}Elige una opción [1-7]: ${NC}")

opciones=(
    "Instalar paquetes base del sistema"
    "Configurar locale (es_BO) y zona horaria"
    "Crear un usuario Linux"
    "Configurar Zsh (plugins + .zshrc)"
    "Instalar prompt Powerlevel10k"
    "Ejecutar todo (orden recomendado)"
    "Salir"
)

select opt in "${opciones[@]}"; do
    case $REPLY in
        1)
            echo ""
            printf "${B4}[+] Ejecutando basic-root.sh...${NC}\n"
            if $ES_ROOT; then
                "$BIN_DIR/basic-root.sh"
            else
                sudo "$BIN_DIR/basic-root.sh"
            fi
            ;;
        2)
            echo ""
            printf "${B4}[+] Ejecutando locale-config.sh...${NC}\n"
            if $ES_ROOT; then
                "$BIN_DIR/locale-config.sh"
            else
                sudo "$BIN_DIR/locale-config.sh"
            fi
            ;;
        3)
            echo ""
            printf "${B4}[+] Ejecutando add-user.sh...${NC}\n"
            if $ES_ROOT; then
                "$BIN_DIR/add-user.sh"
            else
                sudo "$BIN_DIR/add-user.sh"
            fi
            ;;
        4)
            echo ""
            printf "${B4}[+] Ejecutando zsh-lite.sh...${NC}\n"
            "$BIN_DIR/zsh-lite.sh"
            ;;
        5)
            echo ""
            printf "${B4}[+] Ejecutando prompt-lite.sh...${NC}\n"
            "$BIN_DIR/prompt-lite.sh"
            ;;
        6)
            echo ""
            printf "${B5}::: Ejecutando secuencia completa :::${NC}\n"
            echo ""
            printf "${B4}[1/4] Paquetes base...${NC}\n"
            $ES_ROOT && "$BIN_DIR/basic-root.sh" || sudo "$BIN_DIR/basic-root.sh"
            echo ""
            printf "${B4}[2/4] Locale...${NC}\n"
            $ES_ROOT && "$BIN_DIR/locale-config.sh" || sudo "$BIN_DIR/locale-config.sh"
            echo ""
            printf "${B4}[3/4] Zsh...${NC}\n"
            "$BIN_DIR/zsh-lite.sh"
            echo ""
            printf "${B4}[4/4] Prompt Powerlevel10k...${NC}\n"
            "$BIN_DIR/prompt-lite.sh"
            echo ""
            printf "${B5}[+] Instalación completa. Reinicia la sesión.${NC}\n"
            ;;
        7)
            echo ""
            printf "${B4}¡Hasta luego!${NC}\n"
            exit 0
            ;;
        *)
            echo ""
            printf "${B3}[!] Opción inválida (1-7)${NC}\n"
            ;;
    esac
    echo ""
done
