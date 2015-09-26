#!/usr/bin/perl -w

use strict;
use Cwd 'abs_path';

&usage if @ARGV<2;

#open IN,"" ||die "Can't open the file:$\n";
#open OUT,"" ||die "Can't open the file:$\n";

sub usage {
        my $usage = << "USAGE";

        Qsub jobs to SGE. The shell should use abs_path.
        Author: zhoujj2013\@gmail.com
        Usage: $0 <mem, 1G> <node list file | none | compute-0-2,compute-0-4> work1.sh work2.sh ...

USAGE
print "$usage";
exit(1);
};

my $mem = shift;
my $node_f = shift;

my @node;

if($node_f =~ /,/){
	@node = split /,/;
}elsif(-e "$node_f"){
	my $node_lst = abs_path($node_f);
	open IN,"$node_lst" || die $!;
	while(<IN>){
		chomp;
		push @node,$_;
	}
	close IN;
}

# submit my jobs
my %job;
my $i = 0;
foreach my $sh (@ARGV){
	my $ab_sh = abs_path($sh);
	#print $ab_sh,"\n";
	#qsub -cwd -l vf=3G -v PATH $line
	my $qsub_msg;
	if($node_f eq "none"){
		$qsub_msg = `qsub -cwd -l vf=$mem -v PATH $ab_sh`;
	}else{
		$qsub_msg = `qsub -cwd -l vf=$mem -v PATH -l h=$node[$i] $ab_sh`;
	}
	# Your job 19501 ("aa.sh") has been submitted
	my ($job_id, $shell_file) = ($1,$2) if( $qsub_msg =~ /Your job (\d+) \("([^"]+)"\) has been submitted/g);
	$job{$job_id} = $shell_file;
	$i++;
	$i = 0 if(scalar(@node) > 0 && $i >= scalar(@node));
}

# monitor my jobs
my $user = `whoami`;
chomp($user);

while(1){
	my $qstat_msg = `qstat -u $user`;
	my @qstat_msg = split /\n/,$qstat_msg;
	shift @qstat_msg;
	shift @qstat_msg;
	my %running_jobs;
	foreach my $l (@qstat_msg){
		my @t = split /\s+/,$l;
		#print join "#",@t;
		#print "\n";
		my $id = $t[1];
		my $stat = $t[5];
		$running_jobs{$id} = $stat;
	}

	my $running = 0;
	foreach my $k (keys %job){
		if(exists $running_jobs{$k}){
			$running = 1;
		}else{
			print STDOUT "$k\t$job{$k}\tdone\n";
		}
	}
	last if($running == 0);
	sleep(1);
}
