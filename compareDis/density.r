args <- commandArgs(TRUE)
prefix = args[1]

#print(args[c(2:length(args))])

pdf(paste(prefix,".density.pdf",sep=""))
color = rainbow(length(args) - 1)

for (i in 2:length(args)){
	dat = read.table(args[i],header=F)
	if (i == 2) {
		plot(density(dat[,1]), col=color[i-1], cex.axis=1.5, cex.lab=1.5, lwd=1.5)
	} else {
		lines(density(dat[,1]), col=color[i-1], lwd=1.5)
	}
}

legend("topright", legend=args[c(2:length(args))], fill=color,cex=1.2)

dev.off()

#dat = read.table(degree,header=F)

#dat = subset(dat, dat$V1 > 0)

#pdf(paste(prefix,".powerlaw.pdf",sep=""))
#plot(dat$V1,dat$V2, xlim=c(1,2000), pch=20, col="red", cex.axis=1.5, xlab="Degree", ylab="Node count", cex.lab=1.5)
#lines(dat$V1,dat$V2,lwd=1.5 ,col="red")
#dev.off()
