args <- commandArgs(TRUE)
degF = args[1]
nondegF = args[2]
prefix = args[3]

yes<-read.table(degF,header=T)
no<-read.table(nondegF,header=T)

png(file=paste(prefix,".png",sep=""))
par(mar=c(6, 6, 5, 5))

# id sample1_expr sample2_expr
x<-log2( (no[,2] +1 ))
y<-log2( (no[,3] +1 ))
plot(x,y,xlab="L1 (log2(FPKM+1))",ylab="L2 (log2(FPKM+1))",col="black",cex=0.1,cex.axis=2.5,cex.lab=2.5)

x<-log2( (yes[,2] +1 ))
y<-log2( (yes[,3] +1 ))
points(x,y,col="red",cex=0.1)

dev.off()

