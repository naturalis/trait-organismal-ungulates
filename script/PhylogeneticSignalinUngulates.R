#Phylogenetic Signaling in Ungulates


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

# re-code Head Ornaments to categories 1 and 2 instead of 0 and 1
dataset$HeadOrnaments[dataset$HeadOrnaments==0] <- 2

# re-code Diet and Teat number to make them categorical
dataset$Diet[dataset$Diet==1] <- 1
dataset$Diet[dataset$Diet==4] <- 2
dataset$Diet[dataset$Diet==6] <- 3
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==2] <- 1
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==3] <- 2
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==4] <- 3
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==6] <- 4
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==8] <- 5
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==11] <- 6
dataset$X24.1_TeatNumber[dataset$X24.1_TeatNumber==12] <- 7


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
#1
AdultForearmLength <- as.numeric(dataset$X8.1_AdultForearmLen_mm)
names(AdultForearmLength) <- row.names(dataset)
AdultForearmLength <- AdultForearmLength[!is.na(AdultForearmLength)]
tmptree <- keep.tip(tree, names(AdultForearmLength))
fitContinuous(tree, AdultForearmLength, model = "lambda")

#2
Adultheadbodylength <- as.numeric(dataset$X13.1_AdultHeadBodyLen_mm)
names(Adultheadbodylength) <- row.names(dataset)
Adultheadbodylength <- Adultheadbodylength[!is.na(Adultheadbodylength)]
tmptree <- keep.tip(tree, names(Adultheadbodylength))
fitContinuous(tree, Adultheadbodylength, model = "lambda")

#3
mass <- as.numeric(dataset$X5.1_AdultBodyMass_g)
names(mass) <- row.names(dataset)
mass <- mass[!is.na(mass)]
tmptree <- keep.tip(tree, names(mass))
fitContinuous(tree, mass, model = "lambda")

#4
bio1 <- as.numeric(dataset$bio1)
names(bio1) <- row.names(dataset)
bio1 <- bio1[!is.na(bio1)]
tmptree <- keep.tip(tree, names(bio1))
fitContinuous(tree, bio1 , model = "lambda")

#5
Aspect <- as.numeric(dataset$Aspect)
names(Aspect) <- row.names(dataset)
Aspect <- Aspect[!is.na(Aspect)]
tmptree <- keep.tip(tree, names(Aspect))
fitContinuous(tree, Aspect , model = "lambda")

#6
Ageatfirstbirth <- as.integer(dataset$X3.1_AgeatFirstBirth_d)
names(Ageatfirstbirth) <- row.names(dataset)
Ageatfirstbirth <- Ageatfirstbirth[!is.na(Ageatfirstbirth)]
tmptree <- keep.tip(tree, names(Ageatfirstbirth))
fitContinuous(tmptree, Ageatfirstbirth, model = "lambda")

#7
Ageateyeopening <- as.integer(dataset$X2.1_AgeatEyeOpening_d)
names(Ageateyeopening) <- row.names(dataset)
Ageateyeopening <- Ageateyeopening[!is.na(Ageateyeopening)]
tmptree <- keep.tip(tree, names(Ageateyeopening))
fitContinuous(tmptree, Ageateyeopening, model = "lambda")

#8
Basalmetrateml02 <- as.integer(dataset$X18.1_BasalMetRate_mLO2hr)
names(Basalmetrateml02) <- row.names(dataset)
Basalmetrateml02 <- Basalmetrateml02[!is.na(Basalmetrateml02)]
tmptree <- keep.tip(tree, names(Basalmetrateml02))
fitContinuous(tmptree, Basalmetrateml02, model = "lambda")

#9
Basalmetratemass <- as.integer(dataset$X5.2_BasalMetRateMass_g)
names(Basalmetratemass) <- row.names(dataset)
Basalmetratemass <- Basalmetratemass[!is.na(Basalmetratemass)]
tmptree <- keep.tip(tree, names(Basalmetratemass))
fitContinuous(tmptree, Basalmetratemass, model = "lambda")

