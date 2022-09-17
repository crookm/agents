#!/bin/bash -e

echo 'DefaultLimitNOFILE=65536' >> /etc/systemd/system.conf
echo 'DefaultLimitSTACK=16M:infinity' >> /etc/systemd/system.conf

# raise number of file descriptors
echo '* soft nofile 65536' >> /etc/security/limits.conf
echo '* hard nofile 65536' >> /etc/security/limits.conf

# double stack size from default 8192KB
echo '* soft stack 16384' >> /etc/security/limits.conf
echo '* hard stack 16384' >> /etc/security/limits.conf
