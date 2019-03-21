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
ARG KAFKA_VERSION=2.1.1
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=a2e8168e8de6b45e8fca1f2883f0744d3c5a939b70d8a47a5428b72188501d4c2fc11bc35759f2392680d4e8ecf2fa9d0e518e77fd28393afba22194ad018b10
ARG CHECKSUMS=${TARBALL}.sha512

RUN wget -q http://apache.mirrors.ovh.net/ftp.apache.org/dist/kafka/${KAFKA_VERSION}/${TARBALL} && \
    ( echo "${KAFKA_SHA512SUM}  ${TARBALL}" > ${CHECKSUMS} ) && \
    sha512sum -c ${CHECKSUMS} && \
    tar xvf ${TARBALL} -C /opt && \
    ln -s /opt/${KAFKA_APP} /opt/kafka

FROM $REGISTRY/tox
USER root
WORKDIR /opt
COPY --from=kafka_fetcher /opt/ .
RUN chown -R jenkins: /opt/${KAFKA_APP} /opt/kafka
USER jenkins
ENV SWH_KAFKA_ROOT=/opt/${KAFKA_APP}
