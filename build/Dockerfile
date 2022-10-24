FROM toddwint/mybaseimage
ENV DEBIAN_FRONTEND=noninteractive \
    TZ=UTC \
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
    apt-get autoremove -y \
    && \
    rm -rf /var/lib/apt/lists/*
WORKDIR /opt/
CMD ["bash"]
