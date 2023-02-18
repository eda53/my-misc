#! /bin/bash
#
# kernel_modules.sh
# Copyright (C) 2022 eda <eda@evertz.com>
#
# Distributed under terms of the Evertz Proprietary license.
#


[ -n "$linux_xlnx" ] || linux_xlnx='.'
[ ! -d "$linux_xlnx/drivers/" -o ! -d "$linux_xlnx/include/linux/" ] && \
	{ echo "wrong linux_xlnx{$linux_xlnx} directory!"; exit 1; }

[ -f "$1" ] && config="$1" || \
	config="$linux_xlnx/.config"

config_m='./config_m'
all_config='./all_config'

if [ ! -f $all_config ]; then
	echo -n "collecting Kconfig..."
	rm -rf $all_config
	for kcfg in $(find $linux_xlnx -type f -name Kconfig); do
	echo "processing $kcfg..."
	CONFIG=''
	while IFS='' read -r line; do
		#echo "$line"
		if [ -z "$CONFIG" ]; then
			if echo "$line" | grep -q '^config .\+$'; then
				CONFIG="$(echo $line |  sed 's/^config //')"
				[ -n "$CONFIG" ] && CONFIG="CONFIG_$CONFIG"
			fi
		else
			if echo "$line" | grep -q 'tristate'; then
				echo "$CONFIG=tristate          # $kcfg" >>$all_config
			elif echo "$line" | grep -q 'bool'; then
				echo "$CONFIG=bool              # $kcfg" >>$all_config
			else
				echo "$CONFIG=$(echo $line | awk '{print $1;}')             # $kcfg" >>$all_config
			fi
			CONFIG=''
		fi
	done <$kcfg
	done
	echo "done!!"
fi
. $all_config

rm -rf $config_m
while IFS='' read -r line; do
	#echo "$line"
	if echo "$line" | grep -q '=y'; then
		CONFIG="$(echo $line | sed 's/CONFIG_\(\S\+\)=y/CONFIG_\1/')"
		[ 'tristate' = "$(eval echo \${$CONFIG})" ] && \
			echo "$line" | sed 's/=y/=m/' >>$config_m ||\
			echo "$line" >>$config_m
	else
		echo "$line" >>$config_m
	fi
done <$config
