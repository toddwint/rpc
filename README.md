# toddwint/rpc

## Info

<https://hub.docker.com/r/toddwint/rpc>

<https://github.com/toddwint/rpc>

RPC docker image for simple lab network testing.

This image was created for lab setups where there is a need to verify network RPC traffic.

## Features

- Receive and transmit packets over the network.
- View network packets in a web browser ([frontail](https://github.com/mthenw/frontail))
    - tail the file
    - pause the flow
    - search through the flow
    - highlight multiple rows
- Network packets are persistent if you map the directory `/var/log/tcpdump`

## Sample `config.txt` file

```
TZ=UTC
IPADDR=127.0.0.1
HTTPPORT=9001
HOSTNAME=rpcsrvr
```

## Sample docker run command

```
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
```

## Sample webadmin.html.template file

See my github page (referenced above).


## Login page

Open the `webadmin.html` file.

Or just type in your browser `http://<ip_address>:<port>`


## Issues?

Make sure if you set an IP that machine has the same IP configured on an interface.

