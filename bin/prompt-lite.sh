#!/usr/bin/env bash
set -e

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

P10K_DIR="$HOME/powerlevel10k"
ZSHRC="$HOME/.zshrc"
P10K_CONFIG="$HOME/.p10k.zsh"

echo ""
printf "${B4} ::: Instalando / actualizando Powerlevel10k :::${NC}\n"
echo ""

echo ">>> Verificando Zsh..."
echo ""

# 1. verificar zsh
if ! command -v zsh >/dev/null 2>&1; then
    echo "Zsh no está instalado."
    echo "Instala con:"
    echo "sudo apt install zsh"
    exit 1
fi

# 2. instalar o actualizar powerlevel10k
if [ -d "$P10K_DIR" ]; then
    echo "Powerlevel10k ya existe, actualizando..."
    git -C "$P10K_DIR" pull --quiet
else
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$P10K_DIR"
fi

# 3. agregar a .zshrc si no existe
if ! grep -q "powerlevel10k.zsh-theme" "$ZSHRC" 2>/dev/null; then

cat <<'EOF' >> "$ZSHRC"

# Powerlevel10k
source ~/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

EOF

fi


# 4. crear configuración si no existe



# 5. cambiar shell al final

chsh -s "$(command -v zsh)"

echo ""
echo -e "${B5} [+] Instalación completada, se recomienda cerrar sesión.${NC}"
echo ""
