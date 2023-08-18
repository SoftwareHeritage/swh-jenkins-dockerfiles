# syntax=docker/dockerfile:experimental
ARG SWH_REGISTRY=container-registry.softwareheritage.org/swh/infra/swh-apps/
FROM ${SWH_REGISTRY}rsvndump-base:latest AS rsvndump_image

FROM openjdk:11-jdk-slim-buster

LABEL maintainer="SoftwareHeritage"

USER root

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    > /etc/apt/apt.conf.d/keep-cache

# Pin elasticsearch version
ARG ES_PREF=/etc/apt/preferences.d/elasticsearch.pref
RUN echo 'Explanation: profile: elasticsearch' > ${ES_PREF}; \
  echo 'Package: elasticsearch elasticsearch-oss' >> ${ES_PREF}; \
  echo 'Pin: version 7.10.0\nPin-Priority: -1' >> ${ES_PREF}

ARG PGDG_REPO=https://apt.postgresql.org/pub/repos/apt
ARG PGDG_GPG_KEY=https://www.postgresql.org/media/keys/ACCC4CF8.asc
ARG PGDG_KEYRING=/usr/share/keyrings/postgres-archive-keyring.gpg

ARG NODE_REPO=https://deb.nodesource.com/node_18.x
ARG NODE_GPG_KEY=https://deb.nodesource.com/gpgkey/nodesource.gpg.key
ARG NODE_KEYRING=/usr/share/keyrings/nodejs-archive-keyring.gpg

ARG YARN_REPO=https://dl.yarnpkg.com/debian/
ARG YARN_GPG_KEY=https://dl.yarnpkg.com/debian/pubkey.gpg
ARG YARN_KEYRING=/usr/share/keyrings/yarnpkg-archive-keyring.gpg

ARG ELASTIC_REPO=https://artifacts.elastic.co/packages/7.x/apt
ARG ELASTIC_GPG_KEY=https://artifacts.elastic.co/GPG-KEY-elasticsearch
ARG ELASTIC_KEYRING=/usr/share/keyrings/elasticsearch-archive-keyring.gpg

ARG CASSANDRA_REPO=https://debian.cassandra.apache.org
ARG CASSANDRA_GPG_KEY=https://dlcdn.apache.org/cassandra/KEYS
ARG CASSANDRA_KEYRING=/usr/share/keyrings/cassandra.gpg

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=apt-lists,target=/var/lib/apt \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get --allow-releaseinfo-change update && \
  apt-get -y dist-upgrade && \
  apt-get install -y apt-transport-https curl ca-certificates gpg apt dpkg && \
  echo "deb [signed-by=${PGDG_KEYRING}] ${PGDG_REPO} buster-pgdg main" \
    > /etc/apt/sources.list.d/postgres.list && \
  curl -fsSL ${PGDG_GPG_KEY} | gpg --dearmor > ${PGDG_KEYRING} && \
  echo "deb [signed-by=${NODE_KEYRING}] ${NODE_REPO} buster main" \
    > /etc/apt/sources.list.d/nodejs.list && \
  curl -fsSL ${NODE_GPG_KEY} | gpg --dearmor > ${NODE_KEYRING} && \
  echo "deb [signed-by=${YARN_KEYRING}] ${YARN_REPO} stable main" \
    > /etc/apt/sources.list.d/yarnpkg.list && \
  curl -fsSL ${YARN_GPG_KEY} | gpg --dearmor > ${YARN_KEYRING} && \
  echo "deb [signed-by=${ELASTIC_KEYRING}] ${ELASTIC_REPO} stable main" \
    > /etc/apt/sources.list.d/elastic-7.x.list && \
  curl -fsSL ${ELASTIC_GPG_KEY} | gpg --dearmor > ${ELASTIC_KEYRING} && \
  echo "deb [signed-by=${CASSANDRA_KEYRING}] ${CASSANDRA_REPO} 40x main" \
    > /etc/apt/sources.list.d/cassandra.list && \
  curl -fsSL ${CASSANDRA_GPG_KEY} | gpg --dearmor > ${CASSANDRA_KEYRING} && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y \
  arcanist \
  build-essential \
  cassandra \
  cpio \
  curl \
  cvs \
  elasticsearch \
  fontconfig \
  fuse3 \
  git-lfs \
  googletest \
  jq \
  libcmph-dev \
  libfuse3-dev \
  libsvn-dev \
  libsystemd-dev \
  lzip \
  maven \
  mercurial \
  nodejs \
  pkg-config \
  postgresql-12 \
  postgresql-client-12 \
  postgresql-server-dev-12 \
  pv \
  python3-dev \
  python3-pip \
  python3-venv \
  rabbitmq-server \
  r-base-core \
  redis-server \
  rpm2cpio \
  subversion \
  tini \
  valgrind \
  yarn \
  zstd && \
  apt-get install -y --no-install-recommends \
  opam

