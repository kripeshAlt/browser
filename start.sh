
#!/bin/bash
set -e

export DISPLAY=:99

# Start virtual display
Xvfb :99 -screen 0 "${RESOLUTION:-1024x768x16}" -ac &
sleep 2

# Start lightweight window manager
openbox &

# Start Chromium
chromium \
    --no-sandbox \
    --disable-dev-shm-usage \
    --disable-gpu \
    --disable-software-rasterizer \
    --disable-extensions \
    --disable-background-networking \
    --disable-sync \
    --no-first-run \
    --no-default-browser-check \
    --user-data-dir=/tmp/chromium-profile \
    --window-size=1024,768 \
    --start-maximized \
    about:blank &

# Start VNC server
x11vnc \
    -display :99 \
    -forever \
    -shared \
    -nopw \
    -listen 127.0.0.1 \
    -rfbport 5900 &

# Start noVNC web interface
websockify \
    --web=/usr/share/novnc/ \
    0.0.0.0:${PORT:-10000} \
    localhost:5900
