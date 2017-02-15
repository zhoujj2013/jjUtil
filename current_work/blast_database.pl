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

        This script create makefile for blast databases.
        Author: zhoujj2013\@gmail.com 
        Usage: $0 config.cfg

USAGE
print "$usage";
exit(1);
};

my $conf=shift;
my %conf;
&load_conf($conf, \%conf);
my $all = "all: ";
my $mk = "";

# parameters
my $out = abs_path($conf{out});
my $query = abs_path($conf{query});
my $cut = $conf{cut};
my $prefix = $conf{prefix};

# db
my $nr = abs_path($conf{Nr}) if(defined $conf{Nr} and $conf{Nr} ne "none");
my $nt = abs_path($conf{Nr}) if(defined $conf{Nt} and $conf{Nt} ne "none");
my $swissprot = abs_path($conf{Swissprot}) if(defined $conf{Swissprot} and $conf{Swissprot} ne "none");
my $trembl = abs_path($conf{TrEMBL}) if(defined $conf{TrEMBL} and $conf{TrEMBL} ne "none");

# program
my $blastall = abs_path($conf{blastall});
my $formatdb = abs_path($conf{formatdb});
my $program = $conf{program};

# paras for blast
my $evalue = abs_path($conf{evalue});

# prepare for blast
my @subfiles;

mkdir($out) unless(-d $out);

chdir $out;
`ln -s $query ./$prefix.fa`;
`perl $Bin/fastaDeal.pl -cutf $cut ./$prefix -outdir $out`;
@subfiles = glob("$out/$prefix.cut/*.*");

###format the user defined database, judge the type automatically.
if (defined $conf{UserDB}) {
		my $Userdb = $conf{UserDB};
		my $seq_type = judge_type($Userdb);
		`$formatdb -p F -o T -i $Userdb` if ($seq_type eq "DNA");
		`$formatdb -p T -o T -i $Userdb` if ($seq_type eq "Protein");
}

foreach my $subfile (@subfiles){
	
}


#### write you things ###
make_path abs_path($conf{OUTDIR});
open OUT, ">$out/makefile";
print OUT $all, "\n";
print OUT $mk, "\n";
close OUT;
$all = "all: ";
$mk = "";

#########################

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
