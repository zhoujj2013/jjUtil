#!/usr/bin/perl -w

use strict;

open IN,"$ARGV[0]" || die $!;
while(<IN>){
	chomp;
	my @t = split /\s+/;
	`wget -O $t[0].html https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=$t[0]`;
	sleep 10;
	open HTML,"$t[0].html" || die $!;
	while(<HTML>){
		chomp;
		my $srx_link = "";
		my $srx_id = "";
		if(/<td><a href="(.*)">(SRX\d+)<\/a><\/td>/){
			$srx_link = $1;
			$srx_id = $2;
			`wget -O $srx_id.html $srx_link`;
			open SRX,"$srx_id.html" || die $!;
			while(<SRX>){
				chomp;
				my @srr_id;
				@srr_id = ($_ =~ /<a href=".*">(SRR\d+)<\/a>/);
				if(scalar(@srr_id) > 0){
					foreach my $id (@srr_id){
						print "$t[0]\t$t[1]\t$id\n";
					}
				}
			}
			close SRX;
			`rm $srx_id.html`;
			#print "$srx_link\n";
		}
	}
	close HTML;
	#print "$t[0]\n";
	`rm $t[0].html`;
}
close IN;


#`wget `;
