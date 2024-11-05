#!/usr/bin/bash

set -ouex pipefail

systemctl enable tailscaled.service
systemctl enable brew-setup.service
systemctl enable brew-upgrade.timer
systemctl enable brew-update.timer