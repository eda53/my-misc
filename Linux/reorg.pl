#!/usr/bin/perl

$fn = $ARGV[0];
while(<>) {

#	printf "ro:$is_ro, rw:$is_rw, ml=$ml, para=$paraName, $_";
	if (1 == $is_ro && /(ATTR_\S+)/) {
		if (substr($1, 0, 8) eq 'ATTR_PST') {
			print "file:[$fn], line:[$ml], param:[$p2] has ATTR_PST for read-only param!!\n";
		}
		$is_ro = 0;
		$is_rw = 0;
	} elsif (1 == $is_rw && /(ATTR_\S+)/) {
		if (substr($1, 0, 12) eq 'ATTR_DEFAULT') {
			print "file:[$fn], line:[$ml], param:[$p2] has ATTR_DEFAULT for writeable param!!\n";
		}
		$is_rw = 0;
		$is_ro = 0;
	} elsif (/(\S+_RO_\S+)\(*/) {
		$paraName = $1;
		$ml = $.;
		$t=<>;chomp;/(\S\+)/;$p2 = $1;
		$is_ro = 1;
	} elsif (/(\S+_RW_\S+)\(*/) {
		$paraName = $1;
		$ml = $.;
		$t=<>;chomp;/(\S\+)/;$p2 = $1;
		$is_rw = 1;
	}
}
