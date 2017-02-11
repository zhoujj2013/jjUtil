awk '$2==0 && $3==1 && $4==0 && $5==0 && $6==0' $1 > B.5set.venn.stat
awk '$2==1 && $3==1 && $4==0 && $5==0 && $6==0' $1 > AB.5set.venn.stat
awk '$2==0 && $3==1 && $4==1 && $5==0 && $6==0' $1 > BC.5set.venn.stat
awk '$2==0 && $3==1 && $4==0 && $5==1 && $6==0' $1 > BD.5set.venn.stat
awk '$2==0 && $3==1 && $4==0 && $5==0 && $6==1' $1 > BE.5set.venn.stat
awk '$2==1 && $3==1 && $4==1 && $5==0 && $6==0' $1 > ABC.5set.venn.stat
awk '$2==1 && $3==1 && $4==0 && $5==1 && $6==0' $1 > ABD.5set.venn.stat
awk '$2==1 && $3==1 && $4==0 && $5==0 && $6==1' $1 > ABE.5set.venn.stat
awk '$2==0 && $3==1 && $4==1 && $5==1 && $6==0' $1 > BCD.5set.venn.stat
awk '$2==0 && $3==1 && $4==0 && $5==1 && $6==1' $1 > BDE.5set.venn.stat
awk '$2==1 && $3==1 && $4==1 && $5==1 && $6==1' $1 > ABCDE.5set.venn.stat
awk '$2==1 && $3==1 && $4==1 && $5==0 && $6==1' $1 > ABCE.5set.venn.stat
awk '$2==1 && $3==1 && $4==0 && $5==1 && $6==1' $1 > ABDE.5set.venn.stat
awk '$2==0 && $3==1 && $4==1 && $5==1 && $6==1' $1 > BCDE.5set.venn.stat
awk '$2==1 && $3==0 && $4==0 && $5==0 && $6==0' $1 > A.5set.venn.stat
awk '$2==1 && $3==0 && $4==1 && $5==0 && $6==0' $1 > AC.5set.venn.stat
awk '$2==1 && $3==0 && $4==0 && $5==1 && $6==0' $1 > AD.5set.venn.stat
awk '$2==1 && $3==0 && $4==0 && $5==0 && $6==1' $1 > AE.5set.venn.stat
awk '$2==1 && $3==0 && $4==1 && $5==1 && $6==0' $1 > ACD.5set.venn.stat
awk '$2==1 && $3==0 && $4==1 && $5==0 && $6==1' $1 > ACE.5set.venn.stat
awk '$2==1 && $3==0 && $4==0 && $5==1 && $6==1' $1 > ADE.5set.venn.stat
awk '$2==1 && $3==0 && $4==1 && $5==1 && $6==1' $1 > ACDE.5set.venn.stat
awk '$2==0 && $3==0 && $4==1 && $5==0 && $6==0' $1 > C.5set.venn.stat
awk '$2==0 && $3==0 && $4==1 && $5==1 && $6==0' $1 > CD.5set.venn.stat
awk '$2==0 && $3==0 && $4==1 && $5==0 && $6==1' $1 > CE.5set.venn.stat
awk '$2==0 && $3==0 && $4==1 && $5==1 && $6==1' $1 > CDE.5set.venn.stat
awk '$2==0 && $3==0 && $4==0 && $5==1 && $6==0' $1 > D.5set.venn.stat
awk '$2==0 && $3==0 && $4==0 && $5==0 && $6==1' $1 > E.5set.venn.stat
awk '$2==0 && $3==0 && $4==0 && $5==1 && $6==1' $1 > DE.5set.venn.stat
wc -l B.5set.venn.stat
wc -l AB.5set.venn.stat
wc -l BC.5set.venn.stat
wc -l BD.5set.venn.stat
wc -l BE.5set.venn.stat
wc -l ABC.5set.venn.stat
wc -l ABD.5set.venn.stat
wc -l ABE.5set.venn.stat
wc -l BCD.5set.venn.stat
wc -l BDE.5set.venn.stat
wc -l ABCDE.5set.venn.stat
wc -l ABCE.5set.venn.stat
wc -l ABDE.5set.venn.stat
wc -l BCDE.5set.venn.stat
wc -l A.5set.venn.stat
wc -l AC.5set.venn.stat
wc -l AD.5set.venn.stat
wc -l AE.5set.venn.stat
wc -l ACD.5set.venn.stat
wc -l ACE.5set.venn.stat
wc -l ADE.5set.venn.stat
wc -l ACDE.5set.venn.stat
wc -l C.5set.venn.stat
wc -l CD.5set.venn.stat
wc -l CE.5set.venn.stat
wc -l CDE.5set.venn.stat
wc -l D.5set.venn.stat
wc -l E.5set.venn.stat
wc -l DE.5set.venn.stat

