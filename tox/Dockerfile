ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base
LABEL maintainer="SoftwareHeritage"
USER root

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

RUN python3 -m pip install --user --upgrade \
  pip setuptools tox wheel
RUN python3 -m pip install --user --no-warn-script-location \
  Radon pylint coverage codespell
