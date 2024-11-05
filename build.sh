#!/usr/bin/bash

set -eoux pipefail

# Make Alternatives Directory
mkdir -p /var/lib/alternatives
cp /ctx/packages.json /tmp/packages.json

rsync -rvK /ctx/system_files/ /

/ctx/workaround.sh
/ctx/build_fix.sh
/ctx/packages.sh
/ctx/brew.sh
/ctx/systemd.sh
/ctx/cleanup.sh