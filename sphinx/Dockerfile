ARG REGISTRY=swh-jenkins
FROM $REGISTRY/base

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y --no-install-recommends \
    python3-sphinx \
    sphinx-rtd-theme-common \
    graphviz \
    postgresql-autodoc \
    python3-sphinxcontrib.httpdomain \
    python3-recommonmark \
    libffi-dev \
    inkscape \
    dia \
    myrepos \
    make && \
  rm -rf /var/lib/apt/lists/*

USER jenkins
