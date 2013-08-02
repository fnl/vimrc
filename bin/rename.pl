#!/usr/bin/perl -w
# converting all files in a dir to lowercase:
# rename.pl 'tr/A-Z/a-z/ unless /^Make/' *
# from the Perl Cookbook
$op = shift or die "Usage: rename expr [files]\n";
chomp(@ARGV = <STDIN>) unless @ARGV;
for (@ARGV) {
    $was = $_;
    eval $op;
    die $@ if $@;
    rename($was, $_) unless $was eq $_;
}
