#!/usr/bin/perl

die if $#ARGV ne 0;

$fn = @ARGV[0];
print "checking $fn...";
while(<>) {

#	printf "ro:$is_ro, rw:$is_rw, ml=$ml, para=$paraName, p2=$p2, $_";
	if (1 == $is_ro && /(ATTR_\S+)/) {
		if (substr($1, 0, 8) eq 'ATTR_PST') {
			print "\nfile:[$fn], line:[$ml], param:[$p2] has ATTR_PST for read-only param!!";
		}
		$is_ro = 0;
		$is_rw = 0;
	} elsif (1 == $is_rw && /(ATTR_\S+)/) {
		if (substr($1, 0, 12) eq 'ATTR_DEFAULT') {
			print "\nfile:[$fn], line:[$ml], param:[$p2] has ATTR_DEFAULT for writeable param!!";
		}
		$is_rw = 0;
		$is_ro = 0;
	} elsif (/(\S+_RO_\S+)\(*/) {
		$paraName = $1;
		$ml = $.;
		$t=<>;chomp;$t=~/(\S\+)\s*,/;$p2 = $1;
		$is_ro = 1;
	} elsif (/(\S+_RW_\S+)\(*/) {
		$paraName = $1;
		$ml = $.;
		$t=<>;chomp;$t=~/(\S+)\s*,/;$p2 = $1;
		$is_rw = 1;
	}
}
print "done!\n";
