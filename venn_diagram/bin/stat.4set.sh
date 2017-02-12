awk '$2==1 && $3==0 && $4==0 && $5==0 ' $1 > A.4set.venn.stat
awk '$2==0 && $3==1 && $4==0 && $5==0 ' $1 > B.4set.venn.stat
awk '$2==0 && $3==0 && $4==1 && $5==0 ' $1 > C.4set.venn.stat
awk '$2==0 && $3==0 && $4==0 && $5==1 ' $1 > D.4set.venn.stat

awk '$2==1 && $3==1 && $4==0 && $5==0 ' $1 > AB.4set.venn.stat
awk '$2==1 && $3==0 && $4==1 && $5==0 ' $1 > AC.4set.venn.stat
awk '$2==1 && $3==0 && $4==0 && $5==1 ' $1 > AD.4set.venn.stat

awk '$2==1 && $3==1 && $4==1 && $5==0 ' $1 > ABC.4set.venn.stat
awk '$2==1 && $3==1 && $4==0 && $5==1 ' $1 > ABD.4set.venn.stat
awk '$2==1 && $3==0 && $4==1 && $5==1 ' $1 > ACD.4set.venn.stat
awk '$2==0 && $3==1 && $4==1 && $5==1 ' $1 > BCD.4set.venn.stat

awk '$2==0 && $3==1 && $4==1 && $5==0 ' $1 > BC.4set.venn.stat
awk '$2==0 && $3==1 && $4==0 && $5==1 ' $1 > BD.4set.venn.stat
awk '$2==0 && $3==0 && $4==1 && $5==1 ' $1 > CD.4set.venn.stat

awk '$2==1 && $3==1 && $4==1 && $5==1 ' $1 > ABCD.4set.venn.stat
wc -l A.4set.venn.stat
wc -l B.4set.venn.stat
wc -l C.4set.venn.stat
wc -l D.4set.venn.stat
wc -l AB.4set.venn.stat
wc -l AC.4set.venn.stat
wc -l AD.4set.venn.stat
wc -l ABC.4set.venn.stat
wc -l ABD.4set.venn.stat
wc -l ACD.4set.venn.stat
wc -l BCD.4set.venn.stat
wc -l BC.4set.venn.stat
wc -l BD.4set.venn.stat
wc -l CD.4set.venn.stat
wc -l ABCD.4set.venn.stat

