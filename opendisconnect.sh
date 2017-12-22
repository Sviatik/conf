#!/bin/bash

echo "Disconnecting..."
sudo pkill -SIGINT openconnect

# Remove default gateway route rule when there is already a PPTP connection
# Uncomment line below if your computer is connected to internet through a PPTP connection
#ip r | grep ppp0 && ip r | grep default | head -n1 | xargs sudo ip r del