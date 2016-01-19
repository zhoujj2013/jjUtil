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

my ($platanno_f, $signal_f, $plat) = @ARGV;

my %id2gene;
if($plat =~ /affy/){
	open IN,"$platanno_f" || die $!;
	while(<IN>){
		chomp;
		next if(/^\!/);
		next if(/^$/);
		next if(/^\^/);
		next if(/^ID/);
		# col1 id
		# col3 pos
		# col10 gene assignment
		# col12 probe type
		my @t = split /\t/;
		if(!defined $t[11] or $t[11] eq "---"){
			$id2gene{$t[0]} = "Control\tControl\tControl";
		}else{
			my @anno = split /\/\/\//,$t[9];
			if(!defined $anno[0] or $anno[0] eq "---"){
				$id2gene{$t[0]} = "NA\tNA\tNA";
			}else{
				my @a = split /\/\//,$anno[0];
				#if(scalar(@a) < 2){
				#	print STDERR join "\t",@a,"\n";
				#}
				# transcript_id	gene_id position
				$id2gene{$t[0]} = "$a[0]\t$a[1]\t$t[2]";
				#print "$a[0]\t$a[1]\t$t[2]\n";
			}
		}
	}
	close IN;
}

#print STDERR Dumper(\%id2gene);

open IN,"$signal_f" || die $!;
my $header =  <IN>;
my @header = split /\t/,$header;
my $col1 = shift @header;
print "#$col1\tTrans_id\tgene_id\tpos\t";
print join "\t",@header;

while(<IN>){
	chomp;
	my @t = split /\t/;
	my $id = shift @t;
	print "$id\t";
	print "$id2gene{$id}\t";
	print join "\t",@t;
	print "\n";
}
close IN;
