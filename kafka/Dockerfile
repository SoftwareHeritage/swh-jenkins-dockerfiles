ARG REGISTRY=swh-jenkins
FROM $REGISTRY/tox

USER root
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
  apt-get install -y --no-install-recommends \
    default-jdk && \
    rm -rf /var/lib/apt/lists/*

# retrieve and uncompress kafka application, checking it's the
# expected archive we retrieve
RUN wget http://apache.mirrors.ovh.net/ftp.apache.org/dist/kafka/2.1.1/kafka_2.12-2.1.1.tgz && \
    ( echo "a2e8168e8de6b45e8fca1f2883f0744d3c5a939b70d8a47a5428b72188501d4c2fc11bc35759f2392680d4e8ecf2fa9d0e518e77fd28393afba22194ad018b10  kafka_2.12-2.1.1.tgz" > kafka_2.12-2.1.1.tgz.sha512 ) && \
    sha512sum -c kafka_2.12-2.1.1.tgz.sha512 && \
    tar xvf kafka_2.12-2.1.1.tgz -C /opt && \
    ln -s /opt/kafka_2.12-2.1.1 /opt/kafka && \
    chown -R jenkins: /opt/kafka && \
    rm kafka_2.12-2.1.1.tgz kafka_2.12-2.1.1.tgz.sha512

USER jenkins
