args <- commandArgs(TRUE)

upF = args[1]
downF = args[2]
nondegF = args[3]
prefix = args[4]

up<-read.table(upF,header=T)
down<-read.table(downF,header=T)
no<-read.table(nondegF,header=T)

#library(calibrate)

#names = c(up[,1],down[,1])

pdf(file=paste(prefix,".pdf",sep=""))
par(mar=c(6, 6, 5, 5))

# id sample1_expr sample2_expr
x<-log2( (no[,2] +1 ))
y<-log2( (no[,3] +1 ))

num_max = max(c(x,y))

plot(x,y,xlab="L1 (log2(FPKM+1))",ylab="L2 (log2(FPKM+1))", xlim=c(0,15), ylim=c(0,15), col="black",cex=0.5,cex.axis=2,cex.lab=2)

x<-log2( (up[,2] +1 ))
y<-log2( (up[,3] +1 ))
points(x,y,col="red",cex=0.5)

x<-log2( (down[,2] +1 ))
y<-log2( (down[,3] +1 ))
points(x,y,col="blue",cex=0.5)

abline(0, 1, col="red")

#text(x, y, names, cex=0.6, pos=4, col="red")

dev.off()
