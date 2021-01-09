#!/bin/sh
. /pfrm2.0/etc/bashrc
# if no rows in DB => stop. Other wise, restart.
p=`sqlite3 /fwtmp/system.db 'select port from sshdPort'|head -1`
isBanner=`sqlite3 /fwtmp/system.db "SELECT enabled FROM loginMessages WHERE
type='MESSAGE_TYPE.SSHD_BANNER' LIMIT 1"`
BANNER_FILE=/opt/fw1/conf/sshd_banner.txt
BANNER=

if [[ "$isBanner" == "true" && -f $BANNER_FILE ]]; then
 BANNER="-b $BANNER_FILE"
fi

test -f /var/run/dropbear.pid && cpwd_admin stop -name DROPBEAR && sleep 1

test "$p" = "" && exit

if [ ! -f /pfrm2.0/etc/dropbear_rsa_host_key ]; then
 dropbearkey -t rsa -f /pfrm2.0/etc/dropbear_rsa_host_key
fi
chown root /
mkdir -p /.ssh
chmod 600 /storage/authorized_keys
ln -sf /storage/authorized_keys /.ssh/authorized_keys
start_cpwd.sh

cpwd_admin start -name DROPBEAR -path "/pfrm2.0/bin/dropbear" \
 -command "dropbear -F -j -k -p $p -r /pfrm2.0/etc/dropbear_rsa_host_key $BANNER"