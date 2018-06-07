#!/bin/bash
now="$(date +'%Y%m%d%H%M%S')"
host=$(hostname)

/usr/sbin/amfetchdump -pa ohasis-bkp ohasis /dev/mmcblk0 > /media/usb/images/"$now"-"$host"-image.raw
find /media/usb/images/ -type f -mtime +2 -delete
