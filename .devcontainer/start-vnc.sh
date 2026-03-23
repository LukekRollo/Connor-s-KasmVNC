#!/bin/bash

# Kill any existing VNC sessions
vncserver -kill :1 2>/dev/null || true
sleep 1

# Set up VNC password
mkdir -p ~/.vnc
echo -e "password\npassword\n" | vncpasswd -u vscode -w -r

# Start KasmVNC
vncserver :1 \
  -geometry 1920x1080 \
  -depth 24 \
  -websocketPort 6901 \
  -interface 0.0.0.0 \
  -FrameRate 60 \
  -DynamicQualityMin 4 \
  -DynamicQualityMax 7 \
  -BlacklistThreshold 0 \
  -sslOnly 0 \
  -select-de manual

sleep 2

export DISPLAY=:1

# Set solid dark background (saves encoding bandwidth)
xsetroot -solid "#1e1e1e" 2>/dev/null || true

# Disable screensaver
xset s off 2>/dev/null || true
xset -dpms 2>/dev/null || true

# Start Openbox
openbox &

sleep 1

# Launch Chrome maximized with performance flags
google-chrome-stable \
  --start-maximized \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --disable-translate \
  --password-store=basic \
  --disable-features=TranslateUI \
  https://www.google.com &

echo ""
echo "================================================"
echo "  KasmVNC Desktop running on port 6901"
echo "  Username: vscode  |  Password: password"
echo "  Open port 6901 from the Ports tab"
echo "================================================"
echo ""