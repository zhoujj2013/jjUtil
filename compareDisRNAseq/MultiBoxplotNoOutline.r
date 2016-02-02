args <- commandArgs(TRUE)
prefix = args[1]
boxwidth = as.numeric(args[2])
# http://www.cyclismo.org/tutorial/R/index.html
# input data format. per file, per feature
# 1.20
# 2.3
# 5.5
# ...

#print(args[c(2:length(args))])

#pdf(paste(prefix,".boxplot.pdf",sep=""))
svg(paste(prefix,".boxplot.svg",sep=""))
par(mar=c(7,7,7,7))
#color = rainbow(length(args) - 1)

d = data.frame()
lcolor = c()
llabels = c()

for (i in 3:length(args)){
	arg_element = unlist(strsplit(args[i],"[:]"))
	
	file = arg_element[1]
	llabels = append(llabels, file)
	
	column = strtoi(arg_element[2])
	color = arg_element[3]
	lcolor = append(lcolor, color)
	
	dat = read.table(file=file, header=F)
	class = apply(matrix(dat[,column]), 1, function(x) i-2)
	dat2 = cbind(dat[,column],class)
	colnames(dat2) = c("value","class")
	d = rbind(d,dat2)
	#if (i == 2) {
	#	
	#	plot(density(dat[,1]), col=color[i-1], cex.axis=1.5, cex.lab=1.5, lwd=1.5)
	#} else {
	#	lines(density(dat[,1]), col=color[i-1], lwd=1.5)
	#}
}

#print(d)

#str(d)

#boxplot(value~class, data=d)

boxplot(value~class, data= d, xaxt = "n",  xlab = "", col = lcolor, boxwex=boxwidth, cex.axis=1.5, cex.lab=1.5, lwd=1.5, outline=F)

#boxplot(value~class, data= d, xaxt = "n",  xlab = "", col = lcolor, cex.axis=1.5, cex.lab=1.5, lwd=1.5, outline=F)

################
axis(1, labels = FALSE)
labels = apply(matrix(seq(1,length(llabels))), 1, function(x) llabels[x])
################

#print(length(llabels))
#print(labels)


################
text(x =  seq_along(labels), y = par("usr")[3] - 20, srt = 45, adj = 1, labels = labels, xpd = TRUE, cex=1.5)
################


#legend("topright", legend=args[c(2:length(args))], fill=color,cex=1.2)
dev.off()

# ref: http://www.r-bloggers.com/box-plot-with-r-tutorial/

#boxplot(count ~ spray, data = InsectSprays,
#        col = "lightgray", xaxt = "n",  xlab = "")
#
## x axis with ticks but without labels
#axis(1, labels = FALSE)
#
## Plot x labs at default x position
#text(x =  seq_along(labels), y = par("usr")[3] - 1, srt = 45, adj = 1,
#     labels = labels, xpd = TRUE)


#dat = read.table(degree,header=F)

#dat = subset(dat, dat$V1 > 0)

#pdf(paste(prefix,".powerlaw.pdf",sep=""))
#plot(dat$V1,dat$V2, xlim=c(1,2000), pch=20, col="red", cex.axis=1.5, xlab="Degree", ylab="Node count", cex.lab=1.5)
#lines(dat$V1,dat$V2,lwd=1.5 ,col="red")
#dev.off()
