# syntax=docker/dockerfile:experimental
ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base-buster
LABEL maintainer="SoftwareHeritage"

USER jenkins

RUN mkdir -p /home/jenkins/.cache/pip

RUN --mount=type=cache,id=pip-cache,target=/home/jenkins/.cache/pip,uid=1000,gid=1000 \
  python3 -m pip install --user --upgrade \
  pip setuptools wheel twine tox detox
RUN --mount=type=cache,id=pip-cache,target=/home/jenkins/.cache/pip,uid=1000,gid=1000 \
  python3 -m pip install --user --upgrade --no-warn-script-location \
  Radon pylint coverage codespell pyarcanist
