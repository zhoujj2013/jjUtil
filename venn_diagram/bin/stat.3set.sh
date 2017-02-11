awk '$2==1 && $3==0 && $4==0 ' $1 > A.3set.venn.stat
awk '$2==0 && $3==1 && $4==0 ' $1 > B.3set.venn.stat
awk '$2==0 && $3==0 && $4==1 ' $1 > C.3set.venn.stat
awk '$2==1 && $3==1 && $4==0 ' $1 > AB.3set.venn.stat
awk '$2==1 && $3==0 && $4==1 ' $1 > AC.3set.venn.stat
awk '$2==0 && $3==1 && $4==1 ' $1 > BC.3set.venn.stat
awk '$2==1 && $3==1 && $4==1 ' $1 > ABC.3set.venn.stat
wc -l A.3set.venn.stat
wc -l B.3set.venn.stat
wc -l C.3set.venn.stat
wc -l AB.3set.venn.stat
wc -l AC.3set.venn.stat
wc -l BC.3set.venn.stat
wc -l ABC.3set.venn.stat
