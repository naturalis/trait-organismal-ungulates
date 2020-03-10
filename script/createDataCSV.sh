#!/bin/bash

## DECLARE
# Declare root
root="/home/zoe/Documents/GitHub/trait-organismal-ungulates/"

# Declare files
pantheria=${root}"data/PanTHERIA.tsv"
species=${root}"data/CSV/speciesList.txt"
panHeader=${root}"data/CSV/headers.txt"
traitCSV=${root}"data/CSV/ungulatesTraits.csv"

# Extract headers from Pantheria file, remove Binomial column
header=$(head -n 1 ${pantheria} | sed -e 's/\<MSW05_Binomial\>//g'| awk '{for(i=0;i<=35;++i)print $i}' | tail -n 35 | tr '\n' ',' | sed -e 's/\<References\>//g' | sed '$ s/.$//' |  sed '$ s/.$//')

# Declare the headers
# headerTaxonomy: contains the BinomialName, Order, Family, Genus and Species
# headerID: contains the headers for the ID-codes
# headerTraits1: contains the traits from the Pantheria file
# headerTraits2: contains the chosen traits
# headerTraits3: contains the traits for the Seshat Database
headerTaxonomy=$(echo ${header} | cut -d ',' -f -4 | tr ',' ' ' | sed 's/\MSW05_//g' | tr ' ' ',')
headerID=$(echo 'ID_EoL')
headerTraits1=$(echo ${header} | cut -d ',' -f 5-)
headerTraits2=$(echo 'Diet,AVGFoodConsumption,Sociality,SocialHierarchy,NumMales,MaturityReachMale,MaturityReachFemale,MatingSystem,NumOffspring,BreedingInterval,YearRoundBreeding,AVGWeight,ParentalCare,DevelopmentStrategy,Horns/Antlers,Lifespan,NaturalPredators,Motility')
headerTraits3=$(echo 'CarryWeight,PullStrength,AVGMovingSpeed,AVGTravelDistance')


# Add new columns
printf "%s,%s,%s,%s,%s,%s,%s" "${headerID}" "BinomialName" "${headerTaxonomy}" "Domestication" "${headerTraits1}" "${headerTraits2}" "${headerTraits3}" > ${panHeader}


# Combine the new header file with the species
cat ${panHeader} ${species} > ${traitCSV}





