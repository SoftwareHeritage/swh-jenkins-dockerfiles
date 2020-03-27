# syntax=docker/dockerfile:experimental
ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base-buster

USER root

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt --mount=type=cache,id=apt-lists,target=/var/lib/apt \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    crudini \
    dia \
    graphviz \
    inkscape \
    libffi-dev \
    maven \
    make \
    myrepos \
    plantuml \
    postgresql-autodoc \
    rsync \
    tox

USER jenkins

RUN --mount=type=cache,id=pip-cache,target=/home/jenkins/.cache/pip,uid=1000,gid=1000 \
  python3 -m pip install --user --upgrade \
    pre-commit
