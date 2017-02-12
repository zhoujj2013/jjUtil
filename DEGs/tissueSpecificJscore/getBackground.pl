#!/usr/bin/perl -w

use Data::Dumper;

my %arr;
my %index;
open IN,"$ARGV[1]"|| die $!;
while(<IN>){
	chomp;
	my @t = split /\t/;
	next if($t[2] == 0);
	$index{$t[2]} = $t[3];
	push @{$arr{$t[2]}},$t[0];
	
}
close IN;

my @name;
open IN,"$ARGV[0]" || die $!;
<IN>;
while(<IN>){
	chomp;
	my @t = split /\t/;
	push @name,$t[0];
}
close IN;

my %expr;
foreach my $k (sort keys %arr){
	open IN,"$ARGV[0]" || die $!;
	<IN>;
	while(<IN>){
		chomp;
		my @t = split /\t/;
		my @genes;
		my $expr_sum = 0;
		foreach my $i (@{$arr{$k}}){
			push @genes,$t[$i];
			$expr_sum = $expr_sum + $t[$i];
		}
		my $avg = $expr_sum/scalar(@genes);
		push @{$expr{$k}},$avg;
	}
	close IN;
}

my %gexpr;
for(my $i = 0; $i < scalar(@name); $i++){
	foreach my $k (sort keys %expr){
		push @{$gexpr{$name[$i]}},$expr{$k}->[$i];
	}
}

my @col_name;
foreach my $k (sort keys %index){
	push @col_name,$index{$k};
}

print "ensemblid\t";
print join "\t",@col_name;
print "\n";

open OUT,">","sp.group.input" || die $!;
my $j = 1;
foreach my $c (@col_name){
	print OUT "$j\t$c\t$j\n";
	$j++;
}
close OUT;

foreach my $k (sort keys %gexpr){
	print "$k\t";
	print join "\t",@{$gexpr{$k}};
	print "\n";
}

#print Dumper(\%gexpr);
