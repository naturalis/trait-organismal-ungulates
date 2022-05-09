# Define two subsets (domestic and wild species)
data <- subset(dataset, select = c(Domestication, X5.1_AdultBodyMass_g, DevelopmentStrategy, Horns_Antlers, AVGMovingSpeed, AVGTravelDistance))
data_dom <- data[data$Domestication == 1,]
data_wild <- data[data$Domestication == 0,]


## BOXPLOTS
#Bodymass
boxplot(data_dom$X5.1_AdultBodyMass_g, data_wild$X5.1_AdultBodyMass_g,
        main = "Bodymass",
        xlab = "bodymass (grams)",
        names = c("Domestic", "Wild"),
        ylim = c(0,1000000),
        col = c("lightcoral", "cornflowerblue"),
        horizontal = TRUE)
#abline(v=median(data_wild$X5.1_AdultBodyMass_g, na.rm = TRUE), col="grey25", lwd=2)
#abline(v=median(data_dom$X5.1_AdultBodyMass_g, na.rm = TRUE), col="grey25", lwd=2)
#axis(1, median(data_wild$X5.1_AdultBodyMass_g, na.rm = TRUE))
#axis(1, median(data_dom$X5.1_AdultBodyMass_g, na.rm = TRUE))

# Horns & Antlers
boxplot(data_dom$Horns_Antlers, data_wild$Horns_Antlers,
        main = "Horns & Antlers",
        xlab = "Horns/Antlers Value (1,2,3,4)",
        names = c("Domestic", "Wild"),
        col = c("lightcoral", "cornflowerblue"),
        horizontal = TRUE)
#abline(v=median(data_wild$Horns_Antlers, na.rm = TRUE), col="grey25", lwd=2)
#abline(v=median(data_dom$Horns_Antlers, na.rm = TRUE), col="grey25", lwd=2)

# Moving Speed
boxplot(data_dom$AVGMovingSpeed, data_wild$AVGMovingSpeed,
        main = "Average Moving Speed",
        names = c("Domestic", "Wild"),
        xlab = "moving speed (km/h)",
        col = c("lightcoral", "cornflowerblue"),
        horizontal = TRUE,
        xaxt="n")
#axis(1, at=c(10,20,30,40,50,60,70,80,90))
#axis(1, median(data_wild$AVGMovingSpeed, na.rm = TRUE))
#abline(v=median(data_wild$AVGMovingSpeed, na.rm = TRUE), col="grey25", lwd=2)
#abline(v=median(data_dom$AVGMovingSpeed, na.rm = TRUE), col="grey25", lwd=2)

# DevelopmentStrategy
boxplot(data_dom$DevelopmentStrategy, data_wild$DevelopmentStrategy,
        main = "Development Strategy",
        names = c("Domestic", "Wild"),
        xlab = "Development strategy value (1, 2)",
        ylim = c(0,3),
        col = c("lightcoral", "cornflowerblue"),
        horizontal = TRUE)

# AVGTravelDistance
boxplot(data_dom$AVGTravelDistance, data_wild$AVGTravelDistance,
        main = "Average Travel Distance",
        names = c("Domestic", "Wild"),
        xlab = "Average travel distance (km/day) ",
        ylim = c(0,200),
        col = c("lightcoral", "cornflowerblue"),
        horizontal = TRUE)
