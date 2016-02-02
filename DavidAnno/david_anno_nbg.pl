#!/usr/bin/perl -w
use strict;
use warnings;

use SOAP::Lite;
use HTTP::Cookies;
use Data::Dumper;
use File::Basename qw(basename dirname);

&usage if @ARGV<4;

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

my $soap = SOAP::Lite
     -> uri('http://service.session.sample')
     #-> proxy('http://david.abcc.ncifcrf.gov/webservice/services/DAVIDWebService',
	 -> proxy('http://david.abcc.ncifcrf.gov/webservice/services/DAVIDWebService',
                cookie_jar => HTTP::Cookies->new(ignore_discard=>1));

#user authentication by email address
#For new user registration, go to http://david.abcc.ncifcrf.gov/webservice/register.htm
my $check = $soap->authenticate('zhoujiajian@cuhk.edu.hk')->result;
print "User authentication: $check\n\n";

sub usage {
        my $usage = << "USAGE";

        This script design for david gene function annotation base on the default background.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <id_Type> <annotation category> <annotation_result_dir_name [./david]> <gene list1> [<gene list2> .. <gene listN>]
		
        id_Type: AFFYMETRIX_3PRIME_IVT_ID,AFFYMETRIX_EXON_GENE_ID,AFFYMETRIX_SNP_ID,AGILENT_CHIP_ID,AGILENT_ID,AGILENT_OLIGO_ID,ENSEMBL_GENE_ID,ENSEMBL_TRANSCRIPT_ID,ENTREZ_GENE_ID,FLYBASE_GENE_ID,FLYBASE_TRANSCRIPT_ID,GENBANK_ACCESSION,GENOMIC_GI_ACCESSION,GENPEPT_ACCESSION,ILLUMINA_ID,IPI_ID,MGI_ID,PFAM_ID,PIR_ID,PROTEIN_GI_ACCESSION,REFSEQ_GENOMIC,REFSEQ_MRNA,REFSEQ_PROTEIN,REFSEQ_RNA,RGD_ID,SGD_ID,TAIR_ID,UCSC_GENE_ID,UNIGENE,UNIPROT_ACCESSION,UNIPROT_ID,UNIREF100_ID,WORMBASE_GENE_ID,WORMPEP_ID,ZFIN_ID

        Available annotation category names: BBID,BIND,BIOCARTA,BLOCKS,CGAP_EST_QUARTILE,CGAP_SAGE_QUARTILE,CHROMOSOME,COG_NAME,COG_ONTOLOGY,CYTOBAND,DIP,EC_NUMBER,ENSEMBL_GENE_ID,ENTREZ_GENE_ID,ENTREZ_GENE_SUMMARY,GENETIC_ASSOCIATION_DB_DISEASE,GENERIF_SUMMARY,GNF_U133A_QUARTILE,GENETIC_ASSOCIATION_DB_DISEASE_CLASS,GOTERM_BP_2,GOTERM_BP_1,GOTERM_BP_4,GOTERM_BP_3,GOTERM_BP_FAT,GOTERM_BP_5,GOTERM_CC_1,GOTERM_BP_ALL,GOTERM_CC_3,GOTERM_CC_2,GOTERM_CC_5,GOTERM_CC_4,GOTERM_MF_1,GOTERM_MF_2,GOTERM_CC_FAT,GOTERM_CC_ALL,GOTERM_MF_5,GOTERM_MF_FAT,GOTERM_MF_3,GOTERM_MF_4,HIV_INTERACTION_CATEGORY,HIV_INTERACTION_PUBMED_ID,GOTERM_MF_ALL,HIV_INTERACTION,KEGG_PATHWAY,HOMOLOGOUS_GENE,INTERPRO,OFFICIAL_GENE_SYMBOL,NCICB_CAPATHWAY_INTERACTION,MINT,PANTHER_MF_ALL,PANTHER_FAMILY,PANTHER_BP_ALL,OMIM_DISEASE,PFAM,PANTHER_SUBFAMILY,PANTHER_PATHWAY,PIR_SUPERFAMILY,PIR_SUMMARY,PIR_SEQ_FEATURE,PROSITE,PUBMED_ID,REACTOME_INTERACTION,REACTOME_PATHWAY,PIR_TISSUE_SPECIFICITY,PRINTS,PRODOM,PROFILE,SMART,SP_COMMENT,SP_COMMENT_TYPE,SP_PIR_KEYWORDS,SCOP_CLASS,SCOP_FAMILY,SCOP_FOLD,SCOP_SUPERFAMILY,UP_SEQ_FEATURE,UNIGENE_EST_QUARTILE,ZFIN_ANATOMY,UP_TISSUE,TIGRFAMS,SSF,UCSC_TFBS

        help information END.
USAGE

print "$usage";
exit(1);
};

my $db = shift @ARGV;
my $category = shift @ARGV;
my $prefix = shift @ARGV;

# check whether get the david session
if(lc($check) ne "true"){
	print "#Program_death\n";
	exit(1);
}

# set the background (didn't setup bg)
=cut
my @b_list;
open IN,"$bg_f" || die $!;
while(<IN>){
	chomp;
	push @b_list,$_;
}
close IN;

my $b_input = join ",",@b_list;
my $b_id_type = "$db";
my $b_listname = basename($bg_f).".bg.lst";
my $b_listType = 1;

print "upload background gene list\n";
my $bkgList = $soap ->addList($b_input, $b_id_type, $b_listname, $b_listType)->result;
print "$bkgList of list was mapped\n\n";
=cut
# the background should be set after gene list
#print $soap ->getAllPopulationNames() ->result;#should return:Homo sapiens,Human Genome U133 Plus 2.0 array
#print "\n";
#print $soap ->getCurrentPopulation() ->result;# should return 1. If 0 returned, means currentPopulation is Homo sapiens
#print "\n";
#print $soap->getCurrentList()->result;
#print "\n";
#$soap ->setCurrentPopulation("1") ->result;
#print $soap ->getCurrentPopulation() ->result; #should return 1
#print "\n";

