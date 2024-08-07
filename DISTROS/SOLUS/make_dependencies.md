# These dependencies are for handbrake, but they allow make to function correctly.


# Dependencies:

#    autoconf    automake    binutils    bzip2-devel    cargo    cargo-c    cmake    g++    gcc
#    git    glibc-devel    lame-devel    libass-devel    libjpeg-turbo-devel    libogg-devel
#    libtheora-devel    libtool-devel    libspeex-devel    libvorbis-devel    libvpx-devel
#    libxml2-devel    linux-headers    m4    make    meson    nasm    ninja    numactl-devel
#    opus-devel    patch    pkg-config    rust    x264-devel    xz-devel    zlib-devel

# Intel Quick Sync Video dependencies (optional):

#    libva-devel    libdrm-devel

# Graphical interface dependencies:

#    appstream    desktop-file-utils    gstreamer-1.0-plugins-good    gstreamer-1.0-libav
#    gstreamer-1.0-plugins-base-devel    libgtk-3-devel

### Install dependencies.

sudo eopkg install autoconf automake binutils bzip2-devel cargo cargo-c cmake g++ gcc git glibc-devel lame-devel libass-devel libjpeg-turbo-devel libogg-devel libtheora-devel libtool-devel libspeex-devel libvorbis-devel libvpx-devel libxml2-devel linux-headers m4 make meson nasm ninja numactl-devel opus-devel patch pkg-config rust x264-devel xz-devel zlib-devel

# To build with Intel Quick Sync Video support, install the QSV dependencies.

sudo eopkg install libva-devel libdrm-devel

# To build the GTK GUI, install the graphical interface dependencies.

sudo eopkg install appstream desktop-file-utils gstreamer-1.0-plugins-good gstreamer-1.0-libav gstreamer-1.0-plugins-base-devel libgtk-3-devel
