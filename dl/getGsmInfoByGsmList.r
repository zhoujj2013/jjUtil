args <- commandArgs(TRUE)
gsmid_f = args[1]
prefix = args[2]

library(GEOmetadb)

if(!file.exists('/x400ifs-accel/zhoujj/data/GEO/GEOmetadb.sqlite')) getSQLiteFile()

# can not get the latest version

con <- dbConnect(SQLite(),'/x400ifs-accel/zhoujj/data/GEO/GEOmetadb.sqlite')

dat = read.table(gsmid_f,header=F)

gsmid = dat$V1

for(i in 1:length(gsmid)){
	rs <- dbGetQuery(con,paste('select title,gsm,series_id,gpl,last_update_date,source_name_ch1,organism_ch1,molecule_ch1,characteristics_ch1,supplementary_file from gsm where gsm=="',paste(gsmid[i],'"',sep=""),sep=""))
	#rs <- dbGetQuery(con,paste('select * from gsm where gsm=="',paste(gsmid[i],'"',sep=""),sep=""))
	if(i == 1){
		write.table(rs, file=paste(prefix,'.gsm.info.txt',sep=''), col.names=T, append = FALSE, sep = "#", quote=F)
	}else{
		write.table(rs, file=paste(prefix,'.gsm.info.txt',sep=''), col.names=F, append = TRUE, sep = "#", quote=F)
	}
}

#rs <- dbGetQuery(con,'select * from gsm where gsm == "GSM1003058"')
#gsm = getGEO(gsmid)
#cat(gsmid,"\t",Meta(gsm)$title,"\t",Meta(gsm)$biomaterial_provider_ch1,"\t",Meta(gsm)$characteristics_ch1,"\t",Meta(gsm)$description,"\t",Meta(gsm)$library_strategy,"\t",Meta(gsm)$series_id,"\t",Meta(gsm)$status,"\t",Meta(gsm)$treatment_protocol_ch1,"\t",Meta(gsm)$type,"\t",Meta(gsm)$series_id,"\n")

