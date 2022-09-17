#!/bin/bash -e

# installation
curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
rm get-docker.sh

# access for CI user
usermod -aG docker ci

