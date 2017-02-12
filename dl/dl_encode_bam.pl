#!/usr/bin/perl -w

my $files = shift;

`head -1 $files > header.txt`;

`xargs -n 1 curl -O -L < header.txt`;

`head -1 metadata.tsv > bam.meta.lst`;

`awk '\$3 ~ /alignments/' metadata.tsv | egrep -v "(GRCh38|mm10)">> bam.meta.lst`;

`grep -v "File accession" bam.meta.lst | cut -f 1 | while read line; do grep "\$line" files.txt; done > bam.url.lst`;

`less bam.url.lst | while read line; do echo "curl -O -L \$line > \$(basename \$line ".bam").log 2>\$(basename \$line ".bam").err";done > bam.url.sh;`;

