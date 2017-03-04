#!/bin/bash

if [ -z "$1" ];then
	echo "1 script filename is needed as parameter!"
	exit 1;
fi

#default SAMPLE number

SAMPLE=100

# each script might have it owns SAMPLE number.
. $1

# each run has its SAMPLE number
if [ -n "$2" ];then SAMPLE=$2;fi

# log
OUT=$PWD/`date +%Y-%m-%d-%H-%M-%S-%N`.log
w() {
	echo "$1">>${OUT}
}

w "Profile script{$1} sample[$SAMPLE]!"
w "Commands to be profiled:"
for ((j=0;j<${#s_cmds[@]};j++))
do
	w "$j: ${s_cmds[$j]}"
done
w ""

TIMEFORMAT="%3R"
CMD_NUM=${#s_cmds[@]}
for ((i=0;i<$SAMPLE;i++))
do
	s_init;
	tmp_str=""
	for ((j=0;j<${CMD_NUM};j++))
	do
		t0=$SECONDS
		eval ${s_cmds[$j]}
		((s_ret[$i*$SAMPLE+$j]=$SECONDS-$t0))
		tmp_str="$tmp_str  ${s_ret[$i*$SAMPLE+$j]}"
	done
	w "$i: $tmp_str"
done

tmp_str=""
tmp2_str=""
for ((j=0;j<${CMD_NUM};j++))
do
	for ((i=0;i<$SAMPLE;i++))
	do
		((s_sum[$j]=s_sum[$j] + ${s_ret[$i*$SAMPLE + $j]}))
	done
	((s_avg[$j]=${s_sum[$j]}/$SAMPLE))
	tmp_str+="${s_sum[$j]}  "
	tmp2_str+="${s_avg[$j]}  "
done
w "sum: $tmp_str"
w "avg: $tmp2_str"