#10
Dispersalage <- as.integer(dataset$X7.1_DispersalAge_d)
names(Dispersalage) <- row.names(dataset)
Dispersalage <- Dispersalage[!is.na(Dispersalage)]
tmptree <- keep.tip(tree, names(Dispersalage))
fitContinuous(tmptree, Dispersalage, model = "lambda")

#11
Gestationlength <- as.integer(dataset$X9.1_GestationLen_d)
names(Gestationlength) <- row.names(dataset)
Gestationlength <- Gestationlength[!is.na(Gestationlength)]
tmptree <- keep.tip(tree, names(Gestationlength))
fitContinuous(tmptree, Gestationlength, model = "lambda")

#12
Numoffspring <- as.integer(dataset$NumOffspring)
names(Numoffspring) <- row.names(dataset)
Numoffspring <- Numoffspring[!is.na(Numoffspring)]
tmptree <- keep.tip(tree, names(Numoffspring))
fitContinuous(tmptree, Numoffspring, model = "lambda")

#13
Homerange <- as.integer(dataset$X22.1_HomeRange_km2)
names(Homerange) <- row.names(dataset)
Homerange <- Homerange[!is.na(Homerange)]
tmptree <- keep.tip(tree, names(Homerange))
fitContinuous(tmptree, Homerange, model = "lambda")

#14
Homerangeindv <- as.integer(dataset$X22.2_HomeRange_Indiv_km2)
names(Homerangeindv) <- row.names(dataset)
Homerangeindv <- Homerangeindv[!is.na(Homerangeindv)]
tmptree <- keep.tip(tree, names(Homerangeindv))
fitContinuous(tmptree, Homerangeindv, model = "lambda")

#15
Interbirthinterval <- as.integer(dataset$X14.1_InterbirthInterval_d)
names(Interbirthinterval) <- row.names(dataset)
Interbirthinterval <- Interbirthinterval[!is.na(Interbirthinterval)]
tmptree <- keep.tip(tree, names(Interbirthinterval))
fitContinuous(tmptree, Interbirthinterval, model = "lambda")

#16
Littersize <- as.integer(dataset$X15.1_LitterSize)
names(Littersize) <- row.names(dataset)
Littersize <- Littersize[!is.na(Littersize)]
tmptree <- keep.tip(tree, names(Littersize))
fitContinuous(tmptree, Littersize, model = "lambda")

#17
Littersperyear <- as.integer(dataset$X16.1_LittersPerYear)
names(Littersperyear) <- row.names(dataset)
Littersperyear <- Littersperyear[!is.na(Littersperyear)]
tmptree <- keep.tip(tree, names(Littersperyear))
fitContinuous(tmptree, Littersperyear, model = "lambda")

#18
Maxlongevity <- as.integer(dataset$X17.1_MaxLongevity_m)
names(Maxlongevity) <- row.names(dataset)
Maxlongevity <- Maxlongevity[!is.na(Maxlongevity)]
tmptree <- keep.tip(tree, names(Maxlongevity))
fitContinuous(tmptree, Maxlongevity, model = "lambda")

#19
Neonatebodymass <- as.integer(dataset$X5.3_NeonateBodyMass_g)
names(Neonatebodymass) <- row.names(dataset)
Neonatebodymass <- Neonatebodymass[!is.na(Neonatebodymass)]
tmptree <- keep.tip(tree, names(Neonatebodymass))
fitContinuous(tmptree, Neonatebodymass, model = "lambda")

#20
Neonateheadbodylength <- as.integer(dataset$X13.2_NeonateHeadBodyLen_mm)
names(Neonateheadbodylength) <- row.names(dataset)
Neonateheadbodylength <- Neonateheadbodylength[!is.na(Neonateheadbodylength)]
tmptree <- keep.tip(tree, names(Neonateheadbodylength))
fitContinuous(tmptree, Neonateheadbodylength, model = "lambda")

#21
Populationdensity <- as.integer(dataset$X21.1_PopulationDensity_n_per_km2)
names(Populationdensity) <- row.names(dataset)
Populationdensity <- Populationdensity[!is.na(Populationdensity)]
tmptree <- keep.tip(tree, names(Populationdensity))
fitContinuous(tmptree, Populationdensity, model = "lambda")

