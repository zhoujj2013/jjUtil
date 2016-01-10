args <- commandArgs(TRUE)
expr = args[1]
prefix = args[2]
cutsk = as.numeric(args[3])
clusterNum = as.numeric(args[4])

mat = read.table(expr, header=F)
row.names(mat) = mat$V1
mat = mat[,2:5]
colnames(mat) = c("ESC","MES","CP","CM")
dat_matrix = data.matrix(mat)

#[1] -6.643856
#[1] 8.834114


summary(dat_matrix[,1])
min(dat_matrix)
max(dat_matrix)

#my_palette <- colorRampPalette(c("red", "yellow", "green"))(n = 299)
#col_breaks = c(seq(-9,-3,length=100), # for red
#seq(-3,3,length=100), # for yellow
#seq(3,9,length=100)) # for green


library("gplots")

# seperate clusters
hc.rows <- hclust(dist(dat_matrix))
plot(hc.rows)

# transpose the matrix and cluster columns
hc.cols <- hclust(dist(t(dat_matrix)))


pdf(paste(prefix,".1.pdf", sep=""))
heatmap.2(dat_matrix[cutree(hc.rows,k=cutsk)==clusterNum,],trace="none",hclustfun = hclust,dendrogram="row", col=greenred(50), margins = c(8, 8), keysize = 1.5, symkey=FALSE, density.info="none", Rowv=T,Colv=F, scale="row")
dev.off()

pdf(paste(prefix,".2.pdf", sep=""))
heatmap.2(dat_matrix[cutree(hc.rows,k=cutsk)==clusterNum,],trace="none",hclustfun = hclust,dendrogram="row", col=greenred(50), margins = c(8, 8), keysize = 1.5, symkey=FALSE, density.info="none", Rowv=T,Colv=F)
dev.off()
