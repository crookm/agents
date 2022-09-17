#!/bin/bash -e

# installation
git clone https://github.com/bats-core/bats-core.git
cd bats-core
./install.sh /usr/local

# cleanup
cd ..
rm -rf bats-core
