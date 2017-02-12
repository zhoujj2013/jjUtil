args <- commandArgs(TRUE)
pid = args[1]
spe = args[2]
fc = args[3]

require("pathview")

dat = read.table(file=fc, header=T, row.names="id")
mat = as.matrix(dat)

pv.out2 <- pathview(gene.data = mat[, 1], pathway.id = pid, species = spe, out.suffix = "origin", kegg.native = T)
pv.out2 <- pathview(gene.data = mat[, 1], pathway.id = pid, species = spe, out.suffix = "network", kegg.native = F, same.layer=F)
