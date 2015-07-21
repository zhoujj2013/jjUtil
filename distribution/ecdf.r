args <- commandArgs(TRUE)
prefix = args[2]

dat = read.table(file=args[1], header=F)

top10 = tail(dat, n=10)

#pdf(paste(prefix,".ranked.pdf",sep=""))
#plot(dat[,3], dat[,2], pch=20, col="red", cex = 1, cex.lab=1.5, lwd=2, cex.axis = 1.5)
#text(top10[,3], top10[,2], top10[,1], cex=1, pos=2, col="black")
#dev.off()
#
#pdf(paste(prefix,".hist.pdf", sep=""))
#hist(dat[,2], col="red", cex.lab=1.5, cex.axis = 1.5)
#dev.off()
#
#pdf(paste(prefix,".density.pdf", sep=""))
#plot(density(dat[,2]), col="red", cex.lab=1.5, cex.axis = 1.5, lwd=1.5)
#dev.off()

pdf(paste(prefix,".cdf.pdf", sep=""))
plot(ecdf(dat[,2]), col="red", cex.lab=1.5, cex.axis = 1.5, lwd=1.5)
dev.off()

