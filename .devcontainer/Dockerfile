FROM ghcr.io/linuxserver/baseimage-kasmvnc:ubuntujammy

ENV TITLE="Chrome Desktop"
ENV CUSTOM_PORT=6901
ENV CUSTOM_USER=abc
ENV PASSWORD=abc

# Minimal window manager + Google Chrome
RUN apt-get update && apt-get install -y --no-install-recommends \
    openbox xterm \
    wget gnupg \
    && wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /usr/share/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/usr/share/keyrings/google-chrome.gpg] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy config
COPY kasmvnc.yaml /etc/kasmvnc/kasmvnc.yaml
COPY autostart /root/defaults/autostart

EXPOSE 6901