#22
Populationgroupsize <- as.integer(dataset$X10.1_PopulationGrpSize)
names(Populationgroupsize) <- row.names(dataset)
Populationgroupsize <- Populationgroupsize[!is.na(Populationgroupsize)]
tmptree <- keep.tip(tree, names(Populationgroupsize))
fitContinuous(tmptree, Populationgroupsize, model = "lambda")

#23
Sexualmaturityage <- as.integer(dataset$X23.1_SexualMaturityAge_d)
names(Sexualmaturityage) <- row.names(dataset)
Sexualmaturityage <- Sexualmaturityage[!is.na(Sexualmaturityage)]
tmptree <- keep.tip(tree, names(Sexualmaturityage))
fitContinuous(tmptree, Sexualmaturityage, model = "lambda")

#24
Socialgroupsize <- as.integer(dataset$X10.2_SocialGrpSize)
names(Socialgroupsize) <- row.names(dataset)
Socialgroupsize <- Socialgroupsize[!is.na(Socialgroupsize)]
tmptree <- keep.tip(tree, names(Socialgroupsize))
fitContinuous(tmptree, Socialgroupsize, model = "lambda")

#25
Weaningage <- as.integer(dataset$X25.1_WeaningAge_d)
names(Weaningage) <- row.names(dataset)
Weaningage <- Weaningage[!is.na(Weaningage)]
tmptree <- keep.tip(tree, names(Weaningage))
fitContinuous(tmptree, Weaningage, model = "lambda")

#26
Weaningbodymass <- as.integer(dataset$X5.4_WeaningBodyMass_g)
names(Weaningbodymass) <- row.names(dataset)
Weaningbodymass <- Weaningbodymass[!is.na(Weaningbodymass)]
tmptree <- keep.tip(tree, names(Weaningbodymass))
fitContinuous(tmptree, Weaningbodymass, model = "lambda")

#27
Weaningheadbodylength <- as.integer(dataset$X13.3_WeaningHeadBodyLen_mm)
names(Weaningheadbodylength) <- row.names(dataset)
Weaningheadbodylength <- Weaningheadbodylength[!is.na(Weaningheadbodylength)]
tmptree <- keep.tip(tree, names(Weaningheadbodylength))
fitContinuous(tmptree, Weaningheadbodylength, model = "lambda")


#28
AVGfoodconsumption <- as.integer(dataset$AVGFoodConsumption)
names(AVGfoodconsumption) <- row.names(dataset)
AVGfoodconsumption <- AVGfoodconsumption[!is.na(AVGfoodconsumption)]
tmptree <- keep.tip(tree, names(AVGfoodconsumption))
fitContinuous(tmptree, AVGfoodconsumption, model = "lambda")

#29
Maturityreachmale <- as.integer(dataset$MaturityReachMale)
names(Maturityreachmale) <- row.names(dataset)
Maturityreachmale <- Maturityreachmale[!is.na(Maturityreachmale)]
tmptree <- keep.tip(tree, names(Maturityreachmale))
fitContinuous(tmptree, Maturityreachmale, model = "lambda")

#30
Maturityreachfemale <- as.integer(dataset$MaturityReachFemale)
names(Maturityreachfemale) <- row.names(dataset)
Maturityreachfemale <- Maturityreachfemale[!is.na(Maturityreachfemale)]
tmptree <- keep.tip(tree, names(Maturityreachfemale))
fitContinuous(tmptree, Maturityreachfemale, model = "lambda")

#31
Breedinginterval <- as.integer(dataset$BreedingInterval)
names(Breedinginterval) <- row.names(dataset)
Breedinginterval <- Breedinginterval[!is.na(Breedinginterval)]
tmptree <- keep.tip(tree, names(Breedinginterval))
fitContinuous(tmptree, Breedinginterval, model = "lambda")

#32
Lifespan <- as.integer(dataset$Lifespan)
names(Lifespan) <- row.names(dataset)
Lifespan <- Lifespan[!is.na(Lifespan)]
tmptree <- keep.tip(tree, names(Lifespan))
fitContinuous(tmptree, Lifespan, model = "lambda")

#33
CarryWeight <- as.integer(dataset$CarryWeight)
names(CarryWeight) <- row.names(dataset)
CarryWeight <- CarryWeight[!is.na(CarryWeight)]
tmptree <- keep.tip(tree, names(CarryWeight))
fitContinuous(tmptree, CarryWeight, model = "lambda")

