# syntax=docker/dockerfile:experimental
ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base-buster

ARG PLANTUML_VERSION=1.2021.12

USER root

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt --mount=type=cache,id=apt-lists,target=/var/lib/apt \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    crudini \
    dia \
    graphviz \
    imagemagick \
    inkscape \
    libffi-dev \
    maven \
    make \
    myrepos \
    plantuml \
    postgresql-autodoc \
    rsync \
    wget && \
  mkdir -p /home/jenkins/.cache/pip && \
  chown -R jenkins:jenkins /home/jenkins/.cache && \
  wget -O /usr/share/plantuml/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar

USER jenkins

RUN --mount=type=cache,id=pip-cache,target=/home/jenkins/.cache/pip,uid=115,gid=120 \
  python3 -m pip install --user --upgrade \
    pre-commit pyarcanist tox
