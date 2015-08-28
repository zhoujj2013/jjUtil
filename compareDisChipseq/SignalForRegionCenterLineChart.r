args <- commandArgs(TRUE)

prefix = args[1]

# sample format: filename:column:color
#pdf(paste(prefix,".RegionCenter.density.pdf",sep=""))
svg(paste(prefix,".RegionCenter.density.svg",sep=""))
pp = c()
color = c()

for (i in 2:length(args)){
	arg_element = unlist(strsplit(args[i],"[:]"))
	file = arg_element[1]
	pp = append(pp, file)
	
	colnum = strtoi(arg_element[2])
	print(colnum)
	lcolor = arg_element[3]
	color = append(color, lcolor)
	
	dat = read.table(file,header=F)
	if (i == 2){
		plot(dat$V1, dat[,colnum], type="l", lwd=3, cex.lab=1.5, cex.axis=1.5, ylim=c(0,max(dat[,colnum]+0.5)), xlab="Distance from region center", ylab="Mean signal density", col=lcolor, bty="n")
		#plot(density(dat[,colnum]), col=lcolor, cex.axis=1.5, cex.lab=1.5, lwd=1.5)
	} else {
		lines(dat$V1, dat[,colnum], type="l", lwd=3, col=lcolor)
		#lines(density(dat[,colnum]), col=lcolor, lwd=1.5)
	}
}

legend("topright", legend=pp, fill=color,cex=1.2, bty="n")
dev.off()

# color = rainbow(8)
# color[3] = "black"

#dat = read.table(file=homer, header=F)
#png(filename=paste(prefix,".png",sep=""))
#par(mar=c(7, 7, 7, 7))
#plot(dat$V1, dat[,colNum], type="l", lwd=2, cex.lab=1.5, cex.axis=1.5, xlab="Distance from peaks", ylab="Mean ChIP-seq density", col='red')
#box(lwd=2)
#dev.off()

# lines(s386, type="l", lwd=2, col = color[2])
# 
