FROM jrottenberg/ffmpeg:4.1-vaapi
COPY entrypoint.sh /
ENTRYPOINT ['/entrypoint.sh']
