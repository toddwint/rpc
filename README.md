# toddwint/rpc

## Info

`rpc` docker image for simple lab testing applications.

Docker Hub: <https://hub.docker.com/r/toddwint/rpc>

GitHub: <https://github.com/toddwint/rpc>


## Overview

- Download the docker image and github files.
- Configure the settings in `run/config.txt`.
- Start a new container by running `run/create_container.sh`.
- Use this image to create other images.


## Features

- Ubuntu base image
- Plus:
  - rpcbind
  - libtirpc3
  - netbase
  - tmux
  - python3-minimal
  - iproute2
  - tzdata
  - [ttyd](https://github.com/tsl0922/ttyd)
    - View the terminal in your browser
  - [frontail](https://github.com/mthenw/frontail)
    - View logs in your browser
    - Mark/Highlight logs
    - Pause logs
    - Filter logs
  - [tailon](https://github.com/gvalkov/tailon)
    - View multiple logs and files in your browser
    - User selectable `tail`, `grep`, `sed`, and `awk` commands
    - Filter logs and files
    - Download logs to your computer


## Sample `config.txt` file

```
# To get a list of timezones view the files in `/usr/share/zoneinfo`
TZ=UTC

# The interface on which to set the IP. Run `ip -br a` to see a list
INTERFACE=eth0

# The IP address that will be set on the host and NAT'd to the container
IPADDR=192.168.10.1

# The IP subnet in the form subnet/cidr
SUBNET=192.168.10.0/24

# The IP of the gateway
GATEWAY=192.168.10.254

# Add any custom routes needed in the form NETWORK/PREFIX
# Separate multiple routes with a comma
# Example: 10.0.0.0/8,192.168.0.0/16
ROUTES=0.0.0.0/0

# The hostname of the instance of the docker container
HOSTNAME=rpc01
```


## Sample docker run script

```
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
```
