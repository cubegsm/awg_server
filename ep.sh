#!/bin/bash

set -e

# Bring up wg0
AWG0_DEV="awg0"
AWG0_CONF="/etc/amnezia/amneziawg/awg0.conf"
#mkdir /etc/amnezia
mkdir -p /etc/amnezia/amneziawg
cp awg0.conf "$AWG0_CONF"
ip li li dev "$AWG0_DEV" >&- 2>&- && awg-quick down "$AWG0_CONF"
awg-quick up "$AWG0_CONF"

# Routing
iptables -t nat -A POSTROUTING -s 192.168.196.0/24 -o eth0 -j MASQUERADE
iptables -A FORWARD -i awg0 -o eth0 -j ACCEPT
iptables -A FORWARD -i eth0 -o awg0 -m state --state ESTABLISHED,RELATED -j ACCEPT


# Start SSH daemon
## Terminate running sshd listener
while true; do
    i="$(lsof -t -iTCP:22 -sTCP:LISTEN)" || break
    kill "$i"
    sleep 0.1
done
## Start sshd
screen -dmS sshd /usr/sbin/sshd -D

# Sleep
exec /bin/sleep infinity
