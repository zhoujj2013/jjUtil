#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
#use lib "/home/zhoujj/my_lib/pm";
#use bioinfo;

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

my $refgene = shift;

my %trans;
open IN,"$refgene" || die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	next if($t[2] =~ /_/);
	my $transid = $t[1];
	push @{$trans{$transid}},\@t;
}
close IN;


foreach my $transid (keys %trans){
	my $ls = $trans{$transid};
	
	for(my $i = 0; $i < scalar(@{$ls}); $i++){
		my $l = $ls->[$i];
		my $id;
		if($i > 0){
			$id = $l->[1]."#".$i;
			#print STDERR "$id\n";
		}else{
			$id = $l->[1];
		}
		#($i > 0) ? $id = $l->[2]."-".$i : $id = $l->[2];
		my $s = $l->[4] - 1;
		my $e = $l->[4];
		print "$l->[2]\t$s\t$e\t$id\t$l->[12]\t$l->[3]\n";
	}
}
