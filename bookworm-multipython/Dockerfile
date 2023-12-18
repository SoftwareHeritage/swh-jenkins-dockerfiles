# syntax=docker/dockerfile:experimental
FROM debian:bookworm-slim as build_bookworm_base

USER root

ARG user=jenkins
ARG group=jenkins
ARG uid=115
ARG gid=120
ARG docker_gid=999

ARG py37_version=3.7.16
ARG py38_version=3.8.18
ARG py39_version=3.9.18
ARG py310_version=3.10.13
ARG py311_version=3.11.7
ARG py312_version=3.12.1

RUN groupadd -g ${gid} ${group}
RUN groupadd -g ${docker_gid} docker
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
RUN gpasswd -a jenkins docker

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get --allow-releaseinfo-change update && \
  apt-get -y dist-upgrade && \
  apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    ca-certificates \
    git \
    gpg \
    openjdk-17-jre-headless

RUN rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' \
    > /etc/apt/apt.conf.d/keep-cache

FROM build_bookworm_base AS build_bookworm_with_packages

# Pin elasticsearch version
ARG ES_PREF=/etc/apt/preferences.d/elasticsearch.pref
RUN echo 'Explanation: profile: elasticsearch' > ${ES_PREF}; \
  echo 'Package: elasticsearch elasticsearch-oss' >> ${ES_PREF}; \
  echo 'Pin: version 7.10.0\nPin-Priority: -1' >> ${ES_PREF}

ARG PGDG_REPO=https://apt.postgresql.org/pub/repos/apt
ARG PGDG_GPG_KEY=https://www.postgresql.org/media/keys/ACCC4CF8.asc
ARG PGDG_KEYRING=/etc/apt/keyrings/postgres-archive-keyring.gpg

ARG NODE_REPO=https://deb.nodesource.com/node_18.x
ARG NODE_GPG_KEY=https://deb.nodesource.com/gpgkey/nodesource.gpg.key
ARG NODE_KEYRING=/etc/apt/keyrings/nodejs-archive-keyring.gpg

ARG YARN_REPO=https://dl.yarnpkg.com/debian/
ARG YARN_GPG_KEY=https://dl.yarnpkg.com/debian/pubkey.gpg
ARG YARN_KEYRING=/etc/apt/keyrings/yarnpkg-archive-keyring.gpg

ARG ELASTIC_REPO=https://artifacts.elastic.co/packages/7.x/apt
ARG ELASTIC_GPG_KEY=https://artifacts.elastic.co/GPG-KEY-elasticsearch
ARG ELASTIC_KEYRING=/etc/apt/keyrings/elasticsearch-archive-keyring.gpg

ARG CASSANDRA_REPO=https://debian.cassandra.apache.org
ARG CASSANDRA_GPG_KEY=https://dlcdn.apache.org/cassandra/KEYS
ARG CASSANDRA_KEYRING=/etc/apt/keyrings/cassandra.gpg

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt \
    --mount=type=cache,id=apt-lists,target=/var/lib/apt \
  echo "deb [signed-by=${PGDG_KEYRING}] ${PGDG_REPO} bookworm-pgdg main" \
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
  mkdir -p /etc/postgresql-common && \
  echo create_main_cluster=false > /etc/postgresql-common/createcluster.conf && \
  apt-get install -y \
  bubblewrap \
  cassandra \
  clang-format \
  cpio \
  cvs \
  elasticsearch \
  fontconfig \
  fuse3 \
  gdb \
  git-lfs \
  googletest \
  jq \
  lcov \
  libcapture-tiny-perl \
  libcmph-dev \
  libdatetime-perl \
  libfuse3-dev \
  libgtest-dev \
  libmagic-dev \
  libsvn-dev \
  libsystemd-dev \
  lzip \
  maven \
  mercurial \
  nodejs \
  pkg-config \
  postgresql-15 \
  postgresql-client-15 \
  postgresql-server-dev-15 \
  pv \
  r-base-core \
  rabbitmq-server \
  redis-server \
  ruby \
  ruby-dev \
  rpm2cpio \
  subversion \
  tree \
  valgrind \
  yarn \
  zstd