#34
Pullstrength <- as.integer(dataset$PullStrength)
names(Pullstrength) <- row.names(dataset)
Pullstrength <- Pullstrength[!is.na(Pullstrength)]
tmptree <- keep.tip(tree, names(Pullstrength))
fitContinuous(tmptree, Pullstrength, model = "lambda")

#35
AVGMovingSpeed <- as.integer(dataset$AVGMovingSpeed)
names(AVGMovingSpeed) <- row.names(dataset)
AVGMovingSpeed <- AVGMovingSpeed[!is.na(AVGMovingSpeed)]
tmptree <- keep.tip(tree, names(AVGMovingSpeed))
fitContinuous(tmptree, AVGMovingSpeed, model = "lambda")

#36
AVGTravelDistance <- as.integer(dataset$AVGTravelDistance)
names(AVGTravelDistance) <- row.names(dataset)
AVGTravelDistance <- AVGTravelDistance[!is.na(AVGTravelDistance)]
tmptree <- keep.tip(tree, names(AVGTravelDistance))
fitContinuous(tmptree, AVGTravelDistance, model = "lambda")

#37
BulkDensity <- as.integer(dataset$BulkDensity)
names(BulkDensity) <- row.names(dataset)
BulkDensity <- BulkDensity[!is.na(BulkDensity)]
tmptree <- keep.tip(tree, names(BulkDensity))
fitContinuous(tmptree, BulkDensity, model = "lambda")

#38
ClayPercentage <- as.integer(dataset$ClayPercentage)
names(ClayPercentage) <- row.names(dataset)
ClayPercentage <- ClayPercentage[!is.na(ClayPercentage)]
tmptree <- keep.tip(tree, names(ClayPercentage))
fitContinuous(tmptree, ClayPercentage, model = "lambda")

#39
annualPET <- as.integer(dataset$annualPET)
names(annualPET) <- row.names(dataset)
annualPET <- annualPET[!is.na(annualPET)]
tmptree <- keep.tip(tree, names(annualPET))
fitContinuous(tmptree, annualPET, model = "lambda")

#40
aridityindex <- as.integer(dataset$aridityIndexThornthwaite)
names(aridityindex) <- row.names(dataset)
aridityindex <- aridityindex[!is.na(aridityindex)]
tmptree <- keep.tip(tree, names(aridityindex))
fitContinuous(tmptree, aridityindex, model = "lambda")

#41
Climaticmoistureindex <- as.integer(dataset$climaticMoistureIndex)
names(Climaticmoistureindex) <- row.names(dataset)
Climaticmoistureindex <- Climaticmoistureindex[!is.na(Climaticmoistureindex)]
tmptree <- keep.tip(tree, names(Climaticmoistureindex))
fitContinuous(tmptree, Climaticmoistureindex, model = "lambda")

#42
Continentality <- as.integer(dataset$continentality)
names(Continentality) <- row.names(dataset)
Continentality <- Continentality[!is.na(Continentality)]
tmptree <- keep.tip(tree, names(Continentality))
fitContinuous(tmptree, Continentality, model = "lambda")

#43
EmbergerQ <- as.integer(dataset$embergerQ)
names(EmbergerQ) <- row.names(dataset)
EmbergerQ <- EmbergerQ[!is.na(EmbergerQ)]
tmptree <- keep.tip(tree, names(EmbergerQ))
fitContinuous(tmptree, EmbergerQ, model = "lambda")

#44
GrowingDegDays0 <- as.integer(dataset$growingDegDays0)
names(GrowingDegDays0) <- row.names(dataset)
GrowingDegDays0 <- GrowingDegDays0[!is.na(GrowingDegDays0)]
tmptree <- keep.tip(tree, names(GrowingDegDays0))
fitContinuous(tmptree, GrowingDegDays0, model = "lambda")

#45
GrowingDegDays5 <- as.integer(dataset$growingDegDays5)
names(GrowingDegDays5) <- row.names(dataset)
GrowingDegDays5 <- GrowingDegDays5[!is.na(GrowingDegDays5)]
tmptree <- keep.tip(tree, names(GrowingDegDays5))
fitContinuous(tmptree, GrowingDegDays5, model = "lambda")

