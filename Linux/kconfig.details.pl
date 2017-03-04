#!/bin/perl

use Data::Dumper;
use IO::Handle;
#use Term::ReadKey;

%all_configs = ();
sub merge_kconfig {
	open KCF, "<@_[0]" or die;
	print "processing @_[0]\n";

	my $debug = 0;
	$debug = 1 if (@_[0] =~ /realtek/);

	$new_key  = "";
	$new_text = "";
	while (<KCF>) {
		if ((/^\s*config\s+(\S+)\s*$/) || (/^\s*menuconfig\s+(\S+)\s*$/)) {
			print "config:$_" if ($debug);
			if ("" ne $new_key) {
				#push(@{$all_configs{$new_key}}, {filename=>@_[0], config=>$new_text});
				if (exists $all_configs{$new_key}) {
					print "overwritting {$new_key} ==>" .  Dumper($all_configs{$new_key}) . "\n";
				}
				$all_configs{$new_key} = {filename=>@_[0], config=>$new_text};
				print Dumper($all_configs{$new_key}) if ($debug);
			}
			$new_key = $1;
			$new_text = $_;
		} elsif ($new_key ne "") {
			$new_text = $new_text . $_;
		}
	}
	close KCF;
}

my $dir_space = "";
sub search_dir {
	opendir my $DH, "@_[0]" or die;
	$dir_space = $dir_space . "    ";
	while (readdir $DH) {
		#print "$dir_space$_\n";
		if (/Kconfig/) {
			merge_kconfig "@_[0]/$_";
		} elsif (/^\.\.?$/) {
		} elsif (-d "@_[0]/$_") {
			search_dir("@_[0]/$_");
		}
	}
	$dir_space = substr $dir_space, -4;
	closedir $DH;
}


sub proc_defconfig {
	open CONFIG, "<@ARGV[0]"     or die;
	open OUTF,   ">@ARGV[0].txt" or die;

	search_dir '.';
	#print Dumper(%all_configs);

	while (<CONFIG>) {
		print OUTF $_;
		if (/CONFIG_(\S+)\s*=/) {
			#print 'filename={' . @{@cfgs[0]}[0]{'filename'} . "}!!\n";
			#print OUTF  "    " . $all_configs{$1}{config};
			print OUTF  "\t" . $all_configs{$1}{config};
			print OUTF  "\t" . $all_configs{$1}{filename} . "\n\n";
		}
	}

	#print Dumper($all_configs{'R8169'});

	close CONFIG;
	close OUTF;
}

sub proc_console {
	if (0 <= $#ARG && -d @ARG[0]) {
		search_dir @ARG[0]
	} else {
		search_dir "."
	}

	my @cfgs = keys %all_configs;
	my $exit = 0;
	my $stdin = new IO::Handle;
	$stdin->fdopen(fileno(STDIN), "r") or die;
	my $tty_s = `stty -g`;
	system "stty -icanon -isig echo min 1 time 0";
	#ReadMode 4;

	while (! $exit) {
		my $input = "";

		print "Total CONFIG_: $#cfgs. Input any word to filter the results.\n";
		print '$ ';

		while (1) {
			my $c = $stdin->getc();
			#my $c = ReadKey(-1);#$stdin->getc();
			if (9 == ord($c)) {
				print "\n";
				for $tc (grep(/$input/i, @cfgs)) {
					print "\t$tc\n";
				}
				print '$ ' . $input;
			} elsif (10 == ord($c)) {
				if ('exit' eq $input || 'quit' eq $input || 'q' eq $input) {
					$exit = 1;
				} else {
					for $cfg (@cfgs) {
						if ($cfg =~ /$input/i) {
							print $all_configs{$cfg}{config};
							print "\t". $all_configs{$cfg}{filename}. "\n\n";
						}
					}
				}
				last;
			} else {
				$input = $input . $c;
			}
		}
	}

	system "stty $tty_s";
	#ReadMode 0;
}

if (0 <= $#ARG && -f @ARG[0]) {
	proc_defconfig;
} else {
	proc_console;
}

