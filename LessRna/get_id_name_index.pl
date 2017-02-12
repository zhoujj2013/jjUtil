#!/usr/bin/perl -w

use strict;

while(<>){
	next if(/^#/);
	my @t = split /\t/;
	next unless($t[2] eq "gene");
	my ($geneid,$genename) = ($1,$2) if($t[8] =~ /gene_id "([^"]+)";.*gene_name "([^"]+)"; /);
	print "$geneid\t$genename\n";
}
#print qw (grep -v "^#" gencode.v24lift37.annotation.gtf | awk '$3 == "gene"' | cut -f 9 | perl -ne 'chomp; my ($geneid,$genename) = ($1,$2) if(/gene_id "([^"]+)";.*gene_name "([^"]+)"; /); print "$geneid\t$genename\n";' > id.gene.index);
