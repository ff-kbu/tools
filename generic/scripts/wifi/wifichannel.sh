#!/bin/bash
# wifi channel script - by Julian Zielke <freifunk@databunker.eu>
#
# code snipped to switch wifi channels on nodes to split-up large mesh networks
# CAUTION: Adjacent cable-bound node must be in range - otherwise the other nodes will loose connection permanently!

# desired channels
2_4GHZCHANNEL=1 # recommended: 1,6 or 11
5GHZCHANNEL=44  # recommended: 36,40,44 or 48

# DO NOT EDIT BELOW THIS LINE UNLESS YOU KNOW WHAT YOU ARE DOING!
INTERFACE=$(uci show wireless | grep \'VHT20\' | grep -o "radio.")
uci set wireless.$INTERFACE.channel='$5GHZCHANNEL'

INTERFACE=$(uci show wireless | grep \'HT20\' | grep -o "radio.")
uci set wireless.$INTERFACE.channel='$2_4GHZCHANNEL'

uci commit wireless
wifi