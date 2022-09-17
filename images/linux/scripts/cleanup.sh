#!/bin/bash -e

# free space before cleanup
before=$(df / -Pm | awk 'NR==2{print $4}')

apt-get autoremove
apt-get clean
rm -rf /tmp/*
rm -rf /root/.cache

if command -v journalctl; then
    journalctl --rotate
    journalctl --vacuum-time=1s
fi

# delete all .gz and rotated file
find /var/log -type f -regex ".*\.gz$" -delete
find /var/log -type f -regex ".*\.[0-9]$" -delete

# wipe log files
find /var/log/ -type f -exec cp /dev/null {} \;

# free space after cleanup
after=$(df / -Pm | awk 'NR==2{print $4}')

# display size
echo "before: $before MB"
echo "after : $after MB"
echo "delta : $(($after-$before)) MB"

