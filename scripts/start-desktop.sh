#!/bin/bash
set -e

export DISPLAY=:1
export HOME=/home/vscode

# ============================================
# 1. KILL ANY EXISTING SESSIONS
# ============================================
vncserver -kill :1 2>/dev/null || true
sleep 1

# ============================================
# 2. SET VNC PASSWORD
# ============================================
mkdir -p ~/.vnc
echo -e "password\npassword\n" | vncpasswd -u vscode -w -r

# ============================================
# 3. START KASMVNC WITH OPTIMIZED FLAGS
# ============================================
vncserver :1 \
  -geometry 1920x1080 \
  -depth 24 \
  -websocketPort 6901 \
  -interface 0.0.0.0 \
  -FrameRate 60 \
  -BlacklistThreshold 0 \
  -FreeKeyMappings \
  -PreferBandwidth \
  -DynamicQualityMin 4 \
  -DynamicQualityMax 7 \
  -select-de manual

sleep 2

# ============================================
# 4. START WINDOW MANAGER (Openbox = lightest)
# ============================================
openbox --startup "xterm" &

# ============================================
# 5. START PULSEAUDIO + AUDIO PIPELINE
# ============================================
# Start PulseAudio daemon
pulseaudio --start --exit-idle-time=-1

echo ""
echo "======================================================"
echo "  KasmVNC running on port 6901"
echo "  Open the forwarded port in your browser"
echo "  Username: vscode"
echo "======================================================"
echo ""

# Keep alive
tail -f ~/.vnc/*.log