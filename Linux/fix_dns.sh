#! /bin/sh
#
# fix_dns.sh
# Copyright (C) 2023 leo <leo@minipc>
#
# Distributed under terms of the MIT license.
#


sudo systemctl restart systemd-resolved.service
sudo systemctl status  systemd-resolved.service
