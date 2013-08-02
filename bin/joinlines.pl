#!/usr/bin/perl -w

open($IN,  "<$ARGV[0]");
open($OUT, ">$ARGV[1]");
while (<$IN>) {
	if(/\\$/) {
		chomp;
		print $OUT $_;
	} else {
		print $OUT $_;
	}
}
close $IN;
close $OUT;