# Install openjdk 11 from eclipse-temurin (needed for cassandra)
ENV JAVA_HOME=/opt/java/openjdk
COPY --from=eclipse-temurin:11 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Install rsvndump from swh registry (needed for swh-loader-svn)
COPY --from=container-registry.softwareheritage.org/swh/infra/swh-apps/rsvndump-base:latest /usr/local/bin/rsvndump /usr/local/bin/rsvndump

USER ${user}
WORKDIR /home/${user}

ENV LANG C.UTF-8

ENV PATH "/home/${user}/.local/bin:${PATH}"

# Prepare npm package prefix
RUN mkdir -p /home/${user}/.local/npm-packages && \
  npm config set prefix /home/${user}/.local/npm-packages
ENV PATH "/home/${user}/.local/npm-packages/bin:${PATH}"


# install emscripten required for generating tree-sitter WASM module in swh-search
COPY --from=emscripten/emsdk:latest /emsdk /emsdk
ENV PATH="/emsdk/upstream/emscripten:${PATH}"

# install Azurite, a clone of Azure Blob Storage used for swh-objstorage tests
RUN npm install -g azurite

# install sentry CLI
RUN mkdir -p /home/${user}/.local/bin && \
  curl -sL https://sentry.io/get-cli/ -o /tmp/sentry-install && \
  env INSTALL_DIR=/home/${user}/.local/bin bash /tmp/sentry-install && \
  rm /tmp/sentry-install

# install bibliothecary, needed for swh-indexer
ENV GEM_HOME=/home/${user}/.local/rubygems
RUN gem install bibliothecary

ARG opam_version=2.0.10

# install opam
RUN curl -sL https://raw.githubusercontent.com/ocaml/opam/master/shell/install.sh -o /tmp/opam-install && \
  cd /home/${user}/.local/bin && \
  bash /tmp/opam-install --version ${opam_version} --download-only && \
  chmod +x opam-* && \
  ln -s opam-* opam && \
  rm /tmp/opam-install

# Install rustup and the default rust toolchain

ENV CARGO_HOME="/home/${user}/.cargo"
ENV RUSTUP_HOME="/home/${user}/.rustup"

RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs -o /tmp/rustup-init.sh && \
  chmod +x /tmp/rustup-init.sh && \
  /tmp/rustup-init.sh -y && \
  rm /tmp/rustup-init.sh

ENV PATH="${CARGO_HOME}/bin:${PATH}"

COPY ./prepare-cargo-cache ${CARGO_HOME}/bin

# install rage (for swh-alter)

FROM build_bookworm_with_packages as build_rage
# Use the latest available version so we can detect if rage behavior has changed when
# testing swh-alter. Otherwise, this might only be detected when processing a
# takedown notice or restoring a bundle… which would not be a nice experience.
RUN cargo install rage

FROM build_bookworm_with_packages AS build_bookworm_with_packages_and_rage
COPY --from=build_rage /home/${user}/.cargo/bin/rage /home/${user}/.cargo/bin/rage-keygen /home/${user}/.cargo/bin

# install pyenv

FROM build_bookworm_base AS build_pyenv

USER root

RUN apt-get -y install \
    libssl-dev \
    zlib1g-dev \
    libbz2-dev \
    libreadline-dev \
    libsqlite3-dev \
    curl \
    libncursesw5-dev \
    xz-utils \
    tk-dev \
    libxml2-dev \
    libxmlsec1-dev \
    libffi-dev \
    liblzma-dev \
    # pypy build dependencies
    llvm

USER ${user}

RUN git clone https://github.com/pyenv/pyenv.git ~/.pyenv && cd ~/.pyenv && src/configure && make -C src
ENV PYENV_ROOT "/home/${user}/.pyenv"
ENV PATH="${PATH}:/home/${user}/.pyenv/bin"

