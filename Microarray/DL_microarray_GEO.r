args <- commandArgs(TRUE)
gseid = args[1]
out=args[2]

library(GEOquery)

gse = getGEO(gseid, GSEMatrix =F ,destdir=".")

arr=c(gseid,Meta(gse)$platform_id,Meta(gse)$sample_taxid,Meta(gse)$pubmed_id,Meta(gse)$title)
arr=t(arr)
write.table(arr, file = out, append = T, quote = F, sep = "\t",
                 eol = "\n", na = "NA", dec = ".", row.names = F,
                 col.names = F, qmethod = c("escape", "double"),
                 fileEncoding = "")

gse = getGEO(gseid,destdir=".")
