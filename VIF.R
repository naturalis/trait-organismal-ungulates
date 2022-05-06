## BEGIN VALUES
# Take only the numeric predictors and remove the dependent variable
startPredictors <- dplyr::select_if(dataset, is.numeric)
startPredictors$Domestication <- NULL

# The first correlation matrix is a visualization of the dataset without the removal of any 
# traits. There is a lot of collinearity present.
matrix <- cor(startPredictors, use = "pairwise.complete.obs")
corrplot(matrix, type="lower", order = "hclust", tl.pos = "l", tl.col = "black", tl.cex = 0.4)


## CHECK CORRELATION MATRIX
# The corrplot package is used to visualize the collinearity between the traits,
# using the correlation matrix. With the findCorrelation() function, the columns
# with the highest collinearity are found. By visualizing the matrix, the
# outcome of the findCorrelation function can be easily checked. The VIF function can be run
# to easily check if the results are still infinite. A cutoff value of .83 is chosen, 
# using trial and error.
matrix <- cor(startPredictors, use = "pairwise.complete.obs")
delColumn <- findCorrelation(matrix, cutoff = .83, verbose = FALSE, exact=FALSE)
startPredictors <- startPredictors[,-c(delColumn)]

vif(startPredictors)

## INSERT ADULTBODYMASS
# The set of predictors is declared for the VIF analysis, and a last check for
# collinearity using the visualized matrix is done. During the first round the
# AdultBodyMass was removed due to a high collinearity with other traits. However, 
# because Adultbodymass is hypothesized to be a biologically relevant trait, 
# it will be reinserted in this step.
vifPredictors <- cbind(dataset$X5.1_AdultBodyMass_g, startPredictors)
colnames(vifPredictors)[1] <- "X5.1_AdultBodyMass_g"

# Check VIF -> Adultbodymass is highly correlated with the other traits.
vif(vifPredictors)

# CarryWeight has a high collinearity with AdultBodyMass (both inf). Since AdultBodyMass
#  is hypothesized to be biologically relevant, CarryWeight will be removed.
vifPredictors$CarryWeight <- NULL
vif(vifPredictors)

# Check correlation matrix
# A visualization of the dataset after the cutoff value is implemented and 
# AdultBodyMass is added.
matrix <- cor(vifPredictors, use = "pairwise.complete.obs")
corrplot(matrix, type="lower", order = "hclust", tl.pos = "l", tl.col = "black", tl.cex = 0.7)


## VIF ANALYSIS
# Check VIF -> PETWarmestQuarter has highest VIF value above 10
# Remove PETWarmestQuarter
vif(vifPredictors)
vifPredictors$PETWarmestQuarter <- NULL

# Check VIF -> bio3 has highest VIF value above 10
# Remove bio3
vif(vifPredictors)
vifPredictors$bio3 <- NULL

# Check VIF -> bio2 has highest VIF value above 10
# Remove bio2
vif(vifPredictors)
vifPredictors$bio2 <- NULL

# Check VIF -> bio14 has highest VIF value above 10
# Remove bio14
vif(vifPredictors)
vifPredictors$bio14 <- NULL

# Check VIF -> PETDriestQuarter has highest VIF value above 10
vif(vifPredictors)
vifPredictors$PETDriestQuarter <- NULL

# Check VIF -> AVGFoodConsumption has highest VIF value above 10
vif(vifPredictors)
vifPredictors$AVGFoodConsumption <- NULL

# Check VIF -> X13.1_AdultHeadBodyLen_mm has highest VIF value above 10
vif(vifPredictors)
vifPredictors$X13.1_AdultHeadBodyLen_mm <- NULL

# Check VIF -> All VIF values under 10 (except AdultBodyMass, which is 11)
vif(vifPredictors)


## FINAL PREDICTOR SET
# Final set of numeric predictors, containing:  X5.1_AdultBodyMass_g, X9.1_GestationLen_d,
# X15.1_LitterSize, X17.1_MaxLongevity_m, X21.1_PopulationDensity_n_km2, 
# X23.1_SexualMaturityAge_d, X10.2_SocialGrpSize, X25.1_WeaningAge_d, Lifespan,
# AVGMovingSpeed, AVGTravelDistance, Aspect, BulkDensity, ClayPercentage, minTempWarmest,
# PETseasonality, PETWettestQuarter, OrganicCarbon, PhCaCL, Slope, bio15, bio18, bio19
vifPredictors

## FINAL VALUES
# The final correlation matrix is the final product after removing all highly correlated
# traits. 
matrix <- cor(vifPredictors, use = "pairwise.complete.obs")
corrplot(matrix, type="lower", order = "hclust", tl.pos = "l", tl.col = "black", tl.cex = 0.7)

## REMOVE VARIABLES
rm(startPredictors, matrix, delColumn)