#46
Maxtempcoldest <- as.integer(dataset$maxTempColdest)
names(Maxtempcoldest) <- row.names(dataset)
Maxtempcoldest <- Maxtempcoldest[!is.na(Maxtempcoldest)]
tmptree <- keep.tip(tree, names(Maxtempcoldest))
fitContinuous(tmptree, Maxtempcoldest, model = "lambda")

#47
Mintempwarmest <- as.integer(dataset$minTempWarmest)
names(Mintempwarmest) <- row.names(dataset)
Mintempwarmest <- Mintempwarmest[!is.na(Mintempwarmest)]
tmptree <- keep.tip(tree, names(Mintempwarmest))
fitContinuous(tmptree, Mintempwarmest, model = "lambda")

#48
Monthcountbytemp10 <- as.integer(dataset$monthCountByTemp10)
names(Monthcountbytemp10) <- row.names(dataset)
Monthcountbytemp10<- Monthcountbytemp10[!is.na(Monthcountbytemp10)]
tmptree <- keep.tip(tree, names(Monthcountbytemp10))
fitContinuous(tmptree, Monthcountbytemp10, model = "lambda")

#49
PETcoldestquarter <- as.integer(dataset$PETColdestQuarter)
names(PETcoldestquarter ) <- row.names(dataset)
PETcoldestquarter <- PETcoldestquarter[!is.na(PETcoldestquarter)]
tmptree <- keep.tip(tree, names(PETcoldestquarter))
fitContinuous(tmptree, PETcoldestquarter, model = "lambda")

#50
PETdriestquarter <- as.integer(dataset$PETDriestQuarter)
names(PETdriestquarter) <- row.names(dataset)
PETdriestquarter <- PETdriestquarter[!is.na(PETdriestquarter)]
tmptree <- keep.tip(tree, names(PETdriestquarter))
fitContinuous(tmptree, PETdriestquarter, model = "lambda")

#51
PETseasonality <- as.integer(dataset$PETseasonality)
names(PETseasonality) <- row.names(dataset)
PETseasonality <- PETseasonality[!is.na(PETseasonality)]
tmptree <- keep.tip(tree, names(PETseasonality))
fitContinuous(tmptree, PETseasonality, model = "lambda")

#52
PETwarmestquarter <- as.integer(dataset$PETWarmestQuarter)
names(PETwarmestquarter) <- row.names(dataset)
PETwarmestquarter <- PETwarmestquarter[!is.na(PETwarmestquarter)]
tmptree <- keep.tip(tree, names(PETwarmestquarter))
fitContinuous(tmptree, PETwarmestquarter, model = "lambda")

#53
PETwettestquarter <- as.integer(dataset$PETWettestQuarter)
names(PETwettestquarter) <- row.names(dataset)
PETwettestquarter <- PETwettestquarter[!is.na(PETwettestquarter)]
tmptree <- keep.tip(tree, names(PETwettestquarter))
fitContinuous(tmptree, PETwettestquarter, model = "lambda")

#54
Thermicityindex <- as.integer(dataset$thermicityIndex)
names(Thermicityindex) <- row.names(dataset)
Thermicityindex <- Thermicityindex[!is.na(Thermicityindex)]
tmptree <- keep.tip(tree, names(Thermicityindex))
fitContinuous(tmptree, Thermicityindex, model = "lambda")

#55
OrganicCarbon <- as.integer(dataset$OrganicCarbon)
names(OrganicCarbon) <- row.names(dataset)
OrganicCarbon <- OrganicCarbon[!is.na(OrganicCarbon)]
tmptree <- keep.tip(tree, names(OrganicCarbon))
fitContinuous(tmptree, OrganicCarbon, model = "lambda")

#56
PhCaCl <- as.integer(dataset$PhCaCL)
names(PhCaCl) <- row.names(dataset)
PhCaCl <- PhCaCl[!is.na(PhCaCl)]
tmptree <- keep.tip(tree, names(PhCaCl))
fitContinuous(tmptree, PhCaCl, model = "lambda")

