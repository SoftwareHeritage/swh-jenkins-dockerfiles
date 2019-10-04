FROM jenkins/jnlp-slave
LABEL maintainer="SoftwareHeritage"
USER root

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y apt-transport-https && \
  echo deb http://deb.debian.org/debian/ stretch-backports main > /etc/apt/sources.list.d/backports.list && \
  echo deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main > /etc/apt/sources.list.d/postgres.list && \
  wget --quiet -O /etc/apt/trusted.gpg.d/postgresql.asc https://www.postgresql.org/media/keys/ACCC4CF8.asc && \
  echo deb https://dl.yarnpkg.com/debian/ stable main > /etc/apt/sources.list.d/yarnpkg.list && \
  wget --quiet -O /etc/apt/trusted.gpg.d/yarnpkg.asc https://dl.yarnpkg.com/debian/pubkey.gpg && \
  echo deb https://artifacts.elastic.co/packages/7.x/apt stable main > /etc/apt/sources.list.d/elastic-7.x.list && \
  wget --quiet -O /etc/apt/trusted.gpg.d/elastic.asc https://artifacts.elastic.co/GPG-KEY-elasticsearch && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y -t stretch-backports \
    nodejs && \
  apt-get install -y \
    arcanist \
    build-essential \
    curl \
    jq \
    libsvn-dev \
    libsystemd-dev \
    pkg-config \
    postgresql-10 \
    postgresql-client-10 \
    postgresql-server-dev-10 \
    elasticsearch \
    python3-dev \
    python3-pip \
    python3-venv \
    yarn \
  && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

USER jenkins
