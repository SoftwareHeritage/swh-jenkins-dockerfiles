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
    Radon \
    build \
    cibuildwheel \
    codespell \
    coverage \
    pip \
    pre-commit \
    pylint \
    setuptools \
    tox \
    tox-uv \
    twine \
    wheel \
  && ${SWH_PYTHON_FOR_GLOBAL_TOOLS} -m virtualenv --upgrade-embed-wheels
