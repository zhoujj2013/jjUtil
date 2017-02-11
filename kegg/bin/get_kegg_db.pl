#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use File::Path qw(make_path);
use Data::Dumper;
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        This script create makefile for LncFunNet analysis.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 config.cfg

USAGE
print "$usage";
exit(1);
};

my $spe = shift;

if($spe eq "mmu"){
	if(-e "./ref_GRCm38.p4_top_level.gff3.gz"){
		`rm ./ref_GRCm38.p4_top_level.gff3.gz`;
	}
	`wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Mus_musculus/GFF/ref_GRCm38.p4_top_level.gff3.gz`;
}elsif($spe eq "hsa"){
	
}

`less -S ref_GRCm38.p4_top_level.gff3.gz | awk '\$3 ~ "gene"' | perl -ne 'chomp; my \$id = \$1 if(/=GeneID:(\\d+)/); my \$name = \$1 if(/Name=([^;]+);/); print "\$id\\t\$name\\n";' > gene2symbol.lst`;

`python $Bin/get_symbol_for_species.py $spe gene2symbol.lst >kegg_gene_symbol.lst 2>err`;

`python $Bin/get_kegg_db_for_species.py $spe > log 2>err`;

`cut -f 1 mmu.pathway.info | while read line; do echo "python $Bin/get_kegg2genes.py \$line kegg_gene_symbol.lst";done > get_genename.sh;`;

`sh get_genename.sh`;

while(1){
	`ls -l | grep "\.tmp\$" | awk '\$5==0' | awk '{print \$9}' | perl -ne 'chomp; my \@t = split /\\./; print "\$t[1]\\n";' | while read line; do echo "python $Bin/get_kegg2genes.py \$line kegg_gene_symbol.lst";done > get_genename.sh;`;
	my $line_num = `wc -l get_genename.sh | awk '{print \$1}'`;
	chomp($line_num);
	if($line_num == 0){
		last;
	}else{
		`sh get_genename.sh`;
	}
}

`perl $Bin/get_results.pl $spe.pathway.info > $spe.kegg2gene 2>$spe.gene2kegg`;

`rm kegg2gene.*.tmp`;