# create dir
mkdir "./$prefix" unless(-e "./$prefix");

# read in the gene name file
foreach(@ARGV){
	my $gene_list_f = $_;
	my $gene_list_f_base = basename($gene_list_f);
	my @gene_list;

	open IN,"$gene_list_f" || die $!;
	while(<IN>){
    	chomp;
    	push @gene_list,$_;
	}
	close IN;
	
	# david annotation
	&get_anno(\@gene_list, $gene_list_f_base, $db, $category, $prefix);
}

sub get_anno{
	my ($glist, $bname, $db_name, $categ, $prefix) = @_;
	
    #list conversion types
    my $conversionTypes = $soap ->getConversionTypes()->result;
    print  "Conversion Types: \n$conversionTypes\n\n";
    
    #list all annotation category names
    my $allCategoryNames= $soap ->getAllAnnotationCategoryNames()->result;
    print  "All available annotation category names: \n$allCategoryNames\n\n";
    
    my $inputIds = join ",",@$glist;
    my $idType = "$db_name";
    my $listName = "$bname.lst";
    my $listType=0;

    # set the list to david server
	print "upload target gene list\n";
    my $list = $soap ->addList($inputIds, $idType, $listName, $listType)->result;
    print "$list of list was mapped\n\n";
	
	# get current list
	print "CurrentList:".$soap->getCurrentList()->result;
	print " # 0 means the lastest upload gene list; 1 means the wrong list\n";
	
	# get current population
	print "AllPopulationNames: ".$soap ->getAllPopulationNames() ->result; print "\n";
	print "CurrentPopulation: ".$soap ->getCurrentPopulation() ->result; print "\n\n";
	
	# use the default background
	#print "Set CurrentPopulation...\n";
	#$soap ->setCurrentPopulation("1") ->result;
	#print "CurrentPopulation: ".$soap ->getCurrentPopulation() ->result; print "\n\n";

	#list all species  names
	my $allSpecies= $soap ->getSpecies()->result;
	print  "All species: $allSpecies\n\n";
	
	my $currentSpecies= $soap ->getCurrentSpecies()->result;
	print  "Current species: $currentSpecies\n\n";

	my $categories = $soap ->setCategories($categ)->result;
	print "Current Categories: $categories\n\n";

	open (chartReport, ">", "$prefix/$bname.nbg.david");
	#print chartReport "Category\tTerm\tCount\t%\tPvalue\tGenes\tList Total\tPop Hits\tPop Total\tFold Enrichment\tBonferroni\tBenjamini\tFDR\n";
	print chartReport "Category\tCount\t%\tPvalue\tList Total\tPop Hits\tPop Total\tFold Enrichment\tBonferroni\tBenjamini\tFDR\tTerm\tGenes\n";
	
	my $thd = 0.05;
	my $ct = 2;
	my $chartReport = $soap->getChartReport($thd,$ct);
	my @chartRecords = $chartReport->paramsout;
	
	print "\nTotal chart records: ".(@chartRecords+1)."\n";
    next if(scalar(@chartRecords) < 1);
	#my $retval = %{$chartReport->result};
    my @chartRecordKeys = keys %{$chartReport->result};

    #print "@chartRecordKeys\n";

    my @chartRecordValues = values %{$chartReport->result};

    my %chartRecord = %{$chartReport->result};
    my $categoryName = $chartRecord{"categoryName"};
    my $termName = $chartRecord{"termName"};
    my $listHits = $chartRecord{"listHits"};
    my $percent = $chartRecord{"percent"};
    my $ease = $chartRecord{"ease"};
    my $Genes = $chartRecord{"geneIds"};
    my $listTotals = $chartRecord{"listTotals"};
    my $popHits = $chartRecord{"popHits"};
    my $popTotals = $chartRecord{"popTotals"};
    my $foldEnrichment = $chartRecord{"foldEnrichment"};
    my $bonferroni = $chartRecord{"bonferroni"};
    my $benjamini = $chartRecord{"benjamini"};
    my $FDR = $chartRecord{"afdr"};
	
	#print chartReport "$categoryName\t$termName\t$listHits\t$percent\t$ease\t$Genes\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\n";
	print chartReport "$categoryName\t$listHits\t$percent\t$ease\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\t$termName\t$Genes\n";


    for my $j (0 .. (@chartRecords-1))
    {
        %chartRecord = %{$chartRecords[$j]};
        $categoryName = $chartRecord{"categoryName"};
        $termName = $chartRecord{"termName"};
        $listHits = $chartRecord{"listHits"};
        $percent = $chartRecord{"percent"};
        $ease = $chartRecord{"ease"};
        $Genes = $chartRecord{"geneIds"};
        $listTotals = $chartRecord{"listTotals"};
        $popHits = $chartRecord{"popHits"};
        $popTotals = $chartRecord{"popTotals"};
        $foldEnrichment = $chartRecord{"foldEnrichment"};
        $bonferroni = $chartRecord{"bonferroni"};
        $benjamini = $chartRecord{"benjamini"};
        $FDR = $chartRecord{"afdr"};
        #print chartReport "$categoryName\t$termName\t$listHits\t$percent\t$ease\t$Genes\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\n";
		print chartReport "$categoryName\t$listHits\t$percent\t$ease\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\t$termName\t$Genes\n";
    }

    close chartReport;
    print "$prefix/$bname.b.david generated\n";
	print "#$bname succeed\n";
}

