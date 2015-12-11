#!/usr/bin/env bash

DEPOT_USER=$(curl http://rancher-metadata/2015-07-25/self/host/labels/depot.user)
DEPOT_PASS=$(curl http://rancher-metadata/2015-07-25/self/host/labels/depot.password)

if [ ! -f "/usr/local/openvpn_as/etc/as.conf" ]; then
    ln -s /usr/local/openvpn_as /srv/openvpn/app
    mkdir -p /srv/openvpn/data/tmp
    mkdir -p /srv/openvpn/data/sock

    confd -onetime -backend rancher -prefix /2015-07-25
    chown -R $DEPOT_USER:$DEPOT_USER /srv/openvpn

	cd /usr/local/openvpn_as/scripts/
    ./confdba -mk "admin_ui.https.ip_address" -v "all"
    ./confdba -mk "admin_ui.https.port" -v "943"
    ./confdba -mk "cs.https.ip_address" -v "all"
    ./confdba -mk "cs.https.port" -v "943"
    ./confdba -mk "vpn.client.routing.inter_client" -v "false"
    ./confdba -mk "vpn.client.routing.reroute_dns" -v "false"
    ./confdba -mk "vpn.client.routing.reroute_gw" -v "false"
    ./confdba -mk "vpn.daemon.0.listen.ip_address" -v "all"
    ./confdba -mk "vpn.daemon.0.listen.port" -v "60000"
    ./confdba -mk "vpn.daemon.0.server.ip_address" -v "all"
    ./confdba -mk "vpn.server.daemon.tcp.port" -v "60000"
    ./confdba -mk "vpn.server.daemon.udp.port" -v "60001"

    ./confdba -s

    echo "$DEPOT_USER:$DEPOT_PASS" | chpasswd
fi

rm -rf /usr/local/openvpn_as/tmp/* /usr/local/openvpn_as/etc/tmp/* /usr/local/openvpn_as/etc/sock/*


#su -c "/usr/local/openvpn_as/scripts/openvpnas" depot
/usr/local/openvpn_as/scripts/openvpnas --nodaemon --umask=0077 --pidfile=/srv/openvpn/data/openvpn.pid --logfile=/srv/openvpn/data/openvpn.log
