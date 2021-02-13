#!/bin/bash
if [[ -e /etc/profile.d/CP.sh ]]; then source /etc/profile.d/CP.sh; fi
if [[ -e /etc/profile.d/vsenv.sh ]]; then source /etc/profile.d/vsenv.sh; fi
vsenv 2
dhclient -1 eth1
dhclient eth1
vsenv 1
dhclient -1 eth2
dhclient eth2