FROM build_pyenv AS build_py37
RUN env PYTHON_CONFIGURE_OPTS='--with-lto' MAKEOPTS='-j8' pyenv install --verbose --keep ${py37_version}

FROM build_pyenv AS build_py38
RUN env PYTHON_CONFIGURE_OPTS='--with-lto' MAKEOPTS='-j8' pyenv install --verbose --keep ${py38_version}

FROM build_pyenv AS build_py39
RUN env PYTHON_CONFIGURE_OPTS='--with-lto' MAKEOPTS='-j8' pyenv install --verbose --keep ${py39_version}

FROM build_pyenv as build_py310
RUN env PYTHON_CONFIGURE_OPTS='--with-lto' MAKEOPTS='-j8' pyenv install --verbose --keep ${py310_version}

FROM build_pyenv as build_py311
RUN env PYTHON_CONFIGURE_OPTS='--with-lto' MAKEOPTS='-j8' pyenv install --verbose --keep ${py311_version}

FROM build_pyenv as build_py312
RUN env PYTHON_CONFIGURE_OPTS='--with-lto' MAKEOPTS='-j8' pyenv install --verbose --keep ${py312_version}

FROM build_bookworm_with_packages_and_rage

ENV PYENV_ROOT "/home/${user}/.pyenv"
ENV PATH="${PYENV_ROOT}/shims:${PATH}:${PYENV_ROOT}/bin"

COPY --from=build_pyenv --chown=jenkins:jenkins ${PYENV_ROOT} ${PYENV_ROOT}

COPY --from=build_py37 --chown=jenkins:jenkins ${PYENV_ROOT}/versions/${py37_version} ${PYENV_ROOT}/versions/${py37_version}
COPY --from=build_py37 --chown=jenkins:jenkins ${PYENV_ROOT}/sources/${py37_version} ${PYENV_ROOT}/sources/${py37_version}

COPY --from=build_py38 --chown=jenkins:jenkins ${PYENV_ROOT}/versions/${py38_version} ${PYENV_ROOT}/versions/${py38_version}
COPY --from=build_py38 --chown=jenkins:jenkins ${PYENV_ROOT}/sources/${py38_version} ${PYENV_ROOT}/sources/${py38_version}

COPY --from=build_py39 --chown=jenkins:jenkins ${PYENV_ROOT}/versions/${py39_version} ${PYENV_ROOT}/versions/${py39_version}
COPY --from=build_py39 --chown=jenkins:jenkins ${PYENV_ROOT}/sources/${py39_version} ${PYENV_ROOT}/sources/${py39_version}

COPY --from=build_py310 --chown=jenkins:jenkins ${PYENV_ROOT}/versions/${py310_version} ${PYENV_ROOT}/versions/${py310_version}
COPY --from=build_py310 --chown=jenkins:jenkins ${PYENV_ROOT}/sources/${py310_version} ${PYENV_ROOT}/sources/${py310_version}

COPY --from=build_py311 --chown=jenkins:jenkins ${PYENV_ROOT}/versions/${py311_version} ${PYENV_ROOT}/versions/${py311_version}
COPY --from=build_py311 --chown=jenkins:jenkins ${PYENV_ROOT}/sources/${py311_version} ${PYENV_ROOT}/sources/${py311_version}

COPY --from=build_py312 --chown=jenkins:jenkins ${PYENV_ROOT}/versions/${py312_version} ${PYENV_ROOT}/versions/${py312_version}
COPY --from=build_py312 --chown=jenkins:jenkins ${PYENV_ROOT}/sources/${py312_version} ${PYENV_ROOT}/sources/${py312_version}

RUN pyenv rehash
RUN pyenv global ${py37_version} ${py38_version} ${py39_version} ${py310_version} ${py311_version} ${py312_version}

ENV SWH_PYTHON_FOR_GLOBAL_TOOLS python3.11

RUN mkdir /home/${user}/.cache

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
ARG AGENT_WORKDIR=/home/${user}/agent

USER root

RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar \
    https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
