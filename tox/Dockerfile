ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base
LABEL maintainer="SoftwareHeritage"
USER root

USER jenkins

RUN python3 -m pip install --user --upgrade \
  pip setuptools wheel twine tox detox
RUN python3 -m pip install --user --no-warn-script-location \
  Radon pylint coverage codespell pyarcanist
