#!/bin/bash
set -x

echo ">>> Killing old sessions..."
vncserver -kill :1 2>/dev/null || true
sleep 1

# ============================================
# PASSWORD SETUP
# ============================================
mkdir -p ~/.vnc

# KasmVNC expects a specific password format
# Try the kasmvncpasswd tool first
if command -v kasmvncpasswd &>/dev/null; then
    echo ">>> Setting password with kasmvncpasswd..."
    printf "password\npassword\n" | kasmvncpasswd -f > ~/.vnc/kasmpasswd 2>/dev/null
    chmod 0600 ~/.vnc/kasmpasswd
fi

# Fallback: write password file directly if above didn't work
if [ ! -s ~/.vnc/kasmpasswd ]; then
    echo ">>> Using direct password file..."
    echo "vscode:password" > ~/.vnc/kasmpasswd
    chmod 0600 ~/.vnc/kasmpasswd
fi

echo ">>> Password file contents check:"
ls -la ~/.vnc/kasmpasswd

# ============================================
# START KASMVNC
# ============================================
echo ">>> Starting KasmVNC..."

vncserver :1 \
  -websocketPort 6901 \
  -geometry 1920x1080 \
  -depth 24 \
  -interface 0.0.0.0 \
  -sslOnly 0 \
  -FrameRate 60 \
  -select-de manual 2>&1

sleep 3

# ============================================
# VERIFY VNC IS RUNNING
# ============================================
export DISPLAY=:1

if ss -tlnp | grep -q 6901; then
    echo ">>> ✅ KasmVNC is listening on port 6901"
else
    echo ">>> ❌ First attempt failed. Trying minimal start..."
    cat ~/.vnc/*.log 2>/dev/null
    
    # Fallback: absolute minimal flags
    vncserver :1 -websocketPort 6901 -depth 24 -sslOnly 0 2>&1
    sleep 3
    export DISPLAY=:1
fi

# ============================================
# VERIFY DISPLAY WORKS
# ============================================
echo ">>> Testing DISPLAY..."
xdpyinfo -display :1 > /dev/null 2>&1
if [ $? -eq 0 ]; then
    echo ">>> ✅ DISPLAY :1 is working"
else
    echo ">>> ❌ DISPLAY :1 not working"
    cat ~/.vnc/*.log 2>/dev/null
    exit 1
fi

# ============================================
# DESKTOP SETUP
# ============================================
# Dark background
xsetroot -solid "#1e1e1e" 2>/dev/null || true

# Disable screensaver
xset s off 2>/dev/null || true
xset -dpms 2>/dev/null || true

# Start dbus (Chrome needs this)
if [ ! -S /run/dbus/system_bus_socket ]; then
    sudo mkdir -p /run/dbus
    sudo dbus-daemon --system --fork 2>/dev/null || true
fi

# Start window manager
DISPLAY=:1 openbox &
sleep 1

# ============================================
# LAUNCH CHROME
# ============================================
echo ">>> Starting Chrome..."

DISPLAY=:1 google-chrome-stable \
  --start-maximized \
  --no-sandbox \
  --disable-setuid-sandbox \
  --disable-dev-shm-usage \
  --disable-gpu \
  --no-first-run \
  --no-default-browser-check \
  --password-store=basic \
  https://www.google.com &

echo ""
echo "================================================"
echo "  ✅ KasmVNC Desktop running on port 6901"
echo "  Username: vscode  |  Password: password"
echo "================================================"
echo ""

# Final verification
ss -tlnp | grep 6901
ps aux | grep -E "(kasmvnc|openbox|chrome)" | grep -v grep