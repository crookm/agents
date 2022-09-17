#!/bin/bash -e

# disable annoying stuff during install
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1

# prevent conflicts with distributed repo
cat << EOF > /etc/apt/preferences.d/dotnet
Package: *net*
Pin: origin packages.microsoft.com
Pin-Priority: 1001
EOF

apt-get update

# install actual
# ---

apt-get install dotnet-sdk-6.0

# tools

dotnet tool install --tool-path /opt/dotnet/tools dotnet-ef
dotnet tool install --tool-path /opt/dotnet/tools JetBrains.dotCover.GlobalTool

# ---

rm /etc/apt/preferences.d/dotnet

# environmental setup
cat <<EOF >> /etc/environment
DOTNET_CLI_TELEMETRY_OPTOUT=1
DOTNET_SKIP_FIRST_TIME_EXPERIENCE=1
DOTNET_NOLOGO=1
DOTNET_MULTILEVEL_LOOKUP=0
PATH="$PATH:/opt/dotnet/tools"
EOF

