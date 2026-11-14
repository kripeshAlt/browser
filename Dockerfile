
FROM lscr.io/linuxserver/firefox:1159.0.1

ENV PUID=1000
ENV PGID=1000
ENV TZ=Etc/UTC
ENV CUSTOM_USER=browser
ENV PASSWORD=change-this-password
ENV FIREFOX_CLI=about:blank

EXPOSE 3000
EXPOSE 3001
