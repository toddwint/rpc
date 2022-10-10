#!/usr/bin/env bash
source config.txt
cp template/webadmin.html.template webadmin.html
sed -i "s/IPADDR/$IPADDR:$HTTPPORT/g" webadmin.html
docker run -dit --rm \
    --name $HOSTNAME \
    -h $HOSTNAME \
    -p $IPADDR:$PORT:$PORT/$IPPROTO \
    -p $IPADDR:$HTTPPORT:$HTTPPORT \
    -v rpc:/var/log/syslog \
    -e TZ=$TZ \
    -e HTTPPORT=$HTTPPORT \
    -e HOSTNAME=$HOSTNAME \
    --cap-add=NET_ADMIN \
    toddwint/rpc
