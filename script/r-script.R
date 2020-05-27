### 1 Import data

## Packages
library(ape)
library(ggtree)
library(ggplot2)
library(Rphylopars)
library(tidyverse)
library(usdm)

## The project root and paths
#declare root and paths to data
root <- "/home/zoe/Documents/GitHub/trait-organismal-ungulates-R"
treeFile <- paste(c(root, "/data/ungulates.tree"), collapse = "")
ungulatesFile <- paste(c(root, "/data/CSV/ungulatesTraits.csv"), collapse = "")

## Import tree and domestication data
#read datafiles into R
ungulatesData <- read.csv(ungulatesFile, header = TRUE, sep= ",")
tree <- read.tree(treeFile)


### 2 Preprocessing
#drop tips that aren't in dataset
tips_drop <- setdiff(tree$tip.label, ungulatesData$BinomialName)
phyloTree <- drop.tip(tree, tips_drop)

#check if there are still name differences between the tree and dataset
setdiff(phyloTree$tip.label, ungulatesData$BinomialName)
setdiff(ungulatesData$BinomialName, phyloTree$tip.label)

#rename columns with dots in the name
ungulatesData <- ungulatesData %>% rename(Horns_Antlers = Horns.Antlers,
                                          X21.1_PopulationDensity_n_km2 = X21.1_PopulationDensity_n.km2)

summary(ungulatesData)
#remove traits that (almost) only consist of missing values (>200 NA)
ungulatesData <- subset(ungulatesData, select = -c(X8.1_AdultForearmLen_mm, X18.1_BasalMetRate_mLO2hr, 
                                                   X5.2_BasalMetRateMass_g, X7.1_DispersalAge_d,
                                                   X16.1_LittersPerYear, X13.2_NeonateHeadBodyLen_mm,
                                                   X10.1_PopulationGrpSize, X13.3_WeaningHeadBodyLen_mm,
                                                   X5.4_WeaningBodyMass_g, X2.1_AgeatEyeOpening_d))

#remove traits without any information gain (only consist of one value)
ungulatesData <- subset(ungulatesData, select = -c(Motility, ParentalCare, X12.2_Terrestriality))
X6.2_TrophicLevel


X24.1_TeatNumber
X12.1_HabitatBreadth
X1.1_ActivityCycle

#convert Order values to binary form
ungulatesData$Order = factor(ungulatesData$Order, levels=c("Artiodactyla", "Perissodactyla"), labels = c(1,2))
summary(ungulatesData)


### 3 Distance Matrix
#not sure what to do with this yet
distances <- cophenetic.phylo(phyloTree)


### 4 VIF-analysis
## Highest VIF value
## NOG MEE BEZIG
vif(ungulatesData[3:49])


# Information about data per predictor variable
summary(ungulatesData)
str(ungulatesData)
ungulatesData$BinomialName

# Testdata
theme_set(theme_bw(base_size=18))
testdata <- read.csv(ungulatesFile, header = TRUE, sep = ",", nrows = 10)
qplot(testdata$Domestication, testdata$X1.1_ActivityCycle, facets = . ~ testdata$BinomialName, colour = BinomialName, geom = "boxplot", data = testdata)
