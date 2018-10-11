args <- commandArgs(TRUE)

a1 = unlist(strsplit(args[1],"[:]"))
a2 = unlist(strsplit(args[2],"[:]"))

dat1 = read.table(file=a1[1], header=F, sep="\t")
dat2 = read.table(file=a2[1], header=F, sep="\t")


#t.test(dat1[,strtoi(a1[2])],dat2[,strtoi(a2[2])],alternative = c("two.sided"))
#t.test(dat1[,strtoi(a1[2])],dat2[,strtoi(a2[2])],alternative = c("greater"))
t.test(dat1[,strtoi(a1[2])],dat2[,strtoi(a2[2])],alternative = c("two.sided"))
