#!/usr/bin/env bash
set -euo pipefail

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

echo ""
printf "${B4}::: Configuración regional del sistema :::${NC}\n"
echo ""

LOCALE="es_BO.UTF-8"
TIMEZONE="America/La_Paz"

echo "Locale: $LOCALE"
echo "Timezone: $TIMEZONE"

if [[ $EUID -ne 0 ]]; then
    echo "Este script debe ejecutarse como root."
    exit 1
fi

echo ""
printf "${B4}1. Verificando locale...${NC}\n"

if locale -a 2>/dev/null | grep -qi '^es_bo\.utf8$'; then
    echo "Locale $LOCALE ya existe."
else
    echo "Generando locale $LOCALE ..."

    if [[ ! -f /etc/locale.gen ]]; then
        echo "No existe /etc/locale.gen. Instala el paquete locales."
        exit 1
    fi

    if ! grep -q '^es_BO.UTF-8 UTF-8$' /etc/locale.gen; then
        echo "es_BO.UTF-8 UTF-8" >> /etc/locale.gen
    fi

    locale-gen
fi

echo ""
printf "${B4}2. Configurando locale por defecto...${NC}\n"

update-locale LANG="$LOCALE"

export LANG="$LOCALE"
export LC_ALL="$LOCALE"

echo ""
printf "${B4}3. Configurando zona horaria...${NC}\n"

if command -v timedatectl >/dev/null 2>&1; then
    timedatectl set-timezone "$TIMEZONE"
else
    ln -snf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
    echo "$TIMEZONE" > /etc/timezone
fi

echo ""
printf "${B4}Configuración aplicada${NC}\n"

echo ""
echo "Locale actual:"
locale

echo ""
echo "Zona horaria actual:"
if command -v timedatectl >/dev/null 2>&1; then
    timedatectl
else
    date
    cat /etc/timezone
fi

echo ""
printf "${B5}Proceso completado. Se recomienda reiniciar la instancia.${NC}\n"
echo ""
