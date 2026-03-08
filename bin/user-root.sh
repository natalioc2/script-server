#!/bin/bash

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

echo ""
echo -e "${B4}:::::  Gestionar usuarios Linux   :::::${NC}"
echo ""

# --- FUNCIONES ---

mostrar_uso() {
    echo "Uso: $0 [crear|borrar] nombre_usuario"
    echo ""
    exit 1
}

# Verificar que se pasen exactamente 2 argumentos
if [ "$#" -ne 2 ]; then
    mostrar_uso
fi

ACCION=$1
USUARIO=$2

# Verificar root
if [ "$EUID" -ne 0 ]; then
  echo "Error: Ejecuta como root."
  exit 1
fi

# --- LÓGICA ---

case $ACCION in
    crear)
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
            echo "Error: Las contraseñas no coinciden."
            exit 1
        fi

        if ! command -v sudo &> /dev/null; then apt update && apt install -y sudo; fi

        useradd -m -s /bin/bash "$USUARIO"
        echo "$USUARIO:$PASSWORD" | chpasswd

        usermod -aG sudo "$USUARIO" || usermod -aG wheel "$USUARIO"
        echo "$USUARIO ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/$USUARIO"
        chmod 0440 "/etc/sudoers.d/$USUARIO"
        echo ""
        echo -e "${B5}[+] Usuario '$USUARIO' creado con éxito.${NC}"
	echo ""
        ;;

    borrar)
        if ! id "$USUARIO" &>/dev/null; then
            echo "El usuario '$USUARIO' no existe."
            echo ""
            exit 1
        fi

        # --- NUEVA SECCIÓN DE CONFIRMACIÓN ---
        echo "Vas a eliminar al usuario '$USUARIO'."
        echo ""
	read -p "¿Deseas borrar también su directorio HOME (/home/$USUARIO)? [s/N]: " CONFIRMACION

        pkill -u "$USUARIO" 2>/dev/null

        if [[ "$CONFIRMACION" =~ ^[sS]$ ]]; then
            echo "Borrando usuario y sus archivos..."
            echo ""
            userdel -r "$USUARIO"
        else
            echo "Borrando solo el usuario (archivos conservados en /home/$USUARIO)."
	    echo ""
            userdel "$USUARIO"
        fi

        # Limpiar sudoers siempre
        rm -f "/etc/sudoers.d/$USUARIO"
        echo ""
        echo -e "${B5}[+] Proceso completado para el usuario '$USUARIO'.${NC}"
        echo ""
        ;;

    *)
        mostrar_uso
        ;;
esac
