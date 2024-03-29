# FROM ubuntu:latest
FROM ubuntu:22.04

ENV DEBIAN_FRONTEND noninteractive
ENV LANG ja_JP.UTF-8

COPY mozilla-firefox /etc/apt/preferences.d/mozilla-firefox
COPY 51unattended-upgrades-firefox /etc/apt/apt.conf.d/51unattended-upgrades-firefox

RUN sed -i.org -e 's|ports.ubuntu.com|jp.archive.ubuntu.com|g' /etc/apt/sources.list \
    && apt-get update \
    && apt-get install -y software-properties-common \
    && add-apt-repository ppa:mozillateam/ppa \
    && apt-get update

RUN apt-get install -y \
    tzdata \
    locales \
    fonts-noto-cjk \
    dbus-x11 \
    pulseaudio \
    fcitx-mozc \
    wget \
    firefox \
    sudo \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && ln -s -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime \
    && dpkg-reconfigure tzdata \
    && locale-gen ja_JP.UTF-8

ARG uid=1001
ARG gid=1001
# ARG docker_user=1001:1001
# RUN useradd -m -u $(echo $docker_user |cut -d: -f1) user
# RUN useradd -m -u ${uid} user
RUN groupadd -g ${gid} user && \
    useradd -m -s /bin/bash -u ${uid} -g user user && \
    chown root:root /home/user && \
    chown -R user:user /home/user && \
    usermod -aG sudo user && \
    echo 'user     ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

# wine7だとうごくのか？
#   - [Ubuntu で Wine7 を使って Kindle を読む - Qiita](https://qiita.com/nanbuwks/items/a8f3b558cae92e5576bf)
#   - [Ubuntu 22.04 で Wine7 を使って Kindle を読む - Qiita](https://qiita.com/nanbuwks/items/088ff915b93ffde8a6dd)
# Insatall wine for ubuntu 22.04
RUN dpkg --add-architecture i386 && \
    mkdir -pm755 /etc/apt/keyrings && \
    wget -O /etc/apt/keyrings/winehq-archive.key https://dl.winehq.org/wine-builds/winehq.key && \
    wget -NP /etc/apt/sources.list.d/ https://dl.winehq.org/wine-builds/ubuntu/dists/jammy/winehq-jammy.sources && \
    apt-get update && \
    export WINEVERSION=7.0.1~jammy-1 && \
    apt-get install -y --install-recommends \
        winehq-stable=$WINEVERSION \
        wine-stable=$WINEVERSION \
        wine-stable-amd64=$WINEVERSION \
        wine-stable-i386=$WINEVERSION \
        winetricks

# RUN winetricks --version && \
#     winetricks --self-update && \
#     winetricks --version && \
#     winetricks -q cjkfonts vcrun2013

