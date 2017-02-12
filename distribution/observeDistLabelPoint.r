args <- commandArgs(TRUE)
prefix = args[3]

dat = read.table(file=args[1], header=F)

top10 = read.table(file=args[2], header=F)

pdf(paste(prefix,".label.ranked.pdf",sep=""))
plot(dat[,3], dat[,2], pch=20, col="red", cex = 1, cex.lab=1.5, lwd=2, cex.axis = 1.5)
text(top10[,3], top10[,2], top10[,1], cex=1, pos=2, col="black")
dev.off()
