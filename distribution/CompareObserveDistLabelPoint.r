args <- commandArgs(TRUE)
prefix = args[5]

dat = read.table(file=args[1], header=F)

top10 = read.table(file=args[2], header=F)

dat2 = read.table(file=args[3], header=F)

top10_2 = read.table(file=args[4], header=F)

pdf(paste(prefix,".label.ranked.pdf",sep=""))
plot(dat[,3], dat[,2], pch=20, col="red", cex = 1, cex.lab=1.5, lwd=2, cex.axis = 1.5, xlim=c(0,2000), ylim=c(0,200))
text(top10[,3], top10[,2], top10[,1], cex=1, pos=2, col="red")
#par(new=T)
points(dat2[,3], dat2[,2], pch=20, col="black", lwd=2)
text(top10_2[,3], top10_2[,2], top10_2[,1], cex=1, pos=2, col="black")
#par(new=F)
dev.off()
