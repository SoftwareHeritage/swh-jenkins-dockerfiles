# syntax=docker/dockerfile:experimental
ARG REGISTRY=swh-jenkins
FROM $REGISTRY/bookworm-multipython

ARG PLANTUML_VERSION=1.2021.12

USER root

RUN \
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
    scour \
    wget && \
  mkdir -p /home/jenkins/.cache/pip && \
  chown -R jenkins:jenkins /home/jenkins/.cache && \
  wget -O /usr/share/plantuml/plantuml.jar https://github.com/plantuml/plantuml/releases/download/v${PLANTUML_VERSION}/plantuml-${PLANTUML_VERSION}.jar

USER jenkins

RUN ${SWH_PYTHON_FOR_GLOBAL_TOOLS} -m pip install --user --upgrade \
    pre-commit tox tox-uv
