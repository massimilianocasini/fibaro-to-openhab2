#!/bin/bash
#stop openhab instance (here: systemd service)
echo "+-+-+-+-+-+-+ Stopping service...+-+-+-+-+-+-+-+";

sudo systemctl stop openhab2.service

# backup current installation with settings
echo "+-+-+-+-+-+-+ timestamp and folder setup +-+-+-+-+-+-+-+-+";

TIMESTAMP="`date +%Y%m%d_%H%M%S`";
sudo mkdir  "/media/usb1/openhab2-backup-$TIMESTAMP";
sudo mkdir  "/media/usb1/openhab2-backup-$TIMESTAMP/influxdb";
sudo mkdir  "/media/usb1/openhab2-backup-$TIMESTAMP/grafana";
#bakdir="$HOME/openhab2-backup/$TIMESTAMP";
#mkdir -p "${bakdir}"

echo "+-+-+-+-+-+-+ OH backup +-+-+-+-+-+-+-+-+-+-+";

#cp -arv /etc/openhab2 "${bakdir}/conf"
#cp -arv /var/lib/openhab2 "${bakdir}/userdata"
#find /var/lib/openhab2 \( -path /var/lib/openhab2/tmp -prune -o -path /var/lib/openhab2/cache -prune \) -o -name '*' -exec cp -arv {} "${bakdir}/userdata"  \;
sudo cp -arv "/etc/openhab2" "/media/usb1/openhab2-backup-$TIMESTAMP/conf";
sudo cp -arv "/var/lib/openhab2" "/media/usb1/openhab2-backup-$TIMESTAMP/userdata";

echo "+-+-+-+-+-+-+ Grafana backup +-+-+-+-+-+-+-+-+";
sudo systemctl stop grafana-server
sudo cp -arv "/etc/grafana/grafana.ini" "/media/usb1/openhab2-backup-$TIMESTAMP/grafana/grafana.ini";
sudo cp -arv "/var/lib/grafana/grafana.db" "/media/usb1/openhab2-backup-$TIMESTAMP/grafana/grafana.db";

echo "+-+-+-+-+-+-+ Influxdb backup +-+-+-+-+-+-+-+";
sudo cp -arv "/etc/influxdb/influxdb.conf" "/media/usb1/openhab2-backup-$TIMESTAMP/influxdb/influxdb.conf"
sudo influxd backup "/media/usb1/openhab2-backup-$TIMESTAMP/influxdb/metastore/"
sudo influxd backup -database openhab_db "/media/usb1/openhab2-backup-$TIMESTAMP/influxdb/db/"

# restart openhab instance
echo "+-+-+-+-+-+-+ Starting service...+-+-+-+-+-+-+-+-+";
sudo systemctl start openhab2.service
sudo systemctl start grafana-server

echo "+-+-+-+-+-+-+ Clear cache and tmp folder +-+-+-+-+-+-+-+-+";
sudo rm -rf "/media/usb1/openhab2-backup-$TIMESTAMP/userdata/cache"
sudo rm -rf "/media/usb1/openhab2-backup-$TIMESTAMP/userdata/tmp"

# Packen
echo "+-+-+-+-+-+-+ Pack Backup Folder into tar.gz +-+-+-+-+-+-+-+-+";
tar cfvz /media/usb1/openhab2-backup-$TIMESTAMP.tar.gz /media/usb1/openhab2-backup-$TIMESTAMP

# Entpacken-> tar xfvz archiv.tar.gz

# Folder size
# sudo ls -1d */ | sudo xargs -I{} du {} -sh && sudo du -sh
sudo df -h /media/usb1/; sudo du -sh -- /media/usb1/*

