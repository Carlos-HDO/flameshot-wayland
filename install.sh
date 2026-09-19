#!/usr/bin/env bash
# Script de instalação do flameshot-wayland em ~/.local/bin

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.local/bin"
BIN_NAME="flameshot-wayland"

mkdir -p "$TARGET_DIR"

chmod +x "$SCRIPT_DIR/flameshot-wayland.sh"

# Cria symlink principal
ln -sf "$SCRIPT_DIR/flameshot-wayland.sh" "$TARGET_DIR/$BIN_NAME"

# Cria symlink adicional para atalho alternativo
ln -sf "$SCRIPT_DIR/flameshot-wayland.sh" "$TARGET_DIR/flameshot-sway"
ln -sf "$SCRIPT_DIR/flameshot-wayland.sh" "$TARGET_DIR/screenshot_edit"

echo "✅ Instalado com sucesso!"
echo "Comandos disponíveis em $TARGET_DIR:"
echo "  • $BIN_NAME"
echo "  • flameshot-sway"
echo "  • screenshot_edit"
echo ""
echo "Certifique-se de que '$TARGET_DIR' esteja no seu PATH:"
echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
