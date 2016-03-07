#!/usr/bin/perl -w

use strict;

=cut
     CDS             33265..33975
                     /gene="ENSSSCG00000025728"
                     /protein_id="ENSSSCP00000027045"
                     /note="transcript_id=ENSSSCT00000027478"
                     /db_xref="RefSeq_peptide:NP_999617.1"
                     /db_xref="RefSeq_mRNA:NM_214452.2"
                     /db_xref="RefSeq_mRNA_predicted:XM_003360537.1"
                     /db_xref="RefSeq_peptide_predicted:XP_003360585.1"
                     /db_xref="Uniprot/SPTREMBL:I3LMN8_PIG"
                     /db_xref="Uniprot/SPTREMBL:Q5I921_PIG"
                     /db_xref="Uniprot/SPTREMBL:Q9TTP1_PIG"
                     /db_xref="EMBL:AY842532"
                     /db_xref="EMBL:AY842533"
                     /db_xref="EMBL:AY842535"
                     /db_xref="EMBL:D10846"
                     /db_xref="EMBL:FP565153"
                     /db_xref="EMBL:FQ311950"
                     /db_xref="EMBL:GU143100"

=cut

foreach my $gbk (@ARGV){
	open IN,"$gbk" || die $!;
	my $flag = 0;
	my @lines;
	while(<IN>){
		chomp;
		if(/^\s\s\s\s\s(CDS)/){
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
			my $gene = $1 if($lineStr =~ /\/gene="([^"]+)"/);
			#my $locus_tag = $1 if($lineStr =~ /\/locus_tag="([^"]+)"/);
			my @note;
			if($lineStr =~ /\/note="([^"]+)"/){
				@note = $lineStr =~ /\/note="([^"]+)"/g;
			}else{
				push @note,"NA";
			}
			$note[-1] =~ s/transcript_id=//g;
			my @db_ref;
			if($lineStr =~ /\/db_xref="([^"]+)"/){
				@db_ref = $lineStr =~ /\/db_xref="([^"]+)"/g;
			}else{
				push @db_ref,"NA";
			}
			
			my @output;
			# GO information
			foreach my $db (@db_ref){
				next unless($db =~ /goslim_goa/);
				my @db = split /:/,$db;
				push @output,"$db[-2]:$db[-1]";
			}
		
			# db	
			print "$gene\t$note[-1]\t";
			print join "\t",@output;
			print "\n";
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
