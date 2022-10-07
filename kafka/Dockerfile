ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox as kafka_fetcher

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
ARG SCALA_VERSION=2.13
ARG KAFKA_VERSION=2.6.0
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=D884E4DF7D85B4FFF54CA9CD987811C58506AD7871B9ED7114BBAFA6FEE2E79F43D04C550EEA471F508B08EA34B4316EA1E529996066FD9B93FCF912F41F6165
ARG CHECKSUMS=${TARBALL}.sha512
# Dirty hack
ARG APACHE_MIRROR_URL=https://web.archive.org/web/20210422181345if_/https://archive.apache.org/

RUN mkdir /home/jenkins/opt
RUN curl -fsSLo ${TARBALL} ${APACHE_MIRROR_URL}/dist/kafka/${KAFKA_VERSION}/${TARBALL} && \
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
