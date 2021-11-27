#!/bin/bash

# START-VARIABLER
NETWORK_SSID=$(sudo iwconfig wlp1s0 | grep 'Gossamer' $iwconfig)
VPN_STATUS_PRE=$(nordvpn status | grep 'Status: Connected' $nordvpn)
LOGIN_STATUS=$(nordvpn login | grep 'You are already logged in.' $nordvpn)

if [ -z "$LOGIN_STATUS" ]
	then
		nordvpn login -u $NORDVPN_USER -p $NORDVPN_PW
fi

if [ -z "$NETWORK_SSID" ] && [ -z "$VPN_STATUS_PRE" ]
	then
	echo "Connecting to VPN..."
	nordvpn c
	VPN_STATUS_POST=$(nordvpn status | grep 'Status: Connected' $nordvpn)
	if [ -n "$VPN_STATUS_POST" ]
		then
		echo "...success !"
		exit 0
	else
		echo "...failed !"
		exit 1
	fi
elif [ -n "$NETWORK_SSID" ] && [ -n "$VPN_STATUS_PRE" ]
	then
	echo "Disconnecting from VPN..."
	nordvpn d
	VPN_STATUS_POST=$(nordvpn status | grep 'Status: Connected' $nordvpn)
	if [ -z "$VPN_STATUS_POST" ]
		then
		echo "...success !"
		exit 0
	else
		echo "...failed !"
		exit 1
	fi
else
	echo "Leaving VPN as-is !"
	exit 1
fi
