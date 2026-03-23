FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install KasmVNC (latest stable)
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget ca-certificates \
    # Desktop environment (ultra lightweight)
    openbox obconf xterm \
    # Audio stack
    pulseaudio ffmpeg \
    # Useful apps
    firefox-esr \
    dbus-x11 \
    && wget https://github.com/kasmtech/KasmVNC/releases/download/v1.4.0/kasmvncserver_bookworm_1.4.0_amd64.deb \
       -O /tmp/kasmvnc.deb \
    || wget https://github.com/kasmtech/KasmVNC/releases/download/v1.4.0/kasmvncserver_jammy_1.4.0_amd64.deb \
       -O /tmp/kasmvnc.deb \
    && apt-get install -y /tmp/kasmvnc.deb \
    && rm /tmp/kasmvnc.deb \
    && adduser vscode ssl-cert \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy optimized config
COPY config/kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml
COPY scripts/start-desktop.sh /home/vscode/scripts/start-desktop.sh
RUN chmod +x /home/vscode/scripts/start-desktop.sh

USER vscode