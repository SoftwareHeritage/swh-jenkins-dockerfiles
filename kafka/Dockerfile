ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox as kafka_fetcher

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y --no-install-recommends \
    default-jdk && \
    rm -rf /var/lib/apt/lists/*

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
ARG SCALA_VERSION=2.12
ARG KAFKA_VERSION=2.4.0
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=53b52f86ea56c9fac62046524f03f75665a089ea2dae554aefe3a3d2694f2da88b5ba8725d8be55f198ba80695443559ed9de7c0b2a2817f7a6141008ff79f49
ARG CHECKSUMS=${TARBALL}.sha512

RUN curl -fsSLo ${TARBALL} http://apache.mirrors.ovh.net/ftp.apache.org/dist/kafka/${KAFKA_VERSION}/${TARBALL} && \
    ( echo "${KAFKA_SHA512SUM}  ${TARBALL}" > ${CHECKSUMS} ) && \
    sha512sum -c ${CHECKSUMS} && \
    tar xf ${TARBALL} -C /opt && \
    ln -s /opt/${KAFKA_APP} /opt/kafka

FROM $REGISTRY/tox
USER root
WORKDIR /opt
COPY --from=kafka_fetcher /opt/ .
RUN chown -R jenkins: /opt/
USER jenkins
ENV SWH_KAFKA_ROOT=/opt/kafka
