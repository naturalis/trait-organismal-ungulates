#!/bin/bash

# Declaring variables
ungulatesTree="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/ungulates.tree"
numTree="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/S21191.tree"
pantheria="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/PanTHERIA.tsv"
speciesTXT="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/CSV/speciesList.txt"
idEOL="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/eolID.csv"

binomArray=()
orderArray=()
famArray=()
genusArray=()
speciesArray=()
domArray=()
pantArray1=()
pantArray2=()
pantArrayfinal=()
eolIDarray=()
dietArray=()
echo "" > "${speciesTXT}"


# Get species names
# Make a list of the species names from the ungulates.tree file
sed 's/[0-9]*//g' ${ungulatesTree} | tr -d "():;." | tr "," "\n" > ungulateSpecies.txt

# Make a list of the species names from the S21191.tree file
cat ${numTree} | sed 's/[0-9]*//g' | tr -d "():;." | tr "," "\n" > S21191Species.txt

# Combine the two lists and remove duplicates
speciesList=$(cat ungulateSpecies.txt S21191Species.txt | sort -u | sort)

# Delete obsolete files
rm ungulateSpecies.txt S21191Species.txt


# Loop through speciesList and look up the orders from PanTHERIA
# Needed orders: Artiodactyla (even-toed), Perissodactyla (uneven-toed)
for species in ${speciesList}
do	
	grepname=$(echo ${species} | sed 's/_/ /g')
	order=$(grep "${grepname}" ${pantheria} | awk '{printf $1}')

	if [[ ${order} == "Artiodactyla" ]]  || [[ ${order} == "Perissodactyla" ]]
	then
		binomArray+=(${species})
		orderArray+=(${order})
	
		# Get ID from EoL-ID file
		eol=$(grep "${grepname}" ${idEOL} | tr ',' ' ' | awk '{printf $3}')
		eolIDarray+=(${eol})
		
		# Get taxonomy
		fam=$(grep "${grepname}" ${pantheria} | awk '{printf $2}')
		famArray+=(${fam})

		genus=$(grep "${grepname}" ${pantheria} | awk '{printf $3}')
		genusArray+=(${genus})

		speciesTax=$(grep "${grepname}" ${pantheria} | awk '{printf $4}')
		speciesArray+=(${speciesTax})
		
		# Get domestication level
		domArray+=("X")

		# Get PanTHERIA columns
		pant=$(grep "${grepname}" ${pantheria} | cut -f6-35 | tr "\t" "," | tr -d "\n")
		pantArray1+=(${pant})

		# Get Diet
		diet=$(curl -s https://animaldiversity.org/accounts/${species}/ | grep -A 5 Primary | tail -n1 | sed 's/.*">//' | cut -f1 -d "<")
		if [[ ${diet} == "" ]]
		then
			dietArray+=("NA")
		else
			dietArray+=($diet)
		fi		
		
	fi
done



# Write the newly found species to a txt file
for (( i=0; i<=${#binomArray[@]}; i++ ))
do
	printf "%s,%s,%s,%s,%s,%s,%s,%s,%s" "${eolIDarray[${i}]}" "${binomArray[${i}]}" "${orderArray[${i}]}" "${famArray[${i}]}" "${genusArray[${i}]}" "${speciesArray[${i}]}" "${domArray[${i}]}" "${pantArray1[${i}]}" "${dietArray[${i}]}" >> ${speciesTXT}

	#pantArray2=$(echo ${pantArray1[${i}]})
	#printf "%s," ${pantArray2[${y}]} >> ${speciesTXT}
	
	#printf "%s" "${dietArray[${i}]}" >> ${speciesTXT}
	printf "\n" >> ${speciesTXT}

done

sed -i '$d' ${speciesTXT}
