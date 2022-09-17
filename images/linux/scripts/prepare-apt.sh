#!/bin/bash -e

LSB_DISTRIBID=$(lsb_release -is | tr '[:upper:]' '[:lower:]')
LSB_RELEASE=$(lsb_release -rs)

# sometimes actions are run right at startup
sleep 10

# stop and disable apt-daily upgrade services
systemctl stop apt-daily.timer
systemctl disable apt-daily.timer
systemctl disable apt-daily.service
systemctl stop apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.timer
systemctl disable apt-daily-upgrade.service

echo "APT::Acquire::Retries \"10\";" > /etc/apt/apt.conf.d/80-retries
echo "APT::Get::Assume-Yes \"true\";" > /etc/apt/apt.conf.d/90assumeyes

# fix bad proxy and http headers settings
cat <<EOF >> /etc/apt/apt.conf.d/99bad_proxy
Acquire::http::Pipeline-Depth 0;
Acquire::http::No-Cache true;
Acquire::BrokenProxy    true;
EOF

apt-get purge unattended-upgrades

# ---

# update
apt-get install apt-transport-https ca-certificates curl software-properties-common gnupg
apt-get update
apt-get dist-upgrade

# microsoft repository
wget https://packages.microsoft.com/config/$LSB_DISTRIBID/$LSB_RELEASE/packages-microsoft-prod.deb
dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

apt-get update

# apt-fast install
bash -c "$(curl -sL https://raw.githubusercontent.com/ilikenwf/apt-fast/master/quick-install.sh)"
