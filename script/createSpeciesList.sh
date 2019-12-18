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
gestArray=()
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

		# Get index.html for species
		curl -o index.html https://animaldiversity.org/accounts/${species}/
		url=$(curl -Ls url_effective} https://animaldiversity.org/accounts/${species}/ | tail -n1 | sed 's/<.*>//g' | awk '{$1=$1};1')

		if [[ ${url} == "https://animaldiversity.org/accounts/${species}/classification/" ]]
		then
			dietArray+=("NA")
			gestArray+=("NA")
			
		else
			# Get Diet
			# When there are multiple kinds of food the species eat, add category 6
			# Else: add other category (1 - 5)
			dietCount=$(cat index.html | grep -A 10 "herbivore</a>" | grep .*vore | wc -l)
			if [[ ${dietCount} -gt "2" ]]
			then 
				dietArray+=("6")
			else
				
				diet=$(cat index.html | grep -A 3 "herbivore</a>" | tail -n1 | sed 's/.*">//' | cut -f1 -d "<" | tr -s " ")

				if [[ ${diet} == "" ]] ||  [[ ${diet} == " " ]]
				then
					dietArray+=("NA")
				elif [[ ${diet} == "frugivore" ]]
				then
					dietArray+=("1")
				elif [[ ${diet} == "granivore" ]]
				then
					dietArray+=("2")
				elif [[ ${diet} == "nectivore" ]]
				then
					dietArray+=("3")
				elif [[ ${diet} == "folivore" ]]
				then
					dietArray+=("4")
				elif [[ ${diet} == "lignivore" ]]
				then
					dietArray+=("5")
				fi
			fi
			
			# Get GestationPeriod

#curl -s h//animaldiversity.org/accounts/Addax_nasomaculatus/ | grep -A 1 "gestation" | tail -n 1 | sed 's/<*dd>//g' | tr -d "</" | awk '{$1=$1};1' | sed 's/[^0-9. ]*//g'| awk '{printf (($1+$2)/2)}'
	
			gestPeriod=$(grep -A 1 "Range gestation period" index.html  | sed -n 2p | sed 's/<*dd>//g' | tr -d "</" | awk '{$1=$1};1')
		
			if [[ $(echo ${gestPeriod} |  grep "to" | wc -l) == 0 ]]
			then
				if [[  $(echo ${gesPeriod} | grep "days" | wc -l) == 1 ]]
				then
					gestArray+=($(echo ${gestPeriod} |  sed 's/[^0-9. ]*//g'))
				elif [[  $(echo ${gesPeriod} | grep "months" | wc -l) == 1 ]]
				then
					months=$(echo ${gestPeriod} |  sed 's/[^0-9. ]*//g')
					gestArray+=(${months}*30.4167)
				fi
			elif [[ $(echo ${gestPeriod} |  grep "to" | wc -l) == 1 ]]
			then
				if [[  $(echo ${gesPeriod} | grep "days" | wc -l) == 1 ]]
				then
					gestArray+=($(echo ${gesPeriod} | sed 's/[^0-9. ]*//g' | awk '{printf (($1+$2)/2)}'))
				elif [[  $(echo ${gesPeriod} | grep "months" | wc -l) == 1 ]]
				then
					monthsRange=$(echo ${gestPeriod} |  sed 's/[^0-9. ]*//g' | awk '{printf (($1+$2)/2)}')
					gestArray+=(${monthsRange}*30.4167)
				fi
			else
				gestArray+=("NA")
			fi
			
			rm index.html
		fi
	fi
done



# Write the newly found species to a txt file
for (( i=0; i<=${#binomArray[@]}; i++ ))
do
	printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" "${eolIDarray[${i}]}" "${binomArray[${i}]}" "${orderArray[${i}]}" "${famArray[${i}]}" "${genusArray[${i}]}" "${speciesArray[${i}]}" "${domArray[${i}]}" "${pantArray1[${i}]}" "${dietArray[${i}]}" "${gestArray[${i}]}" >> ${speciesTXT}

	printf "\n" >> ${speciesTXT}

done

sed -i '$d' ${speciesTXT}
