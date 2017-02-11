cut -f 1-3,5 geneDensity.bedmap.bed | sed 's/\t/ /g' | sed 's/chr/hs/g' > geneDensity.circos
/ifs-accel/jiangpeiyong/software/soft_pkg/circos-0.52/bin/circos -conf test.conf
cut -f 1-3,5 72y.vs.27y.bed  | sed 's/\t/ /g' | sed 's/chr/hs/g' > 72y.vs.27y.circos
cut -f 1-4 35y.vs.27y.bed  | sed 's/\t/ /g' | sed 's/chr/hs/g' > 35y.vs.27y.circos
