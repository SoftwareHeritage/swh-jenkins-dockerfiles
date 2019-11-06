ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base-buster
LABEL maintainer="SoftwareHeritage"
USER root

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y \
    libgtk2.0-0 \
    libnotify-dev \
    libgconf-2-4 \
    libnss3 \
    libxss1 \
    libasound2 \
    xvfb \
    wait-for-it && \
  rm -rf /var/lib/apt/lists/*

USER jenkins

RUN python3 -m pip install --user pyarcanist
