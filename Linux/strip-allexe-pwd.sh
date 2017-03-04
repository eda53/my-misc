find . -type f -exec sh -c "file {} | grep -q 'ELF.*executable'" \; -exec arm-xilinx-linux-gnueabi-strip {} \;
find . -type f -exec sh -c "file {} | grep 'ELF.*executable'" \;
