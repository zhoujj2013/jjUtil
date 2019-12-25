args <- commandArgs(TRUE)

if (length(args) < 2) {
	stop("Please input enough args: Rscript xx.r xxx.vs.xxx.FC xx.vs.xx.FC")
}

# library
library("clusterProfiler")
library("org.Hs.eg.db")

fc = args[1]
prefix = args[2]


# read in gmt files
dir = "/home/zhoujj/github/jjUtil/annoTK/"

#c1.all.v7.0.entrez.gmt
#c2.all.v7.0.entrez.gmt
#c3.all.v7.0.entrez.gmt
#c4.all.v7.0.entrez.gmt
#c5.all.v7.0.entrez.gmt
#c6.all.v7.0.entrez.gmt
#c7.all.v7.0.entrez.gmt
#h.all.v7.0.entrez.gmt

h <- read.gmt(paste(dir,"h.all.v7.0.entrez.gmt",sep="/"))
c1 <- read.gmt(paste(dir,"c1.all.v7.0.entrez.gmt",sep="/"))
c2 <- read.gmt(paste(dir,"c2.all.v7.0.entrez.gmt",sep="/"))
c3 <- read.gmt(paste(dir,"c3.all.v7.0.entrez.gmt",sep="/"))
c4 <- read.gmt(paste(dir,"c4.all.v7.0.entrez.gmt",sep="/"))
c5 <- read.gmt(paste(dir,"c5.all.v7.0.entrez.gmt",sep="/"))
c6 <- read.gmt(paste(dir,"c6.all.v7.0.entrez.gmt",sep="/"))
c7 <- read.gmt(paste(dir,"c7.all.v7.0.entrez.gmt",sep="/"))


# read fc file
dat = read.table(file=fc, row.names=1, header=T)
gene = mapIds(org.Hs.eg.db, rownames(dat), 'ENTREZID', 'SYMBOL')


gene.df = data.frame(gene)
dat.df = data.frame(dat)
gene.df$id = rownames(gene.df)
dat.df$id = rownames(dat.df)

gene.rnk = merge(gene.df, dat.df, by.x="id", by.y="id")
#head(merge(gene.df, dat.df, by.x="id", by.y="id"))

write.table(gene.rnk, file=paste(prefix, "all.sym2entrezid.lst", sep = "."), sep = "\t", quote = F, col.names = FALSE)

gene.rnk = gene.rnk[order(gene.rnk[,5], decreasing = T),]
#head(gene.rnk)

geneList = gene.rnk[,5]
names(geneList) = gene.rnk$gene


# perform analysis
h.gsea <- GSEA(geneList, TERM2GENE=h, verbose=FALSE)
write.table(h.gsea,file = paste(prefix, "h.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c1.gsea <- GSEA(geneList, TERM2GENE=c1, verbose=FALSE)
write.table(c1.gsea,file = paste(prefix, "c1.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c2.gsea <- GSEA(geneList, TERM2GENE=c2, verbose=FALSE)
write.table(c2.gsea,file = paste(prefix, "c2.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c3.gsea <- GSEA(geneList, TERM2GENE=c3, verbose=FALSE)
write.table(c3.gsea,file = paste(prefix, "c3.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c4.gsea <- GSEA(geneList, TERM2GENE=c4, verbose=FALSE)
write.table(c4.gsea,file = paste(prefix, "c4.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c5.gsea <- GSEA(geneList, TERM2GENE=c5, verbose=FALSE)
write.table(c5.gsea,file = paste(prefix, "c5.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c6.gsea <- GSEA(geneList, TERM2GENE=c6, verbose=FALSE)
write.table(c6.gsea,file = paste(prefix, "c6.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

c7.gsea <- GSEA(geneList, TERM2GENE=c7, verbose=FALSE)
write.table(c7.gsea,file = paste(prefix, "c7.gsea.result.raw.txt", sep = "."), sep = "\t", quote = F)

#
#kegg_gsea = gseKEGG(geneList     = geneList)
#egmt2 <- GSEA(geneList, TERM2GENE=c5, verbose=FALSE)
#head(egmt2)
#
#df = read.table(file=degs, row.names=1, header=T)
#deg_geneid = mapIds(org.Hs.eg.db, rownames(df), 'ENTREZID', 'SYMBOL')
#
#go = enrichGO(gene=data.frame(deg_geneid)$deg_geneid, OrgDb = "org.Hs.eg.db", keyType= "ENTREZID", ont = "ALL", pvalueCutoff = 0.05, pAdjustMethod = "BH")
#
#kegg = enrichKEGG(gene=data.frame(deg_geneid)$deg_geneid, organism = "hsa", keyType= "kegg", pvalueCutoff = 0.05, pAdjustMethod = "BH")
#
#write.table(go,file = paste(prefix, "go.enrichment.result.raw.txt", sep = "."), sep = "\t", quote = F)
#write.table(kegg,file = paste(prefix, "kegg.enrichment.result.raw.txt", sep = "."), sep = "\t", quote = F)
#write.table(deg_geneid, file=paste(prefix, "degs.sym2entrezid.lst", sep = "."), sep = "\t", quote = F, col.names = FALSE)
#
