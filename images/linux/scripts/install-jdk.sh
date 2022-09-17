#!/bin/bash -e

apt-get install openjdk-11-jdk-headless

# environmental setup
cat <<EOF >> /etc/environment
JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
EOF

