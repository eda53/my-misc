#! /bin/sh
#
# clear_journal.sh
# Copyright (C) 2022 leo <leo@minipc>
#
# Distributed under terms of the MIT license.
#


journalctl --rotate
journalctl --vacuum-time=1s
