args <- commandArgs(TRUE)

# input max genes number 8000
prefix = args[1]
colnum = args[2]
namestr = args[3]
expr = args[4]

colarr = unlist(strsplit(colnum,"[,]"))
names = unlist(strsplit(namestr,"[,]"))

# import library
library("pheatmap")

d1 <- read.table(file=expr, header=F)

dat = data.frame()
for (i in 1:length(colarr)) {
	print(i)
	if (i == 1){
		dat = d1[,strtoi(colarr[i])]
	} else
		dat = cbind(dat, d1[,strtoi(colarr[i])])
}
m1 = as.matrix(dat)

#m1<- as.matrix( d1[,2:ncol(d1)])
rownames(m1) = d1$V1
colnames(m1) = names

print(names)

#20140129.day4.B1-4      20140129.day4.C2-9 ES.B1-4.Mst-KO  ES.C2-9.ES
# 6,7,8,9
# 8,9,6,7
summary(m1[,1])
#m1<- log10(m1)
#summary(m1[,1])

min(m1)
max(m1)
#bk = unique(c(seq(-1.8, -0.6, length=100), seq(-0.6,0.6,length=100), seq(0.6,1.8, length=100)))
#bk = unique(c(seq(-2.4, -1, length=100), seq(-1,0.4,length=100), seq(0.4,1.8, length=100)))

#bk = unique(c(seq(-2.2, -0.5, length=100), seq(-0.5,1.2,length=100), seq(1.2,2.7, length=100)))

#bk = unique(seq(min(m1),max(m1)), length=200)
#hmcols<- colorRampPalette(c("green","yellow","red"))(length(bk-1))

pdf(paste(prefix,".heatmap.pdf",sep=""))
#pheatmap( m1, cluster_rows = F, cluster_cols = F, col= hmcols, breaks = bk, legend=T, show_rownames=TRUE, fontsize = 12, border_color="black", show_colnames=TRUE, cellwidth = 30, cellheight = 16, )

# plan 1
#hmcols = colorRampPalette(c("navy", "white", "firebrick3"))(100)
hmcols = colorRampPalette(c("blue", "white", "red"))(100)
pheatmap( m1, cluster_rows = T, cluster_cols = T, col= hmcols, legend=T, show_rownames=TRUE, fontsize = 12, border_color="black", show_colnames=TRUE)

# plan 2 non clustering

dev.off()
