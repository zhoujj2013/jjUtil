args <- commandArgs(TRUE)
gseid = args[1]

library(GEOquery)

gse = getGEO(gseid, GSEMatrix=TRUE)

result = pData(phenoData(gse[[1]]))

write.table(result, file="./gse.tmp.txt", sep="\t", quote=F)

#cat(pData(phenoData(gse[[1]])))
