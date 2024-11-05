#!/usr/bin/bash

set -ouex pipefail

systemctl enable tailscaled.service
systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer
systemctl enable docker.socket
systemctl enable podman.socket
systemctl enable dx-group.service