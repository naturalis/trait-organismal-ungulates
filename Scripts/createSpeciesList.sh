#!/bin/bash

# Declare variables
speciesArray=()
notFound=()
#namesArray=()

# Make a list of the species names from the ungulates.tree file
cat ~/Documents/GitHub/trait-organismal-ungulates/data/ungulates.tree | sed 's/[0-9]*//g' | tr -d "():;." | tr "," "\n" > ~/Documents/GitHub/trait-organismal-ungulates/testData/ungulateSpecies.txt

# Make a list of the species names from the S21191.tree file
cat ~/Documents/GitHub/trait-organismal-ungulates/data/S21191.tree | sed 's/[0-9]*//g' | tr -d "():;." | tr "," "\n" > ~/Documents/GitHub/trait-organismal-ungulates/testData/S21191Species.txt

# Combine the two lists and remove duplicates
speciesList=$(cat ~/Documents/GitHub/trait-organismal-ungulates/testData/ungulateSpecies.txt ~/Documents/GitHub/trait-organismal-ungulates/testData/S21191Species.txt | sort -u | sort)

# Delete obsolete files
rm ~/Documents/GitHub/trait-organismal-ungulates/testData/ungulateSpecies.txt ~/Documents/GitHub/trait-organismal-ungulates/testData/S21191Species.txt

# Loop through speciesList and look up the orders from Animal Diversity Web
# Needed orders: Artiodactyla (even-toed), Perissodactyla (uneven-toed) and Proboscidea (elephants)
for species in ${speciesList}
do	
	order=$(wget -qO- https://animaldiversity.org/accounts/${species} | sed -e 's/<[^>]*>//g' | grep -A1 'Order' | sed 's/\<Order\>//g' | tr -d '[:space:]')

	if [[ ${order} == "Artiodactyla" ]]  || [[ ${order} == "Perissodactyla" ]] ||  [[ ${order} == "Proboscidea" ]]
	then
		speciesArray+=(${species})
	fi
	
	if [[ ${order} == "" ]]
	then
		notFound+=(${species})
	fi
done

# Write the newly found species to a txt file
printf "%s\n" "${speciesArray[@]}" > ~/Documents/GitHub/trait-organismal-ungulates/testData/speciesList.txt
printf "%s\n" "${notFound[@]}" > ~/Documents/GitHub/trait-organismal-ungulates/testData/notFound.txt


# Make list of species from PanTHERIA database file
#cat  ~/Documents/GitHub/trait-organismal-ungulates/data/PanTHERIA_1-0_WR05_Aug2008.tsv | grep -E 'Artiodactyla|Perissodactyla|Proboscidea' | awk '{print $5, $6, $7}' | sed 's/[0-9].*//g' | tr -d '-' | sort > speciesPantheria.txt

