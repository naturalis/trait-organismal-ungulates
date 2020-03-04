library(ape)
library(ggtree)

root <- "/home/zoe/Documents/Naturalis/R-Studio/trait-organismal-ungulates"
treeFile <- paste(c(root, "/data/ungulates.tree"), collapse = "")
ungulatesFile <- paste(c(root, "/data/CSV/ungulatesTraits.csv"), collapse = "")

phyloTree <- read.tree(treeFile)
ggtree(phyloTree, layout = "circular") 
# + geom_tiplab() adds labels, but doesn't work (yet) 

ungulatesData <- read.csv(ungulatesFile, header = TRUE, sep= ",")


