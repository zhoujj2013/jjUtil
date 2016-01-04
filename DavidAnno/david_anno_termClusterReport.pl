#!/usr/bin/perl -w
#use strict;
#use warnings;
use SOAP::Lite;
use HTTP::Cookies;
use Data::Dumper;
use File::Basename qw(basename dirname);


my $soap = SOAP::Lite
     -> uri('http://service.session.sample')
     -> proxy('http://david.abcc.ncifcrf.gov/webservice/services/DAVIDWebService',
               ssl_opts => [ SSL_verify_mode => 'SSL_VERIFY_NONE' ],
                cookie_jar => HTTP::Cookies->new(ignore_discard=>1));

#user authentication by email address
#For new user registration, go to http://david.abcc.ncifcrf.gov/webservice/register.htm
my $check = $soap->authenticate('zhoujiajian@cuhk.edu.hk')->result;
print "User authentication: $check\n";

my $db = shift @ARGV;
my $category = shift @ARGV;
my $prefix = shift @ARGV;

# check whether get the david session
if(lc($check) ne "true"){
    print "#Program_dead\n";
    exit(1);
}


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
        next if(/^#/);
        my @t = split /\t/;
        my $id = shift @t;
        push @gene_list,$id;
    }
    close IN;

    # david annotation
    &get_anno(\@gene_list, $gene_list_f_base, $db, $category, $prefix);
}

sub get_anno{
    my ($glist, $bname, $db_name, $categ, $p) = @_;
	
	#list conversion types
    my $conversionTypes = $soap ->getConversionTypes()->result;
    print  "Conversion Types: \n$conversionTypes\n\n";

	#list all annotation category names
    my $allCategoryNames= $soap ->getAllAnnotationCategoryNames()->result;
    print  "All available annotation category names: \n$allCategoryNames\n\n";

	my $inputIds = join ",",@$glist;
    my $idType = "$db_name";
    my $listName = "$bname.lst";
    my $listType = 0;

    # set the list to david server
    print "upload target gene list\n";
    my $list = $soap ->addList($inputIds, $idType, $listName, $listType)->result;
    print "$list of list was mapped\n\n";

    #set user defined categories 
    my $categories = $soap ->setCategories($categ)->result;
    #to user DAVID default categories, send empty string to setCategories():
    print "\nValid categories: \n$categories\n";

	open (termClusterReport, ">", "$p/$bname.termClusterReport.txt");

	my $overlap=3;
	my $initialSeed = 3;
	my $finalSeed = 3;
	my $linkage = 0.5;
	my $kappa = 20;
	my $termClusterReport = $soap->getTermClusterReport($overlap,$initialSeed,$finalSeed,$linkage,$kappa);
	#my $termClusterReport = $soap->getTermClusterReport();
	my @simpleTermClusterRecords = $termClusterReport->paramsout; 	
	print "Total TermClusterRecords: ".(@simpleTermClusterRecords+1)."\n\n";
	next if(scalar(@simpleTermClusterRecords) < 1);
	my @simpleTermClusterRecordKeys = keys %{$termClusterReport->result};		
	my @simpleTermClusterRecordValues = values %{$termClusterReport->result};
		
	@chartRecords = @{$simpleTermClusterRecordValues[1]};
	
	print termClusterReport "Annotation Cluster 1\tEnrichment Score:  $simpleTermClusterRecordValues[2]\n";
	print termClusterReport "Category\tTerm\tCount\t%\tPvalue\tGenes\tList Total\tPop Hits\tPop Total\tFold Enrichment\tBonferroni\tBenjamini\tFDR\n";
	for $j (0 .. (@chartRecords-1))
	{			
		%chartRecord = %{$chartRecords[$j]};	
			
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
		
		print termClusterReport "$categoryName\t$termName\t$listHits\t$percent\t$ease\t$Genes\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\n";
	
	}	
	for $k (0 .. (@simpleTermClusterRecords-1))
	{	
		my $itr=$k+2;
		@simpleTermClusterRecordValues = values %{$simpleTermClusterRecords[$k]};
		@chartRecords = @{$simpleTermClusterRecordValues[1]};
		print termClusterReport "\nAnnotation Cluster $itr\tEnrichment Score:  $simpleTermClusterRecordValues[2]\n";
		print termClusterReport "Category\tTerm\tCount\t%\tPvalue\tGenes\tList Total\tPop Hits\tPop Total\tFold Enrichment\tBonferroni\tBenjamini\tFDR\n";
		for $j (0 .. (@chartRecords-1))
		{			
			%chartRecord = %{$chartRecords[$j]};
			
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
			
			print termClusterReport "$categoryName\t$termName\t$listHits\t$percent\t$ease\t$Genes\t$listTotals\t$popHits\t$popTotals\t$foldEnrichment\t$bonferroni\t$benjamini\t$FDR\n";		
		}
	}
	close termClusterReport;
	print "$p/$bname.termClusterReport.txt generated\n";
    print "#$bname succeed\n";
}
__END__
