# syntax=docker/dockerfile:experimental
ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base-buster
LABEL maintainer="SoftwareHeritage"

USER jenkins

RUN mkdir -p /home/jenkins/.cache/pip

RUN --mount=type=cache,id=pip-cache,target=/home/jenkins/.cache/pip,uid=115,gid=120 \
  python3 -m pip install --user --upgrade --no-warn-script-location \
  pip setuptools wheel \
    twine \
    tox \
    "urllib3<1.27,>=1.21.1" \
  Radon pylint coverage codespell pyarcanist pre-commit && \
  python3 -m virtualenv --upgrade-embed-wheels
