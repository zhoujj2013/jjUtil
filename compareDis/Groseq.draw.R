args <- commandArgs(TRUE)

if (length(args) < 2) {
	stop("Please input enough args")
}

dat = args[1]
prefix = args[2]

dat = read.table(dat, skip=1, header=F)

pdf(paste(prefix,".line.pdf",sep=""))
plot(dat$V1, dat$V4, lty=1, col="darkgreen", type="l", cex.axis=2, lwd=3, xlab="", ylab="")
lines(dat$V1, dat$V3, lty=1, col="red", type="l", cex.axis=2, lwd=3)
dev.off()
