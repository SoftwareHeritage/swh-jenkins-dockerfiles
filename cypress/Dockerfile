FROM cypress/base:latest

RUN apt update && apt install -y \
    python3-pip \
    python3-venv \
    libpq-dev \
    libmagic-dev \
    wait-for-it \
    pkg-config \
    libsystemd-dev \
    libleveldb-dev

ARG user=jenkins
ARG group=jenkins
ARG uid=115
ARG gid=120

RUN groupadd -g ${gid} ${group}
RUN useradd -c "Jenkins user" -d /home/${user} -u ${uid} -g ${gid} -m ${user}

USER ${user}
