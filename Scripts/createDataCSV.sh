#!/bin/bash

# Extract headers from Pantheria file, remove Binomial column
header=$(head -n 1 ~/Documents/GitHub/trait-organismal-ungulates/data/PanTHERIA_1-0_WR05_Aug2008.tsv | sed -e 's/\<MSW05_Binomial\>//g'| awk '{for(i=0;i<=35;++i)print $i}' | tail -n 35 | tr '\n' ',' | sed -e 's/\<References\>//g' | sed '$ s/.$//' |  sed '$ s/.$//')

headerTaxonomy=$(echo ${header} | cut -d ',' -f -4 | tr ',' ' ' | sed 's/\MSW05_//g' | tr ' ' ',')
headerTraits1=$(echo ${header} | cut -d ',' -f 5-)
headerTraits2=$(echo 'Diet,Nature,Dangerous,Docile,GestationPeriod,GrowthRate')

# Add new columns
# BinomialName, Domestication, Diet, Nature, Dangerous, Docile, GestationPeriod, GrowthRate, 
printf "%s,%s,%s,%s,%s\n" "BinomialName" "${headerTaxonomy}" "Domestication" "${headerTraits1}" "${headerTraits2}" > ~/Documents/GitHub/trait-organismal-ungulates/testData/headers.txt

# Combine the new header file with the species
cat ~/Documents/GitHub/trait-organismal-ungulates/testData/headers.txt ~/Documents/GitHub/trait-organismal-ungulates/testData/speciesList.txt > ~/Documents/GitHub/trait-organismal-ungulates/testData/ungulatesTraits.csv





