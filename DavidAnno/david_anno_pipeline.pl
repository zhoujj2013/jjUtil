#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
use lib "/home/zhoujj/my_lib/pm";
use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        David web api annotation pipeline.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <id_Type> <annotation category> <annotation_result_dir_name> <gene list1> [<gene list2> .. <gene listN>] <id2originName>
        Example:perl $0 ENSEMBL_GENE_ID GOTERM_BP_FAT,GOTERM_CC_FAT,GOTERM_MF_FAT ./david cachacia_muscle_diff_ensembl_id.lst cachacia_muscle_diff_ensembl_id_to_genename.lst &
		
Conversion Types:
AFFYMETRIX_3PRIME_IVT_ID,AFFYMETRIX_EXON_GENE_ID,AFFYMETRIX_SNP_ID,AGILENT_CHIP_ID,AGILENT_ID,AGILENT_OLIGO_ID,ENSEMBL_GENE_ID,ENSEMBL_TRANSCRIPT_ID,ENTREZ_GENE_ID,FLYBASE_GENE_ID,FLYBASE_TRANSCRIPT_ID,GENBANK_ACCESSION,GENOMIC_GI_ACCESSION,GENPEPT_ACCESSION,ILLUMINA_ID,IPI_ID,MGI_ID,PFAM_ID,PIR_ID,PROTEIN_GI_ACCESSION,REFSEQ_GENOMIC,REFSEQ_MRNA,REFSEQ_PROTEIN,REFSEQ_RNA,RGD_ID,SGD_ID,TAIR_ID,UCSC_GENE_ID,UNIGENE,UNIPROT_ACCESSION,UNIPROT_ID,UNIREF100_ID,WORMBASE_GENE_ID,WORMPEP_ID,ZFIN_ID

All available annotation category names:
BBID,BIND,BIOCARTA,BLOCKS,CGAP_EST_QUARTILE,CGAP_SAGE_QUARTILE,CHROMOSOME,COG_NAME,COG_ONTOLOGY,CYTOBAND,DIP,EC_NUMBER,ENSEMBL_GENE_ID,ENTREZ_GENE_ID,ENTREZ_GENE_SUMMARY,GENETIC_ASSOCIATION_DB_DISEASE,GENERIF_SUMMARY,GNF_U133A_QUARTILE,GENETIC_ASSOCIATION_DB_DISEASE_CLASS,GOTERM_BP_2,GOTERM_BP_1,GOTERM_BP_4,GOTERM_BP_3,GOTERM_BP_FAT,GOTERM_BP_5,GOTERM_CC_1,GOTERM_BP_ALL,GOTERM_CC_3,GOTERM_CC_2,GOTERM_CC_5,GOTERM_CC_4,GOTERM_MF_1,GOTERM_MF_2,GOTERM_CC_FAT,GOTERM_CC_ALL,GOTERM_MF_5,GOTERM_MF_FAT,GOTERM_MF_3,GOTERM_MF_4,HIV_INTERACTION_CATEGORY,HIV_INTERACTION_PUBMED_ID,GOTERM_MF_ALL,HIV_INTERACTION,KEGG_PATHWAY,HOMOLOGOUS_GENE,INTERPRO,OFFICIAL_GENE_SYMBOL,NCICB_CAPATHWAY_INTERACTION,MINT,PANTHER_MF_ALL,PANTHER_FAMILY,PANTHER_BP_ALL,OMIM_DISEASE,PFAM,PANTHER_SUBFAMILY,PANTHER_PATHWAY,PIR_SUPERFAMILY,PIR_SUMMARY,PIR_SEQ_FEATURE,PROSITE,PUBMED_ID,REACTOME_INTERACTION,REACTOME_PATHWAY,PIR_TISSUE_SPECIFICITY,PRINTS,PRODOM,PROFILE,SMART,SP_COMMENT,SP_COMMENT_TYPE,SP_PIR_KEYWORDS,SCOP_CLASS,SCOP_FAMILY,SCOP_FOLD,SCOP_SUPERFAMILY,UP_SEQ_FEATURE,UNIGENE_EST_QUARTILE,ZFIN_ANATOMY,UP_TISSUE,TIGRFAMS,SSF,UCSC_TFBS

USAGE
print "$usage";
exit(1);
};

my $type = shift @ARGV;
my $category = shift @ARGV;
my $prefix = shift @ARGV;

my $origin = pop @ARGV;

my $genelist = join " ",@ARGV;

`mkdir $prefix` unless(-e "$prefix");

# run david_anno_tableReport.pl
`perl $Bin/david_anno_tableReport.pl $type $category $prefix $genelist >>$prefix/$prefix.log 2>>$prefix/$prefix.log`;

# run david_anno_geneClusterReport.pl
`perl $Bin/david_anno_geneClusterReport.pl $type $category $prefix $genelist >>$prefix/$prefix.log 2>>$prefix/$prefix.log`;

# rum david_anno_termClusterReport.pl
`perl $Bin/david_anno_termClusterReport.pl $type $category $prefix $genelist >>$prefix/$prefix.log 2>>$prefix/$prefix.log`;


# conversion
# run gene to annotation
# cachacia_muscle_diff_offical_genename.lst.geneClusterReport.txt  cachacia_muscle_diff_offical_genename.lst.termClusterReport.txt
# cachacia_muscle_diff_offical_genename.lst.tableReport.txt
foreach my $f (@ARGV){
	my $fbname = basename($f);
	`perl $Bin/get_gene_anno_from_tableReport.pl $prefix/$fbname.tableReport.txt > $prefix/$fbname.gene2anno.txt`;
	`perl $Bin/reconvert_geneid.pl $origin $prefix/$fbname.gene2anno.txt > $prefix/$fbname.gene2anno.final.txt`;
	`perl $Bin/reconvert_geneid.pl $origin $prefix/$fbname.geneClusterReport.txt > $prefix/$fbname.geneClusterReport.final.txt`;
	`perl $Bin/reconvert_geneid.pl $origin $prefix/$fbname.termClusterReport.txt > $prefix/$fbname.termClusterReport.final.txt`;
	`perl $Bin/reconvert_geneid.pl $origin $prefix/$fbname.tableReport.txt > $prefix/$fbname.tableReport.final.txt`;
}