#57
Slope <- as.integer(dataset$Slope)
names(Slope) <- row.names(dataset)
Slope <- Slope[!is.na(Slope)]
tmptree <- keep.tip(tree, names(Slope))
fitContinuous(tmptree, Slope, model = "lambda")

#58
Bio2 <- as.integer(dataset$bio2)
names(Bio2) <- row.names(dataset)
Bio2 <- Bio2[!is.na(Bio2)]
tmptree <- keep.tip(tree, names(Bio2))
fitContinuous(tmptree, Bio2, model = "lambda")

#59
Bio3 <- as.integer(dataset$bio3)
names(Bio3) <- row.names(dataset)
Bio3 <- Bio3[!is.na(Bio3)]
tmptree <- keep.tip(tree, names(Bio3))
fitContinuous(tmptree, Bio3, model = "lambda")

#60
Bio4 <- as.integer(dataset$bio4)
names(Bio4) <- row.names(dataset)
Bio4 <- Bio4[!is.na(Bio4)]
tmptree <- keep.tip(tree, names(Bio4))
fitContinuous(tmptree, Bio4, model = "lambda")

#61
Bio5 <- as.integer(dataset$bio5)
names(Bio5) <- row.names(dataset)
Bio5 <- Bio5[!is.na(Bio5)]
tmptree <- keep.tip(tree, names(Bio5))
fitContinuous(tmptree, Bio5, model = "lambda")

#62
Bio6 <- as.integer(dataset$bio6)
names(Bio6) <- row.names(dataset)
Bio6 <- Bio6[!is.na(Bio6)]
tmptree <- keep.tip(tree, names(Bio6))
fitContinuous(tmptree, Bio6, model = "lambda")

#63
Bio7 <- as.integer(dataset$bio7)
names(Bio7) <- row.names(dataset)
Bio7 <- Bio7[!is.na(Bio7)]
tmptree <- keep.tip(tree, names(Bio7))
fitContinuous(tmptree, Bio7, model = "lambda")

#64
Bio8 <- as.integer(dataset$bio8)
names(Bio8) <- row.names(dataset)
Bio8 <- Bio8[!is.na(Bio8)]
tmptree <- keep.tip(tree, names(Bio8))
fitContinuous(tmptree, Bio8, model = "lambda")

#65
Bio9 <- as.integer(dataset$bio9)
names(Bio9) <- row.names(dataset)
Bio9 <- Bio9[!is.na(Bio9)]
tmptree <- keep.tip(tree, names(Bio9))
fitContinuous(tmptree, Bio9, model = "lambda")

#66
Bio10 <- as.integer(dataset$bio10)
names(Bio10) <- row.names(dataset)
Bio10 <- Bio10[!is.na(Bio10)]
tmptree <- keep.tip(tree, names(Bio10))
fitContinuous(tmptree, Bio10, model = "lambda")

#67
Bio11 <- as.integer(dataset$bio11)
names(Bio11) <- row.names(dataset)
Bio11 <- Bio11[!is.na(Bio11)]
tmptree <- keep.tip(tree, names(Bio11))
fitContinuous(tmptree, Bio11, model = "lambda")

#68
Bio12 <- as.integer(dataset$bio12)
names(Bio12) <- row.names(dataset)
Bio12 <- Bio12[!is.na(Bio12)]
tmptree <- keep.tip(tree, names(Bio12))
fitContinuous(tmptree, Bio12, model = "lambda")

#69
Bio13 <- as.integer(dataset$bio13)
names(Bio13) <- row.names(dataset)
Bio13 <- Bio13[!is.na(Bio13)]
tmptree <- keep.tip(tree, names(Bio13))
fitContinuous(tmptree, Bio13, model = "lambda")

#70
Bio14 <- as.integer(dataset$bio14)
names(Bio14) <- row.names(dataset)
Bio14 <- Bio14[!is.na(Bio14)]
tmptree <- keep.tip(tree, names(Bio14))
fitContinuous(tmptree, Bio14, model = "lambda")

#71
Bio15 <- as.integer(dataset$bio15)
names(Bio15) <- row.names(dataset)
Bio15 <- Bio15[!is.na(Bio15)]
tmptree <- keep.tip(tree, names(Bio15))
fitContinuous(tmptree, Bio15, model = "lambda")

