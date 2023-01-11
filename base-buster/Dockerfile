# syntax=docker/dockerfile:experimental
ARG SWH_REGISTRY=container-registry.softwareheritage.org/swh/infra/swh-apps/
FROM ${SWH_REGISTRY}rsvndump-base:latest AS rsvndump_image

FROM openjdk:11-jdk-slim-buster

LABEL maintainer="SoftwareHeritage"

USER root

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

# Pin elasticsearch version
RUN echo 'Explanation: profile: elasticsearch\nPackage: elasticsearch elasticsearch-oss\nPin: version 7.10.0\nPin-Priority: -1' > /etc/apt/preferences.d/elasticsearch.pref

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt --mount=type=cache,id=apt-lists,target=/var/lib/apt \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get --allow-releaseinfo-change update && \
  apt-get -y dist-upgrade && \
  apt-get install -y apt-transport-https curl ca-certificates gpg apt dpkg && \
  echo deb [signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] https://apt.postgresql.org/pub/repos/apt/ buster-pgdg main > /etc/apt/sources.list.d/postgres.list && \
  curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor > /usr/share/keyrings/postgres-archive-keyring.gpg && \
  echo deb [signed-by=/usr/share/keyrings/nodejs-archive-keyring.gpg] https://deb.nodesource.com/node_14.x buster main > /etc/apt/sources.list.d/nodejs.list && \
  curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor > /usr/share/keyrings/nodejs-archive-keyring.gpg && \
  echo deb [signed-by=/usr/share/keyrings/yarnpkg-archive-keyring.gpg] https://dl.yarnpkg.com/debian/ stable main > /etc/apt/sources.list.d/yarnpkg.list && \
  curl -fsSL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor > /usr/share/keyrings/yarnpkg-archive-keyring.gpg && \
  echo deb [signed-by=/usr/share/keyrings/elasticsearch-archive-keyring.gpg] https://artifacts.elastic.co/packages/7.x/apt stable main > /etc/apt/sources.list.d/elastic-7.x.list && \
  curl -fsSL https://artifacts.elastic.co/GPG-KEY-elasticsearch | gpg --dearmor > /usr/share/keyrings/elasticsearch-archive-keyring.gpg && \
  echo deb [signed-by=/usr/share/keyrings/cassandra.gpg] https://debian.cassandra.apache.org 40x main > /etc/apt/sources.list.d/cassandra.list && \
  curl -fsSL https://dlcdn.apache.org/cassandra/KEYS | gpg --dearmor > /usr/share/keyrings/cassandra.gpg && \
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
  postgresql-11 \
  postgresql-client-11 \
  postgresql-server-dev-11 \
  pv \
  python3-dev \
  python3-pip \
  python3-venv \
  rabbitmq-server \
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
RUN curl -L https://nixos.org/nix/install -o /tmp/nix_install
RUN sh /tmp/nix_install --daemon --no-channel-add --daemon-user-count 1
ENV PATH="/nix/var/nix/profiles/default/bin/:${PATH}"

RUN pip3 install tree-sitter

# install Azurite, a clone of Azure Blob Storage used for swh-objstorage tests
RUN npm install -g azurite

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

RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
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
