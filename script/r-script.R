### 1 Import data

## Packages
library(ape)
library(ggtree)
library(ggplot2)
library(Rphylopars)
library(tidyverse)

## The project root and paths
#declare root and paths to data
root <- "/home/zoe/Documents/Naturalis/R-Studio/trait-organismal-ungulates"
treeFile <- paste(c(root, "/data/ungulates.tree"), collapse = "")
ungulatesFile <- paste(c(root, "/data/CSV/ungulatesTraits.csv"), collapse = "")

## Import tree and domestication data
#read datafiles into R
ungulatesData <- read.csv(ungulatesFile, header = TRUE, sep= ",")
tree <- read.tree(treeFile)
ggtree(tree, layout = "circular") 
# + geom_tiplab() adds labels, but doesn't work properly (yet) 


### 2 Preprocessing
#drop tips that aren't in dataset
tips_drop <- setdiff(tree$tip.label, ungulatesData$BinomialName)
phyloTree <- drop.tip(tree, tips_drop)

#check if there are still name differences between the tree and dataset
setdiff(phyloTree$tip.label, ungulatesData$BinomialName)
setdiff(ungulatesData$BinomialName, phyloTree$tip.label)



## STILL TESTING
#impute missing values, using phylogenetic tree
#testset <- phylopars(ungulatesData, phyloTree)



#rename columns with dots in the name
## WERKT NOG NIET
ungulatesData %>% rename(Horns_Antlers = Horns.Antlers,
                         X21.1_PopulationDensity_n_km2 = X21.1_PopulationDensity_n.km2)

summary(ungulatesData)
#remove columns that (almost) only consist of missing values (>200 NA)
dataset <- subset(ungulatesData, select = -c(X8.1_AdultForearmLen_mm, X18.1_BasalMetRate_mLO2hr, 
                                     X5.2_BasalMetRateMass_g, X7.1_DispersalAge_d,
                                     X16.1_LittersPerYear, X13.2_NeonateHeadBodyLen_mm,
                                     X10.1_PopulationGrpSize, X13.3_WeaningHeadBodyLen_mm,
                                     X5.4_WeaningBodyMass_g, X2.1_AgeatEyeOpening_d))

#convert Order values to binary form
dataset$Order = factor(dataset$Order, levels=c("Artiodactyla", "Perissodactyla"), labels = c(1,2))
summary(dataset)


### 3 VIF-analysis
## Highest VIF value
## NOG MEE BEZIG
vif(glm(Domestication ~ Order + X1.1_ActivityCycle + X5.1_AdultBodyMass_g + X13.1_AdultHeadBodyLen_mm
        + X3.1_AgeatFirstBirth_d + X6.1_DietBreadth + X9.1_GestationLen_d + 
          X12.1_HabitatBreadth + X22.1_HomeRange_km2 + X22.2_HomeRange_Indiv_km2 +
          X14.1_InterbirthInterval_d + X15.1_LitterSize + X17.1_MaxLongevity_m + 
          X5.3_NeonateBodyMass_g + X21.1_PopulationDensity_n.km2 + X23.1_SexualMaturityAge_d + 
          X10.2_SocialGrpSize + X24.1_TeatNumber + X12.2_Terrestriality + X6.2_TrophicLevel + 
          X25.1_WeaningAge_d + Diet + AVGFoodConsumption + Sociality + SocialHierarchy +
          NumMales + MaturityReachMale + MaturityReachFemale +MatingSystem + NumOffspring +
          BreedingInterval + YearRoundBreeding + AVGWeight + ParentalCare + DevelopmentStrategy +
          Horns.Antlers + , data=dataset))


# Information about data per predictor variable
summary(ungulatesData)
str(ungulatesData)
ungulatesData$BinomialName

# Testdata
theme_set(theme_bw(base_size=18))
testdata <- read.csv(ungulatesFile, header = TRUE, sep = ",", nrows = 10)
qplot(testdata$Domestication, testdata$X1.1_ActivityCycle, facets = . ~ testdata$BinomialName, colour = BinomialName, geom = "boxplot", data = testdata)
