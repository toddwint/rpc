FROM toddwint/mybaseimage
COPY scripts /opt/rpc/scripts
EXPOSE 8080 8081 8082 111/tcp 111/udp
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
    HTTPPORT1=8080 \
    HTTPPORT2=8081 \
    HTTPPORT3=8082 \
    HOSTNAME=rpcsrvr \
    APPNAME=rpc
RUN apt-get update \
    && \
    apt-get install -y \
    libtirpc3 \
    netbase \
    rpcbind \
    && \
    echo $HOSTNAME > /etc/hostname \
    && \
    cd /opt \
    && \
    rm -rf /opt/mybaseimage \
    && \
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/rpc/scripts
CMD ["/opt/rpc/scripts/startup.sh"]
