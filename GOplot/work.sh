awk '{print $1"\t-1"}' eRNA.down.associated.gene.lst > eRNA.down.associated.gene.FC
awk '{print $1"\t1"}' eRNA.up.associated.gene.lst > eRNA.up.associated.gene.FC
cat eRNA.down.associated.gene.FC eRNA.up.associated.gene.FC > associated.gene.lst
sh /x400ifs-accel/zhoujj/github/jjUtil/DavidAnno/anno.sh associated.gene.lst mmusculus associated.gene
perl goplot.pl associated.gene.david/associated.gene.david/associated.gene.input.tableReport.final.txt associated.gene.lst 0.01


