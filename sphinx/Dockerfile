ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y --no-install-recommends \
    tox \
    graphviz \
    postgresql-autodoc \
    libffi-dev \
    inkscape \
    dia \
    plantuml \
    myrepos \
    make && \
  rm -rf /var/lib/apt/lists/*

USER jenkins
