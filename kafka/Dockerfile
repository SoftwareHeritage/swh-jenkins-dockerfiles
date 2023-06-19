ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox as kafka_fetcher

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
ARG SCALA_VERSION=2.13
ARG KAFKA_VERSION=3.5.0
ARG KAFKA_APP=kafka_${SCALA_VERSION}-${KAFKA_VERSION}
ARG TARBALL=${KAFKA_APP}.tgz
ARG KAFKA_SHA512SUM=7b79bd0844db683c06c3491955bb183d48a47fa4639d2e241b9f4ff4060c4b70814dac7d96bea87dffca0c8ae038278c4fabf68d4ea1194228d67d9c3b1d247c
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
