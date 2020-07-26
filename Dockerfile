FROM ubuntu
RUN apt update \
 && apt install -y autoconf automake cmake g++ libtool pkg-config libva-dev libdrm-dev libpciaccess-dev libx11-dev git vainfo
RUN mkdir -p ~/vaapi \
 && cd ~/vaapi \
 && git clone https://github.com/01org/libva \
 && cd libva \
 && ./autogen.sh --prefix=/usr --libdir=/usr/lib/x86_64-linux-gnu \
 && make \
 && make install \
 && ldconfig
RUN mkdir -p ~/vaapi/workspace \
 && cd ~/vaapi/workspace \
 && git clone https://github.com/intel/gmmlib \
 && mkdir -p build \
 && cd build \
 && cmake -DCMAKE_BUILD_TYPE= Release -DARCH=64 ../gmmlib \
 && make \
 && cd ~/vaapi/workspace \
 && git clone https://github.com/intel/media-driver \
 && cd media-driver \
 && git submodule init \
 && git pull \
 && mkdir -p ~/vaapi/workspace/build_media \
 && cd ~/vaapi/workspace/build_media \
 && cmake ../media-driver \
  -DMEDIA_VERSION="2.0.0" \
  -DBS_DIR_GMMLIB=$PWD/../gmmlib/Source/GmmLib/ \
  -DBS_DIR_COMMON=$PWD/../gmmlib/Source/Common/ \
  -DBS_DIR_INC=$PWD/../gmmlib/Source/inc/ \
  -DBS_DIR_MEDIA=$PWD/../media-driver \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_INSTALL_LIBDIR=/usr/lib/x86_64-linux-gnu \
  -DINSTALL_DRIVER_SYSCONF=OFF \
  -DLIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri \
 && make \
 && make install
ENV LIBVA_DRIVER_NAME=iHD
RUN cd ~/vaapi \
 && git clone https://github.com/Intel-Media-SDK/MediaSDK msdk \
 && cd msdk \
 && git submodule init \
 && git pull \
 && apt install -y libx11-xcb-dev libxcb-dri3-dev libxcb-present-dev \
 && mkdir -p ~/vaapi/build_msdk \
 && cd ~/vaapi/build_msdk \
 && cmake -DCMAKE_BUILD_TYPE=Release -DENABLE_WAYLAND=ON -DENABLE_X11_DRI3=ON -DENABLE_OPENCL=ON  ../msdk \
 && make -j4 \
 && make install \
 && echo '/opt/intel/mediasdk/lib' > /etc/ld.so.conf.d/imsdk.conf \
 && ldconfig
RUN apt install -y libfdk-aac-dev libvorbis-dev libvpx-dev libx264-dev libx265-dev ocl-icd-opencl-dev pkg-config yasm 
ENV PKG_CONFIG_PATH=/opt/intel/mediasdk/lib/pkgconfig
RUN cd /usr/local/src \
 && git clone https://github.com/FFmpeg/FFmpeg \
 && cd FFmpeg \
 && ./configure \
    --prefix=/usr/local/ffmpeg \
    --extra-cflags="-I/opt/intel/mediasdk/include" \
    --extra-ldflags="-L/opt/intel/mediasdk/lib" \
    --extra-ldflags="-L/opt/intel/mediasdk/plugins" \
    --enable-libmfx \
    --enable-vaapi \
    --enable-opencl \
    --disable-debug \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libdrm \
    --enable-gpl \
    --cpu=native \
    --enable-libfdk-aac \
    --enable-libx264 \
    --enable-libx265 \
    --extra-libs=-lpthread \
    --enable-nonfree \
 && make -j4 \
 && make install
COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
