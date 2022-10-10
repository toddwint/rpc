FROM ubuntu:focal
COPY scripts /opt/rpc/scripts
EXPOSE 9001
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    HTTPPORT=9001 \
    HOSTNAME=rpcsrvr
RUN apt-get update \
    && \
    apt-get install -y \
    tzdata \
    iproute2 \
    wget \
    libtirpc-dev \
    rpcbind \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    wget -q https://github.com/mthenw/frontail/releases/download/v4.9.1/frontail-linux -O /usr/local/bin/frontail \
    && \
    chmod 755 /usr/local/bin/frontail \
    && \
    apt-get remove -y \
    wget \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/rpc/scripts
CMD ["/opt/rpc/scripts/startup.sh"]
