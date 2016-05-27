#!/usr/bin/perl -w

use FindBin qw($Bin);
use File::Path qw(make_path);
use Cwd qw(abs_path);

&usage if @ARGV<1;

sub usage {
        my $usage = << "USAGE";

        Description of this script. 5/21/2016
        Author: zhoujj2013\@gmail.com
        Usage: $0 xxx.cfg

USAGE
print "$usage";
exit(1);
};

my $all = "all : ";
my $mk = "";
my $combine_expr = "\tpython $Bin/combine_cuff_expr.py ";

my $conf=shift;
my %conf;
&load_conf($conf, \%conf);

$conf{GENCODE} = abs_path($conf{GENCODE});
$conf{TSVLIST} = abs_path($conf{TSVLIST});

#use Data::Dumper;
#print  Dumper(\%conf);

$mk .= "get_id_name_index.finished : $conf{GENCODE}\n";
$mk .= "\tperl $Bin/get_id_name_index.pl $conf{GENCODE} > ./geneid_name.index && touch get_id_name_index.finished\n";
$all .= "get_id_name_index.finished ";

my %sid;
open IN,"$conf{TSVLIST}" || die $!;
while(<IN>){
	chomp;
	next if(/^#/);
	my @t = split /\t/;
	my $lst_f = abs_path($t[1]);
	my $id = "";
	#my $id = $t[0];
	$sid{$t[0]}++;
	$id = "$t[0]_r$sid{$t[0]}";
	
	$mk .= "$id.fpkm.finished: geneid_name.index\n";
	$mk .="\tperl /home/zhoujj/bin/joinTable.pl geneid_name.index $lst_f | awk '\$\$3 != \"\"' | cut -f 2,3,9 > $id.fpkm && touch $id.fpkm.finished\n";
	$all .= "$id.fpkm.finished ";
	$combine_expr .= "$id.fpkm:$id ";
}
close IN;

make_path $conf{OUTDIR};
open OUT, ">$conf{OUTDIR}/makefile";
print OUT $mk, "\n";
print OUT $all, "\n";
print OUT "$combine_expr > combine.expr && touch combine.expr.finished\n";
close OUT;

sub load_conf
{
    my $conf_file=shift;
    my $conf_hash=shift; #hash ref
    open CONF, $conf_file || die "$!";
    while(<CONF>)
    {
        chomp;
        next unless $_ =~ /\S+/;
        next if $_ =~ /^#/;
        warn "$_\n";
        my @F = split"\t", $_;  #key->value
        $conf_hash->{$F[0]} = $F[1];
    }
    close CONF;
}

