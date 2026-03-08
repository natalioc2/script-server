#!/bin/bash

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

echo ""
echo -e "${B4}:::::  Crear usuario Linux   :::::${NC}"
echo ""

# --- FUNCIONES ---

mostrar_uso() {
    echo "Uso: $0 nombre_usuario"
    echo ""
    exit 1
}

# Verificar que se pase exactamente 1 argumento
if [ "$#" -ne 1 ]; then
    mostrar_uso
fi

USUARIO=$1

# Verificar root
if [ "$EUID" -ne 0 ]; then
    echo "Error: Ejecuta como root."
    exit 1
fi

# --- LÓGICA ---

if id "$USUARIO" &>/dev/null; then
    echo "El usuario '$USUARIO' ya existe."
    echo ""
    exit 1
fi

read -sp "Introduce la contraseña para $USUARIO: " PASSWORD
echo ""
read -sp "Confirma la contraseña: " PASSWORD_CONFIRM
echo ""

if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
    echo ""
    echo "Error: Las contraseñas no coinciden."
    echo ""
    exit 1
fi

if ! command -v sudo &>/dev/null; then
    apt update && apt install -y sudo
fi

useradd -m -s /bin/bash "$USUARIO"
echo "$USUARIO:$PASSWORD" | chpasswd

usermod -aG sudo "$USUARIO" 2>/dev/null || usermod -aG wheel "$USUARIO"
echo "$USUARIO ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USUARIO"
chmod 0440 "/etc/sudoers.d/$USUARIO"

echo ""
echo -e "${B5}[+] Usuario '$USUARIO' creado con éxito.${NC}"
echo ""
