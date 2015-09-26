#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Recover geneid to original one.
        Format: # origin ensembl/other_uniq_gene_id
        Author: zhoujj2013\@gmail.com
        Usage: $0 <tableReport> > result.txt

USAGE
print "$usage";
exit(1);
};

my $f = shift;

my %h;

my %anno_type;

open IN,"$f" || die $!;
<IN>;
while(<IN>){
    chomp;
    my @t = split /\t/;
	my @g = split /, /,$t[-1];
	$anno_type{$t[0]} = 1;
	foreach my $gid (@g){	
		$h{$gid}{$t[0]}{$t[-2]}  = 1;
	}
}
close IN;

my $header = join "\t", sort keys %anno_type;
print "#gid\t$header\n";
#print Dumper(\%h);

foreach my $gid (keys %h){
	print "$gid";
	foreach my $anno_k (sort keys %anno_type){
		if(exists $h{$gid}{$anno_k}){
			#print Dumper($h{$gid}{$anno_k}),"\n";
			my @str_arr = keys %{$h{$gid}{$anno_k}};
			my $str = join ";",@str_arr;
			print "\t$str";
		}else{
			print "\tNA";
		}
	}
	print "\n";
}
