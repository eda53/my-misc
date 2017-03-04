#!/bin/bash

fil='*.qsf'
if [ -n "$1" ]; then fil=$1; fi

WCD="$PWD"
pushd `dirname $(readlink -f $fil)`

# get all VHDL_FILE
sed -n /HDL_FILE/p $fil > $WCD/hdl.cs.0
# remove the comment
sed  s/^#.*// $WCD/hdl.cs.0 > $WCD/hdl.cs.1
# remove "... VHDL_FILE "
sed s/^.*HDL_FILE// $WCD/hdl.cs.1 > $WCD/hdl.cs.2
# remove "library ...$"
sed s/-library.*// $WCD/hdl.cs.2 > $WCD/hdl.cs.3
# remove "
sed 's/"//g' $WCD/hdl.cs.3 > $WCD/hdl.cs.5
# relative to abs path.
rm -f $WCD/hdl.cs.4
for f in `cat $WCD/hdl.cs.5`; do
	readlink -f $f >> $WCD/hdl.cs.4
	if [ -z "`readlink -f $f`" ]; then
		echo "[$f] missing..."
	fi
done

if [ -z "$2" ]; then
	mv $WCD/hdl.cs.4 $WCD/cscope.files
	unix2dos $WCD/cscope.files
	rm -f $WCD/hdl.cs.*
fi

popd
