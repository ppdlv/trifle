#!/bin/bash
Version=v4.38-9760-rtm-2021.08.17
URL1=http://www.softether-download.com/files/softether/$Version-tree/Linux/SoftEther_VPN_Server/64bit_-_Intel_x64_or_AMD64/softether-vpnserver-$Version-linux-x64-64bit.tar.gz
URL2=https://raw.githubusercontent.com/pxdlima/trifle/master/files/vpn_server.config
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

function Install () {
    echo "Initiating Setup..."
apt update
apt install build-essential wget curl -y
apt upgrade -y
sysctl -w net.ipv4.ip_forward=1
wget $URL1
tar xvzf softether-vpnserver* && rm -rf softether-vpnserver*
cd vpnserver; make; rm *.txt; curl -Os $URL2
mv ../vpnserver/ /usr/local; chmod 700 /usr/local/vpnserver/vpncmd; chmod 700 /usr/local/vpnserver/vpnserver
echo '#!/bin/sh
# description: SoftEther VPN Server
### BEGIN INIT INFO
# Provides:          vpnserver
# Required-Start:    $local_fs $network
# Required-Stop:     $local_fs
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: softether vpnserver
# Description:       softether vpnserver daemon
### END INIT INFO
DAEMON=/usr/local/vpnserver/vpnserver
LOCK=/var/lock/subsys/vpnserver

test -x $DAEMON || exit 0
case "$1" in
start)
$DAEMON start
touch $LOCK
;;
stop)
$DAEMON stop
rm $LOCK
;;
restart)
$DAEMON stop
sleep 3
$DAEMON start
;;
*)
echo "Usage: $0 {start|stop|restart}"
exit 1
esac
exit 0' > /etc/init.d/vpnserver
ln -fs /etc/init.d/vpnserver /usr/bin/se
chmod 755 /etc/init.d/vpnserver && /etc/init.d/vpnserver start > /dev/null
sleep 1
echo "Enter Password to CREATE Zip File:"
/usr/local/vpnserver/vpncmd localhost /SERVER /CMD OpenVpnMakeConfig ovpn > /dev/null
echo "SoftetherVPN Server is now READY!"
}
clear
if [[ -d /usr/local/vpnserver ]]; then
	echo "SoftEtherVPN detected.."
    until [[ $CONTINUE =~ (y|n) ]]; do
        read -rp "Continue and Reinstall? [y/n]: " -e CONTINUE
	done
    if [[ "$CONTINUE" = "n" ]]; then
        echo "Exit Installation..   "
    else
    pkill vpnserver; rm -rf /usr/local/vpnserver
    Install
    fi
    else
    Install
fi
