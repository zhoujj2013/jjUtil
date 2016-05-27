args <- commandArgs(TRUE)
prefix = args[1]
blog = args[4]
blabel = args[5]

library(gplots)

arg_element1 = unlist(strsplit(args[2],"[:]"))
file1 = arg_element1[1]
column1 = strtoi(arg_element1[2])

arg_element2 = unlist(strsplit(args[3],"[:]"))
file2 = arg_element2[1]
column2 = strtoi(arg_element2[2])

xdat = read.table(file1,header=F)
ydat = read.table(file2,header=F)
if (blog == "log"){
	x = log10(xdat[,column1])
	y = log10(ydat[,column2])
} else {
	x = xdat[,column1]
	y = ydat[,column2]
}
names = xdat[,1]

svg(file=paste(prefix,".scatterplot.svg",sep=""))

plot(x,y,xlab="x",ylab="y",col="black",cex=1,cex.axis=2,cex.lab=2, xlim=c(0,5), ylim=c(0,5))
abline(0, 1, col="red", lty=2)

if (blabel == "y"){
	#textplot(x, y, names)
	text(x, y, names, cex=0.9, pos=4, col="red")
}

dev.off()

