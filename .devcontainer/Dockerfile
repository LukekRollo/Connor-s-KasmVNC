FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg ca-certificates \
    openbox dbus-x11 xterm \
    libgl1-mesa-dri libglu1-mesa \
    ssl-cert x11-xserver-utils \
    && \
    # KasmVNC
    wget -q https://github.com/kasmtech/KasmVNC/releases/download/v1.3.3/kasmvncserver_jammy_1.3.3_amd64.deb \
      -O /tmp/kasmvnc.deb && \
    apt-get install -y /tmp/kasmvnc.deb && \
    rm /tmp/kasmvnc.deb && \
    adduser vscode ssl-cert && \
    # Google Chrome
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Pre-create VNC password during build so it always exists
RUN mkdir -p /home/vscode/.vnc && \
    echo -e "vscode:password" > /home/vscode/.vnc/kasmpasswd && \
    chmod 0600 /home/vscode/.vnc/kasmpasswd && \
    chown -R vscode:vscode /home/vscode/.vnc

# Generate machine-id (Chrome needs this)
RUN dbus-uuidgen > /etc/machine-id

COPY kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml
COPY start-vnc.sh /opt/start-vnc.sh
RUN chmod +x /opt/start-vnc.sh && \
    chmod 644 /etc/kasmvnc/kasmvnc.yaml