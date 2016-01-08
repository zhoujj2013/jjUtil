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

        Description of this script.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <matrix.dat> <accession>

USAGE
print "$usage";
exit(1);
};
#!/bin/env perl
 
use strict;
use warnings;
 
my $usage = "Usage: $0 <matrix.dat> <accession>\n";
my $infile = shift or die $usage;
my $wanted = shift or die $usage;
 
my $accession = '';
my $start = 0;
my $entry = [];
my $switch = 0;
my @nuc = ('a', 'c', 'g', 't');
 
print <<EOF;
library(seqLogo)
proportion <- function(x){
   rs <- sum(x);
   return(x / rs);
}
EOF
 
open(IN, '<', $infile) || die "Could not open $infile: $!\n";
while(<IN>){
   chomp;
   #AC  M00001
   if (/^AC\s+(.*)$/){
      $accession = $1;
   }
   #NA  MyoD
   if (/^NA\s+(.*)$/){
      $accession .= "_$1";
      if ($accession =~ /$wanted/i){
         $switch = 1;
      }
   }
   #P0      A      C      G      T
   if (/^P0/){
      $start = 1;
      $entry->[0] = "$accession";
      next;
   #XX
   } elsif (/^XX/ && $start == 1){
      $start = 0;
      if ($switch == 1){
         #four nucleotides
         print "#$entry->[0]\n";
         for (my $i=0; $i<4; ++$i){
            my $nuc = "$nuc[$i] <- c(";
            for (my $j=1; $j<scalar(@{$entry}); ++$j){
               $nuc .= "$entry->[$j]->[$i],";
            }
            $nuc =~ s/\,$/)/;
            print "$nuc\n";
         }
print <<EOF;
df <- data.frame(a,c,g,t)
pwm <- apply(df, 1, proportion)
pwm <- makePWM(pwm)
seqLogo(pwm)
EOF
  
      }
      $entry = [];
      $switch = 0;
   }
   #P0      A      C      G      T
   #01      1      2      2      0      S
   #02      2      1      2      0      R
   #03      3      0      1      1      A
   #04      0      5      0      0      C
   #05      5      0      0      0      A
   #06      0      0      4      1      G
   #07      0      1      4      0      G
   #08      0      0      0      5      T
   #09      0      0      5      0      G
   #10      0      1      2      2      K
   #11      0      2      0      3      Y
   #12      1      0      3      1      G
   #XX
   if ($start == 1){
      my @nuc = split(/\s+/);
      #remove last column
      pop(@nuc);
      #remove first column
      shift(@nuc);
      my $line = scalar(@{$entry});
      for (my $i=0; $i< scalar(@nuc); ++$i){
         $entry->[$line]->[$i] = $nuc[$i];
      }
   }
}
close(IN);
 
exit(0);
