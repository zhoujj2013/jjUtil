#!/usr/bin/perl -w

use strict;

=cut
     mRNA            join(complement(797275..797409),
                     complement(797111..797176),complement(759850..759937),
                     complement(738592..739143),complement(735019..735168),
                     complement(732928..733068),complement(729614..729736),
                     complement(727509..727649),complement(725207..726595))
                     /gene="ENSMUSG00000053211"
                     /note="transcript_id=ENSMUST00000065545"

=cut

foreach my $gbk (@ARGV){
	open IN,"$gbk" || die $!;
	my $flag = 0;
	my @lines;
	while(<IN>){
		chomp;
		if(/^\s\s\s\s\s(mRNA|misc_RNA)/){
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
			#my $locus_tag = $1 if($lineStr =~ /\/locus_tag="([^"]+)"/);
			my $note;
			if($lineStr =~ /\/note="([^"]+)"/){
				$note = $1;
			}else{
				$note = "NA";
			}
			print "$gene\t$note\n";
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
