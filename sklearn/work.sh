perl -ne 'BEGIN{$i = 1;} chomp; my @t = split /\t/; my $index = "c".$i; unshift(@t,$index); next if($t[-1] > 1);print join "\t",@t; print "\n"; $i++;' LgR.txt > LgRBit.txt
perl -ne 'BEGIN{$i = 1;} chomp; my @t = split /\t/; my $index = "c".$i; unshift(@t,$index); print join "\t",@t; print "\n"; $i++;' LgR.txt > LgRTri.txt