#72
Bio16 <- as.integer(dataset$bio16)
names(Bio16) <- row.names(dataset)
Bio16 <- Bio16[!is.na(Bio16)]
tmptree <- keep.tip(tree, names(Bio16))
fitContinuous(tmptree, Bio16, model = "lambda")

#73
Bio17 <- as.integer(dataset$bio17)
names(Bio17) <- row.names(dataset)
Bio17 <- Bio17[!is.na(Bio17)]
tmptree <- keep.tip(tree, names(Bio17))
fitContinuous(tmptree, Bio17, model = "lambda")

#74
Bio18 <- as.integer(dataset$bio18)
names(Bio18) <- row.names(dataset)
Bio18 <- Bio18[!is.na(Bio18)]
tmptree <- keep.tip(tree, names(Bio18))
fitContinuous(tmptree, Bio18, model = "lambda")

#75
Bio19 <- as.integer(dataset$bio19)
names(Bio19) <- row.names(dataset)
Bio19 <- Bio19[!is.na(Bio19)]
tmptree <- keep.tip(tree, names(Bio19))
fitContinuous(tmptree, Bio19, model = "lambda")



#Categorical Variables



#76
Naturalpredators <- as.integer(dataset$NaturalPredators)
names(Naturalpredators) <- row.names(dataset)
Naturalpredators <- Naturalpredators[!is.na(Naturalpredators)]
tmptree <- keep.tip(tree, names(Naturalpredators))
fitDiscrete(tmptree, Naturalpredators, model = "ER", transform = "lambda")

#77
Headornaments <- as.integer(dataset$HeadOrnaments)
names(Headornaments) <- row.names(dataset)
Headornaments <- Headornaments[!is.na(Headornaments)]
tmptree <- keep.tip(tree, names(Headornaments))
fitDiscrete(tmptree, Headornaments, model = "ARD", transform = "lambda")

#78
DevelopmentStrategy <- as.integer(dataset$DevelopmentStrategy)
names(DevelopmentStrategy) <- row.names(dataset)
DevelopmentStrategy <- DevelopmentStrategy[!is.na(DevelopmentStrategy)]
tmptree <- keep.tip(tree, names(DevelopmentStrategy))
fitDiscrete(tmptree, DevelopmentStrategy, model = "ER", transform = "lambda")

#79
Yearroundbreeding <- as.integer(dataset$YearRoundBreeding)
names(Yearroundbreeding) <- row.names(dataset)
Yearroundbreeding <- Yearroundbreeding[!is.na(Yearroundbreeding)]
tmptree <- keep.tip(tree, names(Yearroundbreeding))
fitDiscrete(tmptree, Yearroundbreeding, model = "ER", transform = "lambda")

#80
Matingsystem <- as.integer(dataset$MatingSystem)
names(Matingsystem) <- row.names(dataset)
Matingsystem <- Matingsystem[!is.na(Matingsystem)]
tmptree <- keep.tip(tree, names(Matingsystem))
fitDiscrete(tmptree, Matingsystem, model = "ER", transform = "lambda")

#81
NumMales <- as.integer(dataset$NumMales)
names(NumMales) <- row.names(dataset)
NumMales <- NumMales[!is.na(NumMales)]
tmptree <- keep.tip(tree, names(NumMales))
fitDiscrete(tmptree, NumMales, model = "ER", transform = "lambda")

#82
Diet <- as.integer(dataset$Diet)
names(Diet) <- row.names(dataset)
Diet <- Diet[!is.na(Diet)]
tmptree <- keep.tip(tree, names(Diet))
fitDiscrete(tmptree, Diet, model = "ARD", transform = "lambda")

#83
Sociality <- as.integer(dataset$Sociality)
names(Sociality) <- row.names(dataset)
Sociality <- Sociality[!is.na(Sociality)]
tmptree <- keep.tip(tree, names(Sociality))
fitDiscrete(tmptree, Sociality, model = "ER", transform = "lambda")

