
FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive
ENV DISPLAY=:99
ENV RESOLUTION=1024x768x16
ENV PORT=10000

RUN apt-get update && apt-get install -y --no-install-recommends \
    chromium \
    xvfb \
    openbox \
    x11vnc \
    x11-utils \
    novnc \
    websockify \
    dbus-x11 \
    ca-certificates \
    fonts-liberation \
    fonts-noto \
    dos2unix \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash browser

COPY start.sh /start.sh

RUN dos2unix /start.sh \
    && chmod +x /start.sh \
    && chown browser:browser /start.sh

USER browser
WORKDIR /home/browser

EXPOSE 10000

CMD ["/bin/bash", "/start.sh"]
