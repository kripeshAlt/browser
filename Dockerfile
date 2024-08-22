# Use an official Ubuntu as a parent image
FROM ubuntu:20.04

# Set environment variables to prevent prompts during installation
ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    wget \
    curl \
    xfce4 \
    xfce4-goodies \
    tightvncserver \
    novnc \
    websockify \
    google-chrome-stable \
    --no-install-recommends && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install Google Chrome
RUN wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list' && \
    apt-get update && apt-get install -y google-chrome-stable

# Create a VNC startup script
RUN mkdir -p ~/.vnc
RUN echo "#!/bin/sh\n\
unset SESSION_MANAGER\n\
unset DBUS_SESSION_BUS_ADDRESS\n\
startxfce4 &\n\
/usr/bin/google-chrome-stable --no-sandbox --disable-dev-shm-usage &\n\
" > ~/.vnc/xstartup
RUN chmod +x ~/.vnc/xstartup

# Set VNC password (for simplicity, it's set as 'password')
RUN echo "password" | vncpasswd -f > ~/.vnc/passwd
RUN chmod 600 ~/.vnc/passwd

# Expose VNC and noVNC ports
EXPOSE 5901 6080

# Start VNC and noVNC
CMD vncserver :1 -geometry 1024x768 -depth 16 && \
    websockify --web=/usr/share/novnc/ 6080 localhost:5901
