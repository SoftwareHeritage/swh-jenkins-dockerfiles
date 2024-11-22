ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox as kafka_fetcher

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
ARG SCALA_VERSION=2.13
ARG KAFKA_VERSION=3.7.1
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=78E985235D245BA9E2951A82E723A62B8ABA8B74A2C8376F7271906AF715A36DE9142C446096F13FD4BFF3A4C10F1D080EB924E91E2256EC2DB779906FD6737D
ARG CHECKSUMS=${TARBALL}.sha512
ARG APACHE_MIRROR_URL=https://dlcdn.apache.org

RUN mkdir /home/jenkins/opt
RUN curl -fsSLo ${TARBALL} ${APACHE_MIRROR_URL}/kafka/${KAFKA_VERSION}/${TARBALL} && \
    ( echo "${KAFKA_SHA512SUM}  ${TARBALL}" > ${CHECKSUMS} ) && \
    sha512sum -c ${CHECKSUMS} && \
    tar xf ${TARBALL} -C /home/jenkins/opt && \
    ln -s ${KAFKA_APP} /home/jenkins/opt/kafka

FROM $REGISTRY/tox
USER root
WORKDIR /opt
COPY --from=kafka_fetcher /home/jenkins/opt/ .
RUN chown -R jenkins: /opt/
USER jenkins
ENV SWH_KAFKA_ROOT=/opt/kafka
