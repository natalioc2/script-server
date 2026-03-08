#!/bin/bash
set -euo pipefail

echo "[+] Iniciando configuración de Zsh en Debian..."

# Validar que no se ejecute como root directamente
if [[ "${EUID}" -eq 0 ]]; then
  echo "[!] No ejecutes este script como root."
  echo "[!] Ejecútalo con tu usuario normal. El script usará sudo cuando sea necesario."
  exit 1
fi

echo "[+] Actualizando Linux Debian..."
sudo apt update && sudo apt upgrade -y

echo "[+] Instalando ZSH..."
sudo apt install -y zsh git curl

echo "[+] Instalando Oh My Zsh..."
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

echo "[+] Configurando ZSH-THEME..."
sed -i 's/ZSH_THEME=".*"/ZSH_THEME="afowler"/' ~/.zshrc

echo "[+] Instalando plugins ZSH..."
git clone https://github.com/zsh-users/zsh-autosuggestions \
~/.oh-my-zsh/custom/plugins/zsh-autosuggestions

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting

sed -i 's/plugins=(git)/plugins=(zsh-autosuggestions zsh-syntax-highlighting)/' ~/.zshrc

echo "[+] Creando directorio de alias..."
mkdir -p ~/.aliases

echo "[+] Añadiendo carga de alias en ~/.zshrc..."
if ! grep -q 'for file in ~/.aliases/\*.sh(N); do' ~/.zshrc 2>/dev/null; then
  cat << 'EOF' >> ~/.zshrc

# Cargar alias personalizados
for file in ~/.aliases/*.sh(N); do
  source "$file"
done

# Ejecutar banner al iniciar terminal
if [ -x /usr/local/bin/initial-banner.sh ]; then
  /usr/local/bin/initial-banner.sh
fi

EOF
else
  echo "[=] El bloque de alias ya existe en ~/.zshrc"
fi

echo "[+] Cambiando shell por defecto a zsh..."
chsh -s "$(command -v zsh)"

echo "[✔] Instalación completada."
echo "👉 Cierra sesión o reinicia para aplicar ZSH."
