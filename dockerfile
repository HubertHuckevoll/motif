# Use a lightweight Debian base
FROM debian:bullseye

# Set environment variables
ENV DISPLAY=:0
ENV DEBIAN_FRONTEND=noninteractive

# Install necessary tools and dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    libx11-dev \
    libxt-dev \
    libxext-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxss-dev \
    libmotif-dev \
    x11-apps \
    wget \
    x11-xserver-utils && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and build eMWM
WORKDIR /opt/emwm
RUN wget https://fastestcode.org/dl/emwm-src-1.2.tar.xz && \
    tar -xf emwm-src-1.2.tar.xz && \
    cd emwm-src-1.2 && \
    make && \
    make install

# Download and build eMWM utils
WORKDIR /opt/emwm-utils
RUN wget https://fastestcode.org/dl/emwm-utils-src-1.2.tar.xz && \
    tar -xf emwm-utils-src-1.2.tar.xz && \
    cd emwm-utils-src-1.2 && \
    make && \
    make install

# Set eMWM as the default entrypoint
ENTRYPOINT ["/usr/bin/emwm"]
