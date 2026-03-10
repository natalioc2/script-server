#!/usr/bin/env bash
set -euo pipefail

B4='\033[38;5;39m'
B5='\033[38;5;45m'
NC='\033[0m'

ZSH_DIR="$HOME/.zsh"
ZSHRC="$HOME/.zshrc"
BACKUP="$HOME/.zshrc.bak.$(date +%Y%m%d_%H%M%S)"

echo ""
printf "${B4} ::: Configuración ligera de Zsh + Starship :::${NC}\n"
echo ""

# Verificar dependencias
for cmd in git zsh curl chsh; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        printf "Error: no se encontró el comando '%s'.\n" "$cmd"
        exit 1
    fi
done

# Crear directorio base
mkdir -p "$ZSH_DIR"

echo ""
printf "${B4}[+] Instalando plugins ZSH...${NC}\n"
echo ""

if [ ! -d "$ZSH_DIR/zsh-autosuggestions/.git" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_DIR/zsh-autosuggestions"
else
    printf "Aviso: zsh-autosuggestions ya existe.\n"
fi

if [ ! -d "$ZSH_DIR/zsh-syntax-highlighting/.git" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_DIR/zsh-syntax-highlighting"
else
    printf "Aviso: zsh-syntax-highlighting ya existe.\n"
fi

echo ""
printf "${B4}[+] Configurando ~/.zshrc...${NC}\n"

if [ -f "$ZSHRC" ]; then
    cp "$ZSHRC" "$BACKUP"
fi

# eliminar bloque previo si existe
if [ -f "$ZSHRC" ] && grep -q "# >>> zsh-minimal-config >>>" "$ZSHRC"; then
    awk '
        BEGIN {skip=0}
        /# >>> zsh-minimal-config >>>/ {skip=1; next}
        /# <<< zsh-minimal-config <<</ {skip=0; next}
        skip==0 {print}
    ' "$ZSHRC" > "${ZSHRC}.tmp"
    mv "${ZSHRC}.tmp" "$ZSHRC"
fi

cat >> "$ZSHRC" <<'EOF'

# >>> zsh-minimal-config >>>
# historial
HISTSIZE=5000
SAVEHIST=5000
HISTFILE=~/.zsh_history
setopt HIST_IGNORE_DUPS SHARE_HISTORY

# prompt simple (será reemplazado por starship)
PROMPT='%F{39}%n@%m%f:%F{45}%~%f$ '

# autocompletado
autoload -Uz compinit
compinit

# Cargar alias personalizados
for file in ~/.local/myscripts/shell/*.sh(N); do
  source "$file"
done

# plugins ligeros
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# add path
export PATH="$HOME/.local/myscripts/bin:$PATH"

# <<< zsh-minimal-config <<<

EOF

printf "OK: configuración agregada a ~/.zshrc\n"

echo ""
echo "[+] Cambiando shell por defecto a ZSH..."
chsh -s $(which zsh)

echo ""
printf "Instalación completada correctamente.\n"
echo ""
printf "${B5}Cierra sesión y vuelve a ingresar para aplicar los cambios.${NC}\n"
echo ""
