#!/bin/bash

# Configurações de compatibilidade para Wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export SDL_VIDEODRIVER=wayland

# Garante que não haja instâncias travadas
killall flameshot 2>/dev/null

# Diretório temporário privado (0700) para a captura, com nome imprevisível.
# Não usar mktemp no próprio arquivo: se ele já existir, o Flameshot salva com outro nome.
TEMP_DIR="$(mktemp -d --tmpdir="${XDG_RUNTIME_DIR:-/tmp}" flameshot-wayland.XXXXXX)" || exit 1
TEMP_FILE="$TEMP_DIR/screenshot.png"

# Remove a captura ao sair, inclusive se o script for interrompido
trap 'rm -rf "$TEMP_DIR"' EXIT
trap 'exit 130' INT TERM HUP

# Executa o Flameshot
# -p especifica o local de salvamento automático após você confirmar a edição
# O teste -s cobre o caso em que o Flameshot retorna 0 mesmo com a captura cancelada
if flameshot gui -p "$TEMP_FILE" && [ -s "$TEMP_FILE" ]; then
    # Força a imagem a ir para a área de transferência (clipboard)
    if wl-copy < "$TEMP_FILE"; then
        # Notificação visual de que o Ctrl+V está pronto
        notify-send "Captura Concluída" "Imagem editada e copiada para o clipboard!" -i camera-photo
    else
        echo "Falha ao copiar a captura para o clipboard" >&2
        exit 1
    fi
else
    echo "Captura cancelada ou falhou"
fi