#84
SocialHeirarchy <- as.integer(dataset$SocialHierarchy)
names(SocialHeirarchy) <- row.names(dataset)
SocialHeirarchy <- SocialHeirarchy[!is.na(SocialHeirarchy)]
tmptree <- keep.tip(tree, names(SocialHeirarchy))
fitDiscrete(tmptree, SocialHeirarchy, model = "ER", transform = "lambda")

#85
Trophiclevel <- as.integer(dataset$X6.2_TrophicLevel)
names(Trophiclevel) <- row.names(dataset)
Trophiclevel <- Trophiclevel[!is.na(Trophiclevel)]
tmptree <- keep.tip(tree, names(Trophiclevel))
fitDiscrete(tmptree, Trophiclevel, model = "ER", transform = "lambda")

#86
Habitatbreadth <- as.integer(dataset$X12.1_HabitatBreadth)
names(Habitatbreadth) <- row.names(dataset)
Habitatbreadth <- Habitatbreadth[!is.na(Habitatbreadth)]
tmptree <- keep.tip(tree, names(Habitatbreadth))
fitDiscrete(tmptree, Habitatbreadth, model = "ARD", transform = "lambda")

#87
ActivityCycle <- as.integer(dataset$X1.1_ActivityCycle)
names(ActivityCycle) <- row.names(dataset)
ActivityCycle <- ActivityCycle[!is.na(ActivityCycle)]
tmptree <- keep.tip(tree, names(ActivityCycle))
fitDiscrete(tree, ActivityCycle, model = "ARD", transform = "lambda")

#88
TeatNumber <- as.integer(dataset$X24.1_TeatNumber)
names(TeatNumber) <- row.names(dataset)
TeatNumber <- TeatNumber[!is.na(TeatNumber)]
tmptree <- keep.tip(tree, names(TeatNumber))
fitDiscrete(tmptree, TeatNumber, model = "ARD", transform = "lambda")

#89
Dietbreadth <- as.integer(dataset$X6.1_DietBreadth)
names(Dietbreadth) <- row.names(dataset)
Dietbreadth <- Dietbreadth[!is.na(Dietbreadth)]
tmptree <- keep.tip(tree, names(Dietbreadth))
fitDiscrete(tmptree, Dietbreadth, model = "meristic", transform = "lambda")

#90
Terrestriality <- as.integer(dataset$X12.2_Terrestriality)
names(Terrestriality) <- row.names(dataset)
Terrestriality <- Terrestriality[!is.na(Terrestriality)]
tmptree <- keep.tip(tree, names(Terrestriality))
fitDiscrete(tmptree, Terrestriality, model = "ARD", transform = "lambda")

#91
ParentalCare <- as.integer(dataset$ParentalCare)
names(ParentalCare) <- row.names(dataset)
ParentalCare <- ParentalCare[!is.na(ParentalCare)]
tmptree <- keep.tip(tree, names(ParentalCare))
fitDiscrete(tmptree, ParentalCare, model = "meristic", transform = "lambda")

#92
Motility <- as.integer(dataset$Motility)
names(Motility) <- row.names(dataset)
Motility <- Motility[!is.na(Motility)]
tmptree <- keep.tip(tree, names(Motility))
fitDiscrete(tmptree, Motility, model = "ARD", transform = "lambda")


#Columns 1-8 are irrelevant, The following traits were removed from the final
#figure:
#Traits removed from analysis, table, and figure:
#1) Carry Weight (proxy for body mass, calculated as 20% of adultbody mass, same calculation used for pullweight)
#2) Pullweight (proxy for body mass)
#3) Adultforearmlength (only 3 entries; all traits with less than 10 entries will be removed)
#4) ageateyeopening (only 2 entries)
#5) weaningheadbodylength (only 2 entries)
#6) maturity reach male (same as sexual maturity age)
#7)maturity reach female (same as sexual maturity age)
#8) Breedinginterval (same as interbirthinterval)
#9) lifespan (same as max longevity)
#10) Num offspring (same as litter size)
#11) Motility (all recorded values were 1, no variability)
#12) parental care (all recorded values were 2, no variability)
#13) Terrestriality (all recorded values were 1, no variability) 
#14) AVG Body mass (same as adult body mass)
#15) Domestication removed (irrelevant variable for this project)

1



