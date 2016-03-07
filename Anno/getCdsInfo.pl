#!/usr/bin/perl -w

use strict;

=cut
     gene            818713..844224
                     /gene=ENSMUSG00000069053
                     /locus_tag="Uba1y"
                     /note="ubiquitin-activating enzyme, Chr Y [Source:MGI
                     Symbol;Acc:MGI:98891]"
=cut

foreach my $gbk (@ARGV){
	open IN,"$gbk" || die $!;
	my $flag = 0;
	my @lines;
	while(<IN>){
		chomp;
		if(/^\s\s\s\s\sgene/){
			$flag = 1;
			next;
		}
		
		next if($flag == 0);
		unless($flag == 1 && /^                     /){
			$flag = 0;
			#print "\n##################\n";
			my @newLines;
			foreach my $l (@lines){
				$l =~ s/^(                     )//g;
				push @newLines,$l;
			}
			my $lineStr = join " ",@newLines;
			my $gene = $1 if($lineStr =~ /\/gene=(\S+)/);
			my $locus_tag = $1 if($lineStr =~ /\/locus_tag="([^"]+)"/);
			my $note;
			if($lineStr =~ /\/note="([^"]+)"/){
				$note = $1;
			}else{
				$note = "NA";
			}
			print "$gene\t$locus_tag\t$note\n";
			#print "\n##################\n";
			@lines = ();
			next;
		}
		
		if($flag == 1 && /^                     /){
			push @lines,$_;
		}
	}
	close IN;
}