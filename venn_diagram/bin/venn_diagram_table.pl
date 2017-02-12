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

        Create venn diagram table.
        Author: zhoujj2013\@gmail.com
        Usage: $0 table1 table2 table3 ...
        NOTE: no more than 5.

USAGE
print "$usage";
exit(1);
};


#my ($a_f,$b_f,$c_f,$d_f,$e_f) = @ARGV;

# deal with the parameters
#my @tag;
my @f = @ARGV;
#foreach my $fstr (@ARGV){
#	my ($tag,$f) = split /:/,$fstr;
#	push @tag,$tag;
#	push @f,$f;
#}

# storm all the genes
my %g;
foreach my $f (@f){
	open IN,"$f" || die $!;
	while(<IN>){
		chomp;
		my @t = split /\t/;
		my @arr;
		if(scalar(@f) == 3){
			@arr = (0,0,0);
		}elsif(scalar(@f) == 4){
			@arr = (0,0,0,0);
		}elsif(scalar(@f) == 5){
			@arr = (0,0,0,0,0);
		}
		$g{$t[0]} = \@arr;
	}
	close IN;
}


for(my $i = 0; $i < scalar(@f); $i++){
	open IN,"$f[$i]" || die $!;
	while(<IN>){
		chomp;
		my @t = split /\t/;
		$g{$t[0]}->[$i] = 1;
	}
	close IN;
}

foreach my $g (keys %g){
	print "$g\t";
	print join "\t",@{$g{$g}};
	print "\n";
}

