### 1 Import data

## Packages
library(ape)
library(ggtree)
library(ggplot2)
library(Rphylopars)

## The project root and paths
#declare root and paths to data
root <- "/home/zoe/Documents/Naturalis/R-Studio/trait-organismal-ungulates"
treeFile <- paste(c(root, "/data/ungulates.tree"), collapse = "")
ungulatesFile <- paste(c(root, "/data/CSV/ungulatesTraits.csv"), collapse = "")

## Import tree and domestication data
#read datafiles into R
ungulatesData <- read.csv(ungulatesFile, header = TRUE, sep= ",")
phyloTree <- read.tree(treeFile)
ggtree(phyloTree, layout = "circular") 
# + geom_tiplab() adds labels, but doesn't work properly (yet) 

### 2 Preprocessing
## STILL TESTING
#impute missing values, using phylogenetic tree
testset <- phylopars(ungulatesData, phyloTree)

#remove columns that aren't of value for the analysis
dataset <- subset(ungulatesData, select=-c(ID_EoL, Family, Genus, Species))
summary(dataset)

#remove columns that (almost) only consist of missing values (>200 NA)
## STILL TESTING
X2.1_AgeatEyeOpening_d
X8.1_AdultForearmLen_mm
X18.1_BasalMetRate_mLO2hr
X5.2_BasalMetRateMass_g
X7.1_DispersalAge_d
X16.1_LittersPerYear
X13.2_NeonateHeadBodyLen_mm
X10.1_PopulationGrpSize
X13.3_WeaningHeadBodyLen_mm
X5.4_WeaningBodyMass_g

#convert Order values to binary form
dataset$Order = factor(dataset$Order, levels=c("Artiodactyla", "Perissodactyla"), labels = c(1,2))
summary(dataset)



# Information about data per predictor variable
summary(ungulatesData)
str(ungulatesData)
ungulatesData$BinomialName

# Testdata
theme_set(theme_bw(base_size=18))
testdata <- read.csv(ungulatesFile, header = TRUE, sep = ",", nrows = 10)
qplot(testdata$Domestication, testdata$X1.1_ActivityCycle, facets = . ~ testdata$BinomialName, colour = BinomialName, geom = "boxplot", data = testdata)