# Install rsvndump (for svn loader)
COPY --from=rsvndump_image /usr/local/bin/rsvndump /usr/local/bin/rsvndump

# install emscripten required for generating tree-sitter WASM module in swh-search
RUN cd /opt && git clone https://github.com/emscripten-core/emsdk.git && cd emsdk \
  && ./emsdk install latest && ./emsdk activate latest
ENV PATH="${PATH}:/opt/emsdk/upstream/emscripten"

# install nix binaries that can be used by swh directory loader
RUN curl -L https://nixos.org/nix/install -o /tmp/nix_install && \
  sh /tmp/nix_install --daemon --no-channel-add --daemon-user-count 1 && \
  rm /tmp/nix_install
ENV PATH="/nix/var/nix/profiles/default/bin/:${PATH}"

RUN pip3 install tree-sitter

# install Azurite, a clone of Azure Blob Storage used for swh-objstorage tests
RUN npm install -g azurite

# install sentry CLI
RUN curl -sL https://sentry.io/get-cli/ -o /tmp/sentry-install && \
  bash /tmp/sentry-install && \
  rm /tmp/sentry-install


# install libs for building ruby from source
SHELL ["/bin/bash", "-c"]
RUN apt update && \
  apt install -y procps libssl-dev libreadline-dev zlib1g-dev \
  autoconf bison libyaml-dev \
  libncurses5-dev libffi-dev libgdbm-dev

# install rbenv, build ruby 3.0.1, and install bibliothecary,
# which needs Ruby >= 2.7
# TODO: use system ruby instead when updating base image to Debian >= 11
RUN git clone https://github.com/rbenv/rbenv.git /usr/local/.rbenv && \
    git clone https://github.com/rbenv/ruby-build.git /usr/local/.rbenv/plugins/ruby-build && \
    echo 'export PATH="/usr/local/.rbenv/bin:$PATH"' >> /etc/profile && \
    echo 'export RBENV_ROOT="/usr/local/.rbenv"' >> /etc/profile && \
    echo 'eval "$(rbenv init -)"' >> /etc/profile && \
    echo 'export PATH="/usr/local/.rbenv/plugins/ruby-build/bin:$PATH"' >> /etc/profile && \
    source /etc/profile && \
    rbenv install 3.0.1 && \
    rbenv global 3.0.1 && \
    gem install bibliothecary

ENV PATH="${PATH}:/usr/local/.rbenv/shims"

## vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ##
# inlined from https://raw.githubusercontent.com/jenkinsci/docker-agent/4.13.3-2/11/bullseye/Dockerfile
#
# The MIT License
#
#  Copyright (c) 2015-2020, CloudBees, Inc. and other Jenkins contributors
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

ARG VERSION=4.13
ARG user=jenkins
ARG group=jenkins
ARG uid=115
ARG gid=120
ARG docker_gid=999

RUN groupadd -g ${gid} ${group}
RUN groupadd -g ${docker_gid} docker
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
RUN gpasswd -a jenkins docker

ARG AGENT_WORKDIR=/home/${user}/agent

RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar \
    https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

ENV LANG C.UTF-8

ENV PATH "${PATH}:/home/${user}/.local/bin"

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}
