#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use lib "/home/zhoujj/my_lib/pm";
use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Description of this script.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <para1> <para2>
        Example:perl $0 para1 para2

USAGE
print "$usage";
exit(1);
};


my ($origin, $result) = @ARGV;

my %r2o; # result to origin

open IN,"$origin" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	$r2o{$t[1]} = $t[0];
}
close IN;
#print Dumper(\%r2o);

open IN,"$result" || die $!;
while(<IN>){
	my $l = $_;
	foreach my $r (keys %r2o){
		my $o = $r2o{$r};
		$l =~ s/$r/$o/g;
	}
	print "$l";
}
close IN;
