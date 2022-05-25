## PROCESS DATASET
# A dataset without missing values is made. The X12.1_HabitatBreadth and
# X6.1_DietBreadth are removed, due to there being not enough data for the
# domesticated species. It contains the Domestication trait, and also the
# CanonicalNames to match the data with the tree. The tree tips that aren't in
# the final data are dropped.
predictors$X6.1_DietBreadth <- NULL
predictors$X12.1_HabitatBreadth <- NULL

modelData <- cbind(dataset$CanonicalName, dataset$Domestication,predictors)
names(modelData)[names(modelData)=="dataset$Domestication"] <- "Domestication"
names(modelData)[names(modelData)=="dataset$CanonicalName"] <- "CanonicalName"

# Only the rows without any missing values are selected
modelData <- modelData[complete.cases(modelData),]

# Dropping species from the tree
dropTips <- setdiff(tree$tip.label, modelData$CanonicalName)
modelTree <- drop.tip(tree, dropTips)


modelData$CanonicalName <- NULL

test <- modelData
test$X1.1_ActivityCycle <- droplevels(test$X1.1_ActivityCycle)
test$X1.1_ActivityCycle <- NULL

## FORMULAS
# The input formula is defined, which is going to be used as input for the
# phyloglmstep function.
formula <- Domestication ~ X5.1_AdultBodyMass_g + X9.1_GestationLen_d + X15.1_LitterSize + 
  X17.1_MaxLongevity_m + X21.1_PopulationDensity_n_km2 + X23.1_SexualMaturityAge_d + 
  X10.2_SocialGrpSize + X25.1_WeaningAge_d + Lifespan + AVGMovingSpeed + AVGTravelDistance + 
  Aspect + BulkDensity + ClayPercentage + minTempWarmest + PETseasonality + PETWettestQuarter + 
  OrganicCarbon + PhCaCL + Slope + bio15 + bio18 + bio19 + X1.1_ActivityCycle + 
  X6.2_TrophicLevel + Sociality + SocialHierarchy + NumMales + MatingSystem + YearRoundBreeding +
  DevelopmentStrategy + HeadOrnaments + NaturalPredators

formula <- Domestication ~ X5.1_AdultBodyMass_g + X9.1_GestationLen_d + X15.1_LitterSize + 
  X17.1_MaxLongevity_m + X21.1_PopulationDensity_n_km2 + X23.1_SexualMaturityAge_d + 
  X10.2_SocialGrpSize + X25.1_WeaningAge_d + Lifespan + AVGMovingSpeed + AVGTravelDistance + 
  Aspect + BulkDensity + ClayPercentage + minTempWarmest + PETseasonality + PETWettestQuarter + 
  OrganicCarbon + PhCaCL + Slope + bio15 + bio18 + bio19 + 
  X6.2_TrophicLevel + Sociality + SocialHierarchy + NumMales + MatingSystem + YearRoundBreeding +
  DevelopmentStrategy + HeadOrnaments + NaturalPredators
  

## MODEL SELECTION

#Using the phyloglmstep
phyloglmstep(formula, starting.formula = NULL, data=test, phy=modelTree, 
             method= "logistic_IG10", direction = "forward", trace = 2, 
             btol = 20, log.alpha.bound = 4, start.beta=NULL, 
             start.alpha=NULL, boot = 0, full.matrix = TRUE, k=2)

## FINAL MODEL
# The final formula for the model constructed by the phyloglmstep function
finalFormula <- Domestication ~ X5.1_AdultBodyMass_g + DevelopmentStrategy + 
  HeadOrnaments + AVGMovingSpeed + AVGTravelDistance


rm(dropTips, formula, modelData, modelTree)


