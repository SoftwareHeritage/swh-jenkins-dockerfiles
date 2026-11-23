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

RUN uv pip install -p ${SWH_PYTHON_VERSION_FOR_GLOBAL_TOOLS} --upgrade \
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
  && uv run -p ${SWH_PYTHON_VERSION_FOR_GLOBAL_TOOLS} virtualenv --upgrade-embed-wheels
