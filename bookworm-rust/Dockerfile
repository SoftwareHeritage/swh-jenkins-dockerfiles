# syntax=docker/dockerfile:experimental
FROM rust:bookworm

USER root

RUN export DEBIAN_FRONTEND=noninteractive && \
  apt-get --allow-releaseinfo-change update && \
  apt-get -y dist-upgrade && \
  apt-get install -y \
    cmake
