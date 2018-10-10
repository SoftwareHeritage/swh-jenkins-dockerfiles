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
    pkg-config

# install postgresql 10
RUN echo deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main > /etc/apt/sources.list.d/postgres.list
RUN wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add -
RUN apt-get update && \
    apt-get install -y \
	  postgresql-10 \
	  postgresql-client-10 \
	  libpq-dev \
	  arcanist && \
	rm -rf /var/lib/apt/lists/*

USER jenkins
