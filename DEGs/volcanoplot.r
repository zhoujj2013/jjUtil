args <- commandArgs(TRUE)
diff = args[1]
prefix = args[2]

differ<-read.table(diff,header=T)

#library(calibrate)


pdf(file=paste(prefix,".pdf",sep=""))
par(mar=c(6, 6, 5, 5))

# id log2(Foldchage) q_value
x<- differ[,2]
y<- -log10(differ[,3])

num_max = max(c(x,y))
plot(x,y, xlim=c(-4, 4), ylim=c(0, 5), xlab="log2(fold change)", ylab="-log10(p-value)", col="black",cex=0.5,cex.axis=2,cex.lab=2)

deg=subset(differ, differ[,4] <= 0.05)
names = deg[,1]

x <- deg[,2]
y <- -log10(deg[,3])

points(x,y,col="red",cex=0.5)
#abline(0, 1, col="red")
#text(x, y, names, cex=0.6, pos=4, col="red")

dev.off()

