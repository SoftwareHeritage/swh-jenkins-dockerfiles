ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox as kafka_fetcher

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
ARG SCALA_VERSION=2.13
ARG KAFKA_VERSION=3.3.1
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=d14d9cc97d1702649b33378f38060c4a6220850a3d7182d1af20e905cb98728e51f2aeec63121f5773a389d6b66891b7508e5d23584dd1a4e424825e3d54e3e0
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
