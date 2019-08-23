ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y --no-install-recommends \
    crudini \
    dia \
    graphviz \
    inkscape \
    libffi-dev \
    make \
    myrepos \
    plantuml \
    postgresql-autodoc \
    rsync \
    tox \
  && rm -rf /var/lib/apt/lists/*

USER jenkins
