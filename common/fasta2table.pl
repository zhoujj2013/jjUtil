my $fa  = shift;

my $r = Read_fasta($fa);
print "id\tpositive strand\tnegative strand\tlength(bp)\n";
foreach my $k ( keys %{$r}){
	print "$r->{$k}{'head'}\t$r->{$k}{'seq'}\t$r->{$k}{'revcomseq'}\t$r->{$k}{'len'}\n";
}

sub Read_fasta{
        my $file=shift;
        my $hash_p=shift;

        my $total_num;
        open(IN, $file) || die ("can not open $file\n");
        $/=">"; <IN>; $/="\n";
        while (<IN>) {
                chomp;
                my $head = $_;
                my $name = $1 if($head =~ /^(\S+)/);

                $/=">";
                my $seq = <IN>;
                chomp $seq;
                $seq=~s/\s//g;
                $/="\n";

                if (exists $hash_p->{$name}) {
                        warn "name $name is not uniq";
                }

                $hash_p->{$name}{'head'} =  $head;
                $hash_p->{$name}{'len'} = length($seq);
                $hash_p->{$name}{'seq'} = $seq;
				
				my $rev_complement_seq = reverse $seq;
				$rev_complement_seq =~ tr/AGCTagct/TCGAtcga/;

				$hash_p->{$name}{'revcomseq'} = $rev_complement_seq;
				
                $total_num++;
        }
        close(IN);

        return $hash_p;
} 
