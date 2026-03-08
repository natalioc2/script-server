#!/bin/bash

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

echo ""
echo -e "${B4}:::::  Eliminar usuario Linux   :::::${NC}"
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

if ! id "$USUARIO" &>/dev/null; then
    echo "El usuario '$USUARIO' no existe."
    echo ""
    exit 1
fi

echo "Vas a eliminar al usuario '$USUARIO'."
echo ""
read -p "¿Deseas borrar también su directorio HOME (/home/$USUARIO)? [s/N]: " CONFIRMACION

pkill -u "$USUARIO" 2>/dev/null

if [[ "$CONFIRMACION" =~ ^[sS]$ ]]; then
    echo ""
    echo "Borrando usuario y sus archivos..."
    echo ""
    userdel -r "$USUARIO"
else
    echo ""
    echo "Borrando solo el usuario (archivos conservados en /home/$USUARIO)."
    echo ""
    userdel "$USUARIO"
fi

rm -f "/etc/sudoers.d/$USUARIO"

echo ""
echo -e "${B5}[+] Proceso completado para el usuario '$USUARIO'.${NC}"
echo ""
