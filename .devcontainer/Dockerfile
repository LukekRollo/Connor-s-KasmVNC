FROM mcr.microsoft.com/devcontainers/base:ubuntu-22.04

ENV DEBIAN_FRONTEND=noninteractive

# Install KasmVNC + Chrome + minimal window manager
RUN apt-get update && apt-get install -y --no-install-recommends \
    wget gnupg ca-certificates \
    openbox dbus-x11 xterm \
    libgl1-mesa-dri libglu1-mesa \
    ssl-cert \
    && \
    # Install KasmVNC
    wget -q https://github.com/kasmtech/KasmVNC/releases/download/v1.3.3/kasmvncserver_jammy_1.3.3_amd64.deb \
      -O /tmp/kasmvnc.deb && \
    apt-get install -y /tmp/kasmvnc.deb && \
    rm /tmp/kasmvnc.deb && \
    adduser vscode ssl-cert && \
    # Install Google Chrome
    wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg && \
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list && \
    apt-get update && \
    apt-get install -y google-chrome-stable && \
    # Cleanup
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Create KasmVNC config directory
RUN mkdir -p /etc/kasmvnc

# Write KasmVNC config — disable SSL (Codespaces handles HTTPS via its proxy)
RUN echo '\
desktop:\n\
  resolution:\n\
    width: 1920\n\
    height: 1080\n\
  allow_resize: true\n\
  pixel_depth: 24\n\
\n\
network:\n\
  protocol: http\n\
  interface: 0.0.0.0\n\
  websocket_port: 6901\n\
  ssl:\n\
    require_ssl: false\n\
    pem_certificate: /etc/ssl/certs/ssl-cert-snakeoil.pem\n\
    pem_key: /etc/ssl/private/ssl-cert-snakeoil.key\n\
\n\
encoding:\n\
  max_frame_rate: 60\n\
  rect_encoding_mode:\n\
    min_quality: 7\n\
    max_quality: 9\n\
    rectangle_compress_threads: 4\n\
  video_encoding_mode:\n\
    enter_video_encoding_mode:\n\
      time_threshold: 2\n\
      area_fraction_threshold: 0.3\n\
  compare_framebuffer: auto\n\
  zrle_zlib_level: 1\n\
  treat_lossless: 8\n\
\n\
runtime_configuration:\n\
  allow_client_to_override_kasm_server_settings: true\n\
\n\
logging:\n\
  level: 30\n' > /etc/kasmvnc/kasmvnc.yaml

# Copy startup script
COPY start-vnc.sh /home/vscode/.devcontainer/start-vnc.sh
RUN chmod +x /home/vscode/.devcontainer/start-vnc.sh