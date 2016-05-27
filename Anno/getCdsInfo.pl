#!/usr/bin/perl -w

use strict;
my $prefix = shift;
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

open OUT,">","./$prefix.swissprot" || die $!;
open OUT1,">","./$prefix.trembl" || die $!;
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
			print "$gene\t$note[-1]\t";
			print join "\t",@output;
			print "\n";
			
			# TREMBL	
			my @uniprot;	
			foreach my $db (@db_ref){
				next unless($db =~ /Uniprot\/SPTREMBL/);
				my @db = split /:/,$db;
				my @newdb = split /_/,$db[1];
				
				push @uniprot,"$newdb[0]";
			}
			push @uniprot,"NA" if(scalar(@uniprot) eq 0);	
			print OUT1 "$gene\t$note[-1]\t";
			print OUT1 join "\t",@uniprot;
			print OUT1 "\n";
			
			# SWISSPROT
			my @sw;	
			foreach my $db (@db_ref){
				next unless($db =~ /Uniprot\/SWISSPROT/);
				my @db = split /:/,$db;
				my @newdb = split /_/,$db[1];
				
				push @sw,"$newdb[0]";
			}
			push @sw,"NA" if(scalar(@sw) eq 0);	
			print OUT "$gene\t$note[-1]\t";
			print OUT join "\t",@sw;
			print OUT "\n";
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
close OUT;
close OUT1;
