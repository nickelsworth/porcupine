#!/usr/bin/perl
use 5.10.00;
use warnings;
use strict;
use File::Find;
use File::Basename;
our @TEST;
our $RESULT;

`rm -rf cts`;
`mkdir -p cts`;

#find tests.
find sub {
	return if $_ =~ /^\./ or $_ !~ /\.t$/; 
	push @TEST, $_;}, 't';

foreach (sort @TEST) {
	`cp t/$_ cts/$_.pas`;
	say "Compiling $_.pas";
	`gpc -Wall cts/$_.pas -o cts/$_`;

	if (-e "cts/$_")
	{
		say "Testing $_";
		print `cts/$_`;

	}

	$RESULT->{$_} = (-e "cts/$_")?1:0;
	say '';
}

say $_ . ($RESULT->{$_} ? " - ok" : " - failed") foreach (sort keys %$RESULT );
