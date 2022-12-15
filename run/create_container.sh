#!/usr/bin/env bash
REPO=toddwint
APPNAME=rpc
SCRIPTDIR="$(dirname "$(realpath "$0")")"
source "$SCRIPTDIR"/config.txt

# Set the IP on the interface
IPASSIGNED=$(ip addr show $INTERFACE | grep $IPADDR)
if [ -z "$IPASSIGNED" ]; then
   SETIP="$IPADDR/$(echo $SUBNET | awk -F/ '{print $2}')" 
   sudo ip addr add $SETIP dev $INTERFACE
else
    echo 'IP is already assigned to the interface'
fi

# Add remote network routes
IFS=',' # Internal Field Separator
for ROUTE in $ROUTES; do sudo ip route add "$ROUTE" via "$GATEWAY"; done

# Create the docker container
docker run -dit \
    --name "$HOSTNAME" \
    -h "$HOSTNAME" \
    -p "$IPADDR":111:111/tcp \
    -p "$IPADDR":111:111/udp \
    -e TZ="$TZ" \
    -e HOSTNAME="$HOSTNAME" \
    -e APPNAME="$APPNAME" \
    ${REPO}/${APPNAME}
