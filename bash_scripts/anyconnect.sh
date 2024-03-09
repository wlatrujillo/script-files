#!/bin/bash

# Easily connect to Cisco AnyConnect VPN

# Get first parameter
COMMAND="$1"

case $COMMAND in
    connect | CONNECT | c | C)
        printf "2\n${username}\n$(pass show my_password_entry)\n" | \
            /opt/cisco/anyconnect/bin/vpn -s connect remote_host_url
        ;;

    disconnect | DISCONNECT | d | D)
        /opt/cisco/anyconnect/bin/vpn disconnect
        ;;

    *)
        cat <<EOF
Usage: vpnctl COMMAND
       connect | CONNECT | c | C    Connect to the VPN
       disconnect | DISCONNECT | d | D    Disconnect from the VPN
EOF
        ;;
esac
