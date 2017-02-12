#wget ftp://ftp.ncbi.nlm.nih.gov/genomes/Mus_musculus/GFF/ref_GRCm38.p4_top_level.gff3.gz
#less -S ref_GRCm38.p4_top_level.gff3.gz | awk '$3 ~ "gene"' | perl -ne 'chomp; my $id = $1 if(/=GeneID:(\d+)/); my $name = $1 if(/Name=([^;]+);/); print "$id\t$name\n";' > gene2symbol.lst
#python get_symbol_for_species.py mmu gene2symbol.lst >kegg_gene_symbol.lst 2>err
#python get_kegg_db_for_species.py mmu
#cut -f 1 mmu.pathway.info | while read line; do echo "python get_kegg2genes.py $line kegg_gene_symbol.lst";done > get_genename.sh;
#sh get_genename.sh
#ll | grep "\.tmp$" | awk '$5==0' | awk '{print $9}' | perl -ne 'chomp; my @t = split /\./; print "$t[1]\n";' | while read line; do echo "python get_kegg2genes.py $line kegg_gene_symbol.lst";done ;
#perl get_results.pl mmu.pathway.info > mmu.kegg2gene 2>mmu.gene2kegg
perl bin/get_results.pl mmu
