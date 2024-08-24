ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox as kafka_fetcher

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
ARG SCALA_VERSION=2.13
ARG KAFKA_VERSION=3.6.2
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=E5D5935DF6E687898E71E583E8EA376275C6FBAC2E7872E78F7C55AB2528485582362E3778678600C5368384437C1DA6B3D612A748917F4B294C06EA160173EE
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
