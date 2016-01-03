args <- commandArgs(TRUE)
gsmid = args[1]

library(GEOquery)

gsm = getGEO(gsmid)

cat(gsmid,"\t",Meta(gsm)$title,"\t",Meta(gsm)$biomaterial_provider_ch1,"\t",Meta(gsm)$characteristics_ch1,"\t",Meta(gsm)$description,"\t",Meta(gsm)$library_strategy,"\t",Meta(gsm)$series_id,"\t",Meta(gsm)$status,"\t",Meta(gsm)$treatment_protocol_ch1,"\t",Meta(gsm)$type,"\t",Meta(gsm)$series_id,"\n")

