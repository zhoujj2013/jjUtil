args <- commandArgs(TRUE)
expr = args[1]
fc_str = args[2]
type = args[3]

fc = strtoi(fc_str)
print(fc)

dat = read.table(expr, header=T, row.names=1)

print(cor(dat[,1],dat[,2]))
cor.test(dat[,1], dat[,2],alternative = c("two.sided"), method = c("pearson"))
head(dat)
# input format
# geneid expr1 expr2 log2(FoldChange)
degs = subset(dat, abs(dat[,3]) > fc)
nondegs = subset(dat, abs(dat[,3]) <= fc)
head(nondegs)
#summary(log10(dat[,1]+1))
#summary(log10(dat[,2]+1))

tmp = rbind(log10(dat[,1]+1),log10(dat[,2]+1))
emax = max(tmp)

x2 = log10(degs[,1]+1)
y2 = log10(degs[,2]+1)

x1 = log10(nondegs[,1]+1)
y1 = log10(nondegs[,2]+1)



pdf(file="scatterplot.pdf")
par(mar=c(6, 6, 5, 5))
plot(x1,y1,xlab=paste(colnames(dat)[1]," log10(",type,")",sep=""), ylab=paste(colnames(dat)[2]," log10(",type,")",sep=""), col="black", cex=1,cex.axis=2,cex.lab=2, xlim=c(0,max(tmp)+0.5), ylim=c(0,max(tmp)+0.5))
points(x2,y2,pch=6,col="red")
abline(0, 1, col="red", lty=2)
dev.off()
