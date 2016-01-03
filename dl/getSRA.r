args <- commandArgs(TRUE)
srxid = args[1]

library(SRAdb)

sqlfile <- '/x400ifs-accel/zhoujj/data/GEO/SRAmetadb.sqlite'

if(!file.exists('/x400ifs-accel/zhoujj/data/GEO/SRAmetadb.sqlite')) sqlfile <<- getSRAdbFile()

sra_con <- dbConnect(SQLite(),sqlfile)

rs = getSRAinfo ( c(srxid), sra_con, sraType = "sra" )

for( i in 1:length(rs[,1])){
	cat(rs$experiment[i],"\t",rs$study[i],"\t",rs$sample[i],"\t",rs$run[i],"\t",as.character(rs$date[i]),"\t",rs$ftp[i],"\n")
}

