#!/bin/bash

# Configurações de compatibilidade para Wayland
export XDG_CURRENT_DESKTOP=sway
export XDG_SESSION_TYPE=wayland
export SDL_VIDEODRIVER=wayland

# Garante que não haja instâncias travadas
killall flameshot 2>/dev/null

# Pasta temporária para a captura
TEMP_FILE="/tmp/screenshot_edit.png"

# Executa o Flameshot
# -p especifica o local de salvamento automático após você confirmar a edição
if flameshot gui -p "$TEMP_FILE"; then
    # Força a imagem a ir para a área de transferência (clipboard)
    wl-copy < "$TEMP_FILE"
    
    # Notificação visual de que o Ctrl+V está pronto
    notify-send "Captura Concluída" "Imagem editada e copiada para o clipboard!" -i camera-photo
    
    # Limpa o arquivo temporário (opcional)
    rm "$TEMP_FILE"
else
    echo "Captura cancelada ou falhou"
fi
