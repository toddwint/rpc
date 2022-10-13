#!/usr/bin/env bash

## Run the commands to make it all work
ln -fs /usr/share/zoneinfo/$TZ /etc/localtime
dpkg-reconfigure --frontend noninteractive tzdata

echo $HOSTNAME > /etc/hostname

# Unzip frontail and tailon
gunzip /usr/local/bin/frontail.gz
gunzip /usr/local/bin/tailon.gz

# Configure rpc and start rpcbind
sed -i '$c rpcbind: all' /etc/hosts.allow
rpcbind -w

# Create logs folder and init files
mkdir -p /opt/"$APPNAME"/logs
touch /opt/"$APPNAME"/logs/"$APPNAME".log
truncate -s 0 /opt/"$APPNAME"/logs/"$APPNAME".log
echo "$(date -Is) [Start of $APPNAME log file]" >> /opt/"$APPNAME"/logs/"$APPNAME".log

# Start web interface
cp /opt/"$APPNAME"/scripts/tmux.conf /root/.tmux.conf
# ttyd with color
nohup ttyd -p "$HTTPPORT1" -t titleFixed="$HOSTNAME"'|'"$APPNAME"'.log' -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tmux-session.sh >> /opt/"$APPNAME"/logs/ttyd.nohup 2>&1 &
# ttyd without color
#nohup ttyd -p "$HTTPPORT1" -t titleFixed="$HOSTNAME"'|'"$APPNAME"'.log' -T xterm-mono -t fontSize=18 -t 'theme={"foreground":"black","background":"white", "selection":"red"}' /opt/"$APPNAME"/scripts/tmux-session.sh >> /opt/"$APPNAME"/logs/ttyd.nohup 2>&1 &
frontail -d -p "$HTTPPORT2" /opt/"$APPNAME"/logs/"$APPNAME".log
nohup tailon -b 0.0.0.0:"$HTTPPORT3" /opt/"$APPNAME"/logs/"$APPNAME".log /opt/"$APPNAME"/logs/ttyd.nohup /opt/"$APPNAME"/logs/tailon.nohup >> /opt/"$APPNAME"/logs/tailon.nohup 2>&1 &

# Keep docker running
bash
