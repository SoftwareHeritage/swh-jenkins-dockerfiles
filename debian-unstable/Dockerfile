# syntax=docker/dockerfile:experimental
FROM debian:unstable

LABEL maintainer="SoftwareHeritage"

USER root

ARG docker_gid=999
RUN groupadd -g ${docker_gid} docker

RUN rm -f /etc/apt/apt.conf.d/docker-clean; echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache

RUN --mount=type=cache,id=apt-cache,target=/var/cache/apt --mount=type=cache,id=apt-lists,target=/var/lib/apt \
  export DEBIAN_FRONTEND=noninteractive && \
  apt-get --allow-releaseinfo-change update && \
  apt-get -y dist-upgrade && \
  apt-get install -y apt-transport-https curl ca-certificates gpg apt dpkg && \
  apt-get install -y \
    default-jre \
    devscripts \
    dh-python \
    dpkg-dev \
    git \
    git-buildpackage \
    moreutils \
    procps \
    python3-dev \
    tini

RUN git clone --depth 1 https://forge.softwareheritage.org/source/swh-environment.git /tmp/swh-environment && \
    cp /tmp/swh-environment/bin/debpkg-* /usr/local/bin && \
    rm -rf /tmp/swh-environment


## vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv ##
# inlined from https://raw.githubusercontent.com/jenkinsci/docker-agent/4.13.3-2/11/bullseye/Dockerfile
#
# The MIT License
#
#  Copyright (c) 2015-2020, CloudBees, Inc. and other Jenkins contributors
#
#  Permission is hereby granted, free of charge, to any person obtaining a copy
#  of this software and associated documentation files (the "Software"), to deal
#  in the Software without restriction, including without limitation the rights
#  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
#  copies of the Software, and to permit persons to whom the Software is
#  furnished to do so, subject to the following conditions:
#
#  The above copyright notice and this permission notice shall be included in
#  all copies or substantial portions of the Software.
#
#  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
#  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
#  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
#  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
#  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
#  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
#  THE SOFTWARE.

ARG VERSION=4.13
ARG user=jenkins
ARG group=jenkins
ARG uid=115
ARG gid=120
ARG docker_gid=999

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}
RUN gpasswd -a jenkins docker

ARG AGENT_WORKDIR=/home/${user}/agent

RUN curl --create-dirs -fsSLo /usr/share/jenkins/agent.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/agent.jar \
  && ln -sf /usr/share/jenkins/agent.jar /usr/share/jenkins/slave.jar

ENV LANG C.UTF-8

ENV PATH "${PATH}:/home/${user}/.local/bin"

USER ${user}
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/${user}/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/${user}/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/${user}
