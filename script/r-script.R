# Load packages
library(ape)
library(ggtree)
library(ggplot2)


# Declare root and paths to data
root <- "/home/zoe/Documents/Naturalis/R-Studio/trait-organismal-ungulates"
treeFile <- paste(c(root, "/data/ungulates.tree"), collapse = "")
ungulatesFile <- paste(c(root, "/data/CSV/ungulatesTraits.csv"), collapse = "")


# Read datafiles into R
phyloTree <- read.tree(treeFile)
ggtree(phyloTree, layout = "circular") 
# + geom_tiplab() adds labels, but doesn't work properly (yet) 

ungulatesData <- read.csv(ungulatesFile, header = TRUE, sep= ",")


# Information about data per predictor variable
summary(ungulatesData)
str(ungulatesData)
ungulatesData$BinomialName

# Testdata
theme_set(theme_bw(base_size=18))
testdata <- read.csv(ungulatesFile, header = TRUE, sep = ",", nrows = 10)
qplot(testdata$Domestication, testdata$X1.1_ActivityCycle, facets = . ~ testdata$BinomialName, colour = BinomialName, geom = "boxplot", data = testdata)
