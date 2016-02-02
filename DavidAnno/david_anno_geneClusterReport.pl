#!/usr/bin/perl -w
#use strict;
#use warnings;
use SOAP::Lite;
use HTTP::Cookies;
use Data::Dumper;
use File::Basename qw(basename dirname);

$ENV{'PERL_LWP_SSL_VERIFY_HOSTNAME'} = 0;

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
 
	open (geneClusterReport, ">", "$p/$bname.geneClusterReport.txt");

	#test getGeneClusterReport()
	my $overlap=3;
	my $initialSeed = 2;
	my $finalSeed = 2;
	my $linkage = 0.5;
	my $kappa = 35;
	my $geneClusterReport = $soap->getGeneClusterReport($overlap,$initialSeed,$finalSeed,$linkage,$kappa);
	my @simpleGeneClusterRecords = $geneClusterReport->paramsout; 	
	print "Total SimpleGeneClusterRecords: ".(@simpleGeneClusterRecords+1)."\n\n"; 

	my @simpleGeneClusterRecordKeys = keys %{$geneClusterReport->result};		
	my @simpleGeneClusterRecordValues = values %{$geneClusterReport->result};	
	@listRecords = @{$simpleGeneClusterRecordValues[0]};	
	my $scoreValue=$simpleGeneClusterRecordValues[2];
	print geneClusterReport "Gene Group 1\tEnrichment Score:  $scoreValue\n";
	print geneClusterReport "ID\tGene Name\n";
	
	for $n ( 0 .. (@listRecords-1))
	{
		my @listRecords_keys = keys %{$listRecords[$n]};
		my @listRecords_values = values %{$listRecords[$n]};
		print geneClusterReport "$listRecords_values[2]\t$listRecords_values[1]\n";
		
	}
	
	
	for $k (0 .. (@simpleGeneClusterRecords-1))
	{
	
		my $itr = $k+2;	
		@simpleGeneClusterRecordKeys = keys %{$simpleGeneClusterRecords[$k]};	
	  	@simpleGeneClusterRecordValues = values %{$simpleGeneClusterRecords[$k]};
		$scoreValue=$simpleGeneClusterRecordValues[2];
		print geneClusterReport "\nGene Group $itr\tEnrichment Score:  $scoreValue\n";
		print geneClusterReport "ID\tGene Name\n";
		my @listRecords = @{$simpleGeneClusterRecordValues[0]};
						 			
		for $n ( 0 .. (@listRecords-1))
		{
			my @listRecords_keys = keys %{$listRecords[$n]};
			my @listRecords_values = values %{$listRecords[$n]};
			#print geneClusterReport "$listRecords_values[1]\t$listRecords_values[2]\n";
			print geneClusterReport "$listRecords_values[2]\t$listRecords_values[1]\n";
		}
		
	}
	close geneClusterReport; 
	print "$p/$bname.geneClusterReport.txt generated\n";
    print "#$bname succeed\n";
}
