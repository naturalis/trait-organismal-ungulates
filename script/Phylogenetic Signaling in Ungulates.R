#Phylogenetic Signaling in Ungulates

install.packages("geiger")
install.packages("picante")
library(geiger)
library(picante)
library(ape)

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
tree <- multi2di(tree)
dataset <- res[2]$data
rm(ungulatesData, omi, res)

#Continuous variables

AdultForearmLength <- as.numeric(dataset$X8.1_AdultForearmLen_mm)
names(AdultForearmLength) <- row.names(dataset)
AdultForearmLength <- AdultForearmLength[!is.na(AdultForearmLength)]
tmptree <- keep.tip(tree, names(AdultForearmLength))
fitContinuous(tree, AdultForearmLength, model = "lambda")

Adultheadbodylength <- as.numeric(dataset$X13.1_AdultHeadBodyLen_mm)
names(Adultheadbodylength) <- row.names(dataset)
Adultheadbodylength <- Adultheadbodylength[!is.na(Adultheadbodylength)]
tmptree <- keep.tip(tree, names(Adultheadbodylength))
fitContinuous(tree, Adultheadbodylength, model = "lambda")

Ageateyeopening <- as.numeric(dataset$X2.1_AgeatEyeOpening_d)
names(Ageateyeopening) <- row.names(dataset)
Ageateyeopening <- Ageateyeopening[!is.na(Ageateyeopening)]
tmptree <- keep.tip(tree, names(Ageateyeopening))
fitContinuous(tree, Ageateyeopening, model = "lambda")


mass <- as.numeric(dataset$X5.1_AdultBodyMass_g)
names(mass) <- row.names(dataset)
mass <- mass[!is.na(mass)]
tmptree <- keep.tip(tree, names(mass))
fitContinuous(tree, mass, model = "lambda")

bio1 <- as.numeric(dataset$bio1)
names(bio1) <- row.names(dataset)
bio1 <- bio1[!is.na(bio1)]
tmptree <- keep.tip(tree, names(bio1))
fitContinuous(tree, bio1 , model = "lambda")

Aspect <- as.numeric(dataset$Aspect)
names(Aspect) <- row.names(dataset)
Aspect <- Aspect[!is.na(Aspect)]
tmptree <- keep.tip(tree, names(Aspect))
fitContinuous(tree, Aspect , model = "lambda")

#Categorical Variables

Domestication <- as.integer(dataset$Domestication)
names(Domestication) <- row.names(dataset)
Domestication <- Domestication[!is.na(Domestication)]
tmptree <- keep.tip(tree, names(Domestication))
fitDiscrete(tree, Domestication, model = "meristic", transform = "lambda")


ActivityCycle <- as.integer(dataset$X1.1_ActivityCycle)
names(ActivityCycle) <- row.names(dataset)
ActivityCycle <- ActivityCycle[!is.na(ActivityCycle)]
tmptree <- keep.tip(tree, names(ActivityCycle))
fitDiscrete(tree, ActivityCycle, model = "ARD", transform = "lambda")

TeatNumber <- as.integer(dataset$X24.1_TeatNumber)
names(TeatNumber) <- row.names(dataset)
TeatNumber <- TeatNumber[!is.na(TeatNumber)]
tmptree <- keep.tip(tree, names(TeatNumber))
fitDiscrete(tmptree, TeatNumber, model = "meristic", transform = "lambda")


fitDiscrete(tree, dataset,
            model = c("ER","SYM","ARD","meristic"),
            transform = c("none", "EB", "lambda", "kappa", "delta", "white"),
            bounds = list(), control = list(method = c("subplex", "L-BFGS-B"),
                                            niter = 100, FAIL = 1e+200, hessian = FALSE, CI = 0.95), ncores=NULL, model = all-rates-different)



