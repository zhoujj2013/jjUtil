args <- commandArgs(TRUE)
gsmid = args[1]

library(GEOquery)

gsm = getGEO(gsmid)

srx = unlist(strsplit(Meta(gsm)$relation[1], "[ ]"))[2]

cat(gsmid,"\t",srx[1],"\n")

