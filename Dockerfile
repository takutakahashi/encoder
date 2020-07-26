FROM jrottenberg/ffmpeg:4.1
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
