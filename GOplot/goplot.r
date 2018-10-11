library("GOplot")
gene = read.table(file="./goplot.gene.lst",sep="\t",header=T)
david = read.table(file="./goplot.david.result.tab",sep="\t",header=T, quote = "")

circ = circle_dat(david, gene)
reduced_circ <- reduce_overlap(circ, overlap = 0.75)

svg(filename="Multiple.Bubble.svg", width=10, height=15)
GOBubble(reduced_circ, title = 'Bubble plot with background colour', display = 'multiple', bg.col = T, labels = 3, ID="F")
dev.off()

svg(filename="Single.Bubble.svg", width=10, height=10)
GOBubble(reduced_circ, labels = 2, ID="F", table.legend="F")
dev.off()
