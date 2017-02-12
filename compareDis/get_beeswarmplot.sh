id=$1
perl /x400ifs-accel/zhoujj/github/jjUtil/compareDis/row2column4gene.pl sk.20_29.txt 2 3 $id > $id.young.txt
perl /x400ifs-accel/zhoujj/github/jjUtil/compareDis/row2column4gene.pl sk.60_69.txt 2 3 $id > $id.old.txt
echo $id.young.txt $id.old.txt
Rscript /x400ifs-accel/zhoujj/github/jjUtil/compareDis/beeswarm.r  $id 0.5 4 6 $id.young.txt:1:white $id.old.txt:1:darkgray
Rscript /x400ifs-accel/zhoujj/github/jjUtil/compareDis/ttest.r $id.young.txt:1 $id.old.txt:1 > $id.ttest
