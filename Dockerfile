FROM jrottenberg/ffmpeg:4.1-vaapi
WORKDIR /
COPY entrypoint.sh /entrypoint.sh
COPY encode.sh /encode.sh
ENTRYPOINT ["/entrypoint.sh"]
