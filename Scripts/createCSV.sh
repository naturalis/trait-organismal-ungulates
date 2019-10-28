#!/bin/bash

# Makes a list of the species names
cat ~/Documents/GitHub/trait-organismal-ungulates/Data/phylogeny/ungulates.tree | sed 's/[0-9]*//g' | tr -d "():;." | tr "," "\n" > ~/Documents/GitHub/trait-organismal-ungulates/Data/speciesList.txt

speciesList=$(cat ~/Documents/GitHub/trait-organismal-ungulates/Data/speciesList.txt)

for species in ${speciesList}
	do	
		echo ${species} 
	done






#testing
cat index.html.3 | grep -A1 "<h3 id=*"
