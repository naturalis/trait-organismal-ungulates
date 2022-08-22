#Phylogenetic Signaling in Ungulates

install.packages("geiger")
install.packages("picante")
library(geiger)
library(picante)

ungulatesData <- read.csv("https://raw.githubusercontent.com/naturalis/trait-organismal-ungulates/master/data/CSV/ungulatesTraits(updated)%20-%20ungulatesTraits(updated).csv")

omi <- read.csv("https://raw.githubusercontent.com/naturalis/trait-geo-diverse-ungulates/master/results/OMI/niche_traits.csv")

# join on canonical name
names(omi)[names(omi)=="X"] <- "CanonicalName"
dataset <- merge(ungulatesData, omi, by="CanonicalName")

# substitute spaces with underscores and use as row names to match the tree
row.names(dataset) <- gsub(" ", "_", dataset$CanonicalName)

# read tree, correct donkey name
tree <- read.tree("https://raw.githubusercontent.com/naturalis/trait-organismal-ungulates/master/data/phylogeny/ungulates.tree")
tree$tip.label[tree$tip.label=="Equus_asinus"] <- "Equus_africanus"

# match tree and data
res <- match.phylo.data(tree, dataset)
tree <- res[1]$phy
dataset <- res[2]$data

rm(ungulatesData, omi, res)


fitContinuous(tree, dataset, SE = 0,
              model = c("BM","OU","EB","rate_trend","lambda","kappa","delta","mean_trend","white"),
              bounds= list(), control = list(method = c("subplex","L-BFGS-B"),
                                             niter = 100, FAIL = 1e+200, hessian = FALSE, CI = 0.95), ncores=NULL, model  = meristic)
fitDiscrete(tree, dataset,
            model = c("ER","SYM","ARD","meristic"),
            transform = c("none", "EB", "lambda", "kappa", "delta", "white"),
            bounds = list(), control = list(method = c("subplex", "L-BFGS-B"),
                                            niter = 100, FAIL = 1e+200, hessian = FALSE, CI = 0.95), ncores=NULL, model = meristic)



