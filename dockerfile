# Use a lightweight Debian base
FROM debian:bookworm-slim

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# 1) System‑Tools, SDL, unzip, X‑libs, editors, ...
RUN apt-get update && apt-get install -y \
    build-essential \
    unzip \
    libsdl2-2.0-0 libsdl2-net-2.0-0 \
    libx11-dev libxt-dev libxext-dev libxinerama-dev \
    libxrandr-dev libxss-dev libxpm-dev libmotif-dev \
    libjpeg-dev libtiff-dev \
    x11-apps x11-utils xterm wget nedit gimp \
    x11-xserver-utils && \
  apt-get clean && rm -rf /var/lib/apt/lists/*

# 2) App‑Icons
WORKDIR /tmp
RUN mkdir -p /usr/share/icons && \
    wget https://fastestcode.org/dl/app-icons.tar.xz && \
    tar -xf app-icons.tar.xz -C /usr/share/icons --strip-components=1 && \
    rm app-icons.tar.xz

# 3) eMWM selbst bauen
WORKDIR /opt/emwm
RUN wget https://fastestcode.org/dl/emwm-src-1.2.tar.xz && \
    tar -xf emwm-src-1.2.tar.xz && \
    cd emwm-src-1.2 && \
    make && make install

# 4) eMWM‑Utilities
WORKDIR /opt/emwm-utils
RUN wget https://fastestcode.org/dl/emwm-utils-src-1.2.tar.xz && \
    tar -xf emwm-utils-src-1.2.tar.xz && \
    cd emwm-utils-src-1.2 && \
    make && make install

# 5) XFile
WORKDIR /opt/xfile
RUN wget https://fastestcode.org/dl/xfile-src-1.0-beta.tar.xz && \
    tar -xf xfile-src-1.0-beta.tar.xz && \
    cd xfile-beta && make && make install

# 6) XImage
WORKDIR /opt/xfile
RUN wget https://fastestcode.org/dl/ximaging-src-1.8.tar.xz && \
    tar -xf ximaging-src-1.8.tar.xz && \
    cd ximaging-src-1.8 && make && make install

# 7) Deine lokalen Ressourcen & Config bereitstellen
#    (Build‑Context: ./inserts/resources und ./inserts/basebox.conf)
COPY inserts/resources /tmp/resources
COPY inserts/basebox.conf /tmp/basebox.conf

# 8) Basebox installieren und richtig verlinken
RUN wget -O /tmp/pcgeos-basebox.zip \
      https://github.com/bluewaysw/pcgeos-basebox/releases/download/CI-latest-issue-2/pcgeos-basebox.zip && \
    unzip /tmp/pcgeos-basebox.zip -d /opt/basebox && \
    rm /tmp/pcgeos-basebox.zip && \
    \
    # Ressourcen (Shaders, Fonts ...) + Deine Conf ins binl64‑Verzeichnis
    cp -r /tmp/resources /opt/basebox/pcgeos-basebox/binl64/ && \
    cp /tmp/basebox.conf /opt/basebox/pcgeos-basebox/binl64/basebox.conf && \
    rm -rf /tmp/resources /tmp/basebox.conf && \
    \
    # Alles nach /usr/local/share/basebox und Symlink
    install -d /usr/local/share/basebox && \
    cp -r /opt/basebox/pcgeos-basebox/binl64/* /usr/local/share/basebox/ && \
    ln -sf /usr/local/share/basebox/basebox /usr/local/bin/basebox

# 9) PC/GEOS selbst
RUN mkdir -p /root/geos && \
    wget -O /tmp/geos.zip \
      https://github.com/bluewaysw/pcgeos/releases/download/CI-latest/pcgeos-ensemble_nc.zip && \
    unzip /tmp/geos.zip -d /root/geos && \
    rm /tmp/geos.zip

# 10) eMWM als EntryPoint
ENTRYPOINT ["/usr/bin/xmsm"]
