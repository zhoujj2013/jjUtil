#!/usr/bin/perl -w

use strict;
use Getopt::Long;
use FindBin qw($Bin $Script);
use File::Basename qw(basename dirname);
use Data::Dumper;
#use lib "/home/zhoujj/my_lib/pm";
#use bioinfo;

&usage if @ARGV<1;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Create a PHP file transfer system.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <name> <pwd> <outdir>

USAGE
print "$usage";
exit(1);
};

my ($name, $pwd, $outdir) = @ARGV;

my $pwdmd5 = `sh $Bin/md5.sh $pwd`;
chomp($pwdmd5);

`mkdir -p $outdir/$pwdmd5` unless(-e "$outdir/$pwdmd5");

open OUT,">","$outdir/fbrowser.php" || die $!;
open IN,"$Bin/fbrowser.php" || die $!;
while(<IN>){
	my $line = $_;
	if(/^\$pwdPre/){
		$line =~ s/"([^"]+)"/"$pwdmd5"/g;
	}elsif(/^\$namePre/){
		$line =~ s/"([^"]+)"/"$name"/g;
	}
	print OUT "$line";
}
close IN;
close OUT;

`cp $Bin/login.html $outdir/index.html`;
`cp $Bin/login.html $outdir/login.html`;
