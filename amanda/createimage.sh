#!/bin/bash
now="$(date +'%Y%m%d%H%M%S')"
host=$(hostname)
ver="$(dpkg -s openhab2|grep Version|cut -c10-16)"
find /media/usb/images/ -type f -mtime +1 -delete
/usr/sbin/amfetchdump -paC ohasis-bkp ohasis /dev/mmcblk0 > /media/usb/images/"$now"-"$host"-"$ver"-image.raw

