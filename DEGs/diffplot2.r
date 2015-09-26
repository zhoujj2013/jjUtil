args <- commandArgs(TRUE)
degF = args[1]
nondegF = args[2]
prefix = args[3]

yes<-read.table(degF,header=T)
no<-read.table(nondegF,header=T)

#library(calibrate)

names = yes[,1]

pdf(file=paste(prefix,".pdf",sep=""))
par(mar=c(6, 6, 5, 5))

# id sample1_expr sample2_expr
x<-log2( (no[,2] +1 ))
y<-log2( (no[,3] +1 ))

num_max = max(c(x,y))

plot(x,y,xlab="L1 (log2(FPKM+1))",ylab="L2 (log2(FPKM+1))", xlim=c(0,15), ylim=c(0,15), col="black",cex=0.5,cex.axis=2,cex.lab=2)

x<-log2( (yes[,2] +1 ))
y<-log2( (yes[,3] +1 ))
points(x,y,col="red",cex=0.5)

abline(0, 1, col="red")

text(x, y, names, cex=0.6, pos=4, col="red")

dev.off()

