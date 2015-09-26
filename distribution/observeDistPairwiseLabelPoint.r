args <- commandArgs(TRUE)
prefix = args[5]

dat1 = read.table(file=args[1], header=F)
dat1Label = read.table(file=args[2], header=F)

dat2 = read.table(file=args[3], header=F)
dat2Label = read.table(file=args[4], header=F)

svg(paste(prefix,".label.ranked.svg",sep=""))
par(mar=c(5,4,4,5)+.1)

# plot one
plot(dat1[,3], dat1[,2], pch=20, col="red", cex = 0.5, cex.lab=1.5, lwd=2, cex.axis = 1.5, xlim=c(-10, 2000))
text(dat1Label[,3], dat1Label[,2], dat1Label[,1], cex=1, pos=4, col="red")

# plot two
par(new=TRUE)
plot(dat2[,3], dat2[,2], pch=20, col="blue", cex = 0.5, cex.lab=1.5, lwd = 2, cex.axis = 1.5, xaxt="n",yaxt="n")
text(dat2Label[,3], dat2Label[,2], dat2Label[,1], cex=1, pos=4, col="blue")
axis(4, cex.lab=1.5, cex.axis = 1.5)
mtext("Informatics score", side=4, line=3, cex.lab=10)

dev.off()
