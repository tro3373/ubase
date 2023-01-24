FROM ubuntu:latest

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
    firefox \
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
    chown -R user:user /home/user
