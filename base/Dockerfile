FROM jenkins/jnlp-slave
LABEL maintainer="SoftwareHeritage"
USER root

# some base packages
RUN apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
    build-essential \
    curl \
    python3-dev \
    python3-pip \
    python3-venv libsvn-dev \
    libsystemd-dev \
    pkg-config && \
  rm -rf /var/lib/apt/lists/*

USER jenkins
