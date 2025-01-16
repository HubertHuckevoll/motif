# Use a lightweight Debian base
FROM debian:bullseye-slim

# Set environment variables
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools, libraries, and optional apps
RUN apt-get update && apt-get install -y \
    build-essential \
    libx11-dev \
    libxt-dev \
    libxext-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxss-dev \
    libxpm-dev \
    libmotif-dev \
    libjpeg-dev \
    libtiff-dev \
    x11-apps \
    x11-utils \
    xterm \
    wget \
    nedit \
    gimp \
    x11-xserver-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy and extract the app icons
WORKDIR /tmp
RUN mkdir -p /usr/share/icons && \
    wget https://fastestcode.org/dl/app-icons.tar.xz && \
    tar -xf /tmp/app-icons.tar.xz -C /usr/share/icons --strip-components=1 && \
    rm /tmp/app-icons.tar.xz

# Download and build eMWM
WORKDIR /opt/emwm
RUN wget https://fastestcode.org/dl/emwm-src-1.2.tar.xz && \
    tar -xf emwm-src-1.2.tar.xz && \
    cd emwm-src-1.2 && \
    make && \
    make install

# Download and build eMWM utilities
WORKDIR /opt/emwm-utils
RUN wget https://fastestcode.org/dl/emwm-utils-src-1.2.tar.xz && \
    tar -xf emwm-utils-src-1.2.tar.xz && \
    cd emwm-utils-src-1.2 && \
    make && \
    make install


# Download and build XFile
WORKDIR /opt/xfile
RUN wget https://fastestcode.org/dl/xfile-src-1.0-beta.tar.xz && \
    tar -xf xfile-src-1.0-beta.tar.xz && \
    cd xfile-beta && \
    make && \
    make install

# Download and build XImage
WORKDIR /opt/xfile
RUN wget https://fastestcode.org/dl/ximaging-src-1.8.tar.xz && \
    tar -xf ximaging-src-1.8.tar.xz && \
    cd ximaging-src-1.8 && \
    make && \
    make install

# Set eMWM as the default entrypoint
ENTRYPOINT ["/usr/bin/xmsm"]
