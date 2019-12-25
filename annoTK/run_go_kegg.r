args <- commandArgs(TRUE)

if (length(args) < 2) {
	stop("Please input enough args: Rscript xx.r degs.lst xx.vsxx.up")
}

# library
library("clusterProfiler")
library("org.Hs.eg.db")

degs = args[1]
prefix = args[2]

df = read.table(file=degs, row.names=1, header=T)
deg_geneid = mapIds(org.Hs.eg.db, rownames(df), 'ENTREZID', 'SYMBOL')

go = enrichGO(gene=data.frame(deg_geneid)$deg_geneid, OrgDb = "org.Hs.eg.db", keyType= "ENTREZID", ont = "ALL", pvalueCutoff = 0.05, pAdjustMethod = "BH")

kegg = enrichKEGG(gene=data.frame(deg_geneid)$deg_geneid, organism = "hsa", keyType= "kegg", pvalueCutoff = 0.05, pAdjustMethod = "BH")

write.table(go,file = paste(prefix, "go.enrichment.result.raw.txt", sep = "."), sep = "\t", quote = F)
write.table(kegg,file = paste(prefix, "kegg.enrichment.result.raw.txt", sep = "."), sep = "\t", quote = F)
write.table(deg_geneid, file=paste(prefix, "degs.sym2entrezid.lst", sep = "."), sep = "\t", quote = F, col.names = FALSE)

