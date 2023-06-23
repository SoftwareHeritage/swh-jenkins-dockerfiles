# syntax=docker/dockerfile:experimental
ARG REGISTRY=swh-jenkins
FROM $REGISTRY/bookworm-multipython
LABEL maintainer="SoftwareHeritage"

ARG user=jenkins
ARG group=jenkins
ARG uid=115
ARG gid=120
ARG docker_gid=999

USER jenkins

RUN mkdir -p /home/jenkins/.cache/pip

RUN ${SWH_PYTHON_FOR_GLOBAL_TOOLS} -m pip install --user --upgrade \
    pip \
    setuptools \
    wheel \
    build \
    twine \
    tox \
    Radon \
    pylint \
    coverage \
    codespell \
    pre-commit && \
  ${SWH_PYTHON_FOR_GLOBAL_TOOLS} -m virtualenv --upgrade-embed-wheels
