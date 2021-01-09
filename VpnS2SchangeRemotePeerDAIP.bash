#!/bin/bash
#Autor: Pawel Topczewski ptopczewski@checkpoint.com; pawel.topczewski@gmail.com
#Usage: In case S2S VPN does not work to Pubpic DAIP using dyndns hostname
#This script placed under /storage and issued unter cron (#crntab -u admin -e), can help remote site to update automatically ip address of remote peer

ChangeIP ()
{
echo "Checking IP address of paweldom.myddns.me" >> /var/log/changeip.log
IP1=$(clish -c "show vpn site VPN_bronczany" | grep remote-site-ip-address | awk '{print $2}')
echo "Configured IP od paweldom.myddns.me: " $IP1 >> /var/log/changeip.log
IP2=$(nslookup paweldom.myddns.me | grep Name -A1 | grep Address | cut -d' ' -f3)

if [ "$IP1" = "$IP2" ]; then

echo "Zmiana nie jest potrzebna" >> /var/log/changeip.log

else

echo "New IP of paweldom.myddns.me: " $IP2 >> /var/log/changeip.log
echo "Zmiana IP peera na " $IP2 >> /var/log/changeip.log
clish -v -A -c "set vpn site VPN_bronczany remote-site-ip-address $IP2" >> /var/log/changeip.log
echo "Zmiana zakonczona" >> /var/log/changeip.log

fi
}
ChangeIP