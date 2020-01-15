#!/bin/bash

# DOCUMENTATION ABOUT CHANGING PATHS TO OWN DIRECTORIES
## Need Python2

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
avgfoodArray=()		#NOGNIET
socArray=()
hierArray=()
maleArray=()		#NOGNIET
maturemArray=()
maturefArray=()
matingArray=()
litterArray=()
breedintArray=()
yearbreedArray=()
weightArray=()
parcareArray=()
devstratArray=()
hornsArray=()		#NOGNIET
speedArray=()		#NOGNIET
lifeArray=()
activeArray=()		#NOGNIET
predArray=()		#NOGNIET
motilArray=()
carryArray=()		#NOGNIET
pullArray=()		#NOGNIET
movespeedArray=()	#NOGNIET
travdistArray=()	#NOGNIET
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
		curl -o indexADW.html https://animaldiversity.org/accounts/${species}/
		curl -o indexEOL.html https://eol.org/pages/${eol}/data
		url=$(curl -Ls -w %{url_effective} https://animaldiversity.org/accounts/${species}/ | tail -n1 | sed 's/<.*>//g' | awk '{$1=$1};1')

		if [[ ${url} == "https://animaldiversity.org/accounts/${species}/classification/" ]]
		then
			dietArray+=("NA")
			gestArray+=("NA")
			socArray+=("NA")
			hierArray+=("NA")
			maturemArray+=("NA")
			maturefArray+=("NA")
			
		else
			## Get Diet
			# When there are multiple kinds of food the species eats, add category 6
			# Else: add other category (1 - 5)
			dietCount=$(cat indexADW.html | grep -A 10 "herbivore</a>" | grep .*vore | wc -l)
			if [[ ${dietCount} -gt "2" ]]
			then 
				dietArray+=("6")
			else
				
				diet=$(cat indexADW.html | grep -A 3 "herbivore</a>" | tail -n1 | sed 's/.*">//' | cut -f1 -d "<" | tr -s " ")

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
			
			## Get GestationPeriod
			# Check if the gestPeriod contains a range, by checking if it contains 'to'
			# If not, check if the unit is Days or Months 
			# If days: add number of days to the Array. If months: multiply by 30.4167 and add the outcome to the Array.
			#
			# If the gestPeriod contains a range, calculate the mean. After that, check if the unit is Days or Months
			# If Days: add number of days to the Array. If months: multiply by 30.4167 and add the outcome to the Array.
			
			gestPeriod=$(grep -A 1 "gestation period<" indexADW.html | sed -n 2p | sed 's/<*dd>//g' | tr -d "</" | awk '{$1=$1};1')

			if [[ $(echo ${gestPeriod} |  grep "to" | wc -l) == 0 ]]
			then
				if [[  $(echo ${gestPeriod} | grep "days" | wc -l) == 1 ]]
				then
					gestDay=$(echo ${gestPeriod} |  sed 's/[^0-9. ]*//g')
					gestArray+=("${gestDay}")
				elif [[  $(echo ${gestPeriod} | grep "months" | wc -l) == 1 ]]
				then
					months=$(echo ${gestPeriod} |  sed 's/[^0-9. ]*//g')
					gestDays=$(echo "${months}*30.4167" | bc)
					gestArray+=("${gestDays}")
				else
					gestArray+=("NA")
				fi

			elif [[ $(echo ${gestPeriod} |  grep "to" | wc -l) == 1 ]]
			then
				if [[  $(echo ${gestPeriod} | grep "days" | wc -l) == 1 ]]
				then
					gestDay2=$(echo ${gestPeriod} | sed 's/[^0-9. ]*//g' | awk '{printf (($1+$2)/2)}')
					gestArray+=("${gestDay2}")
				elif [[  $(echo ${gestPeriod} | grep "months" | wc -l) == 1 ]]
				then
					monthsRange=$(echo ${gestPeriod} |  sed 's/[^0-9. ]*//g' | awk '{printf (($1+$2)/2)}')
					gestDays2=$(echo "${monthsRange}*30.4167" | bc)
					gestArray+=("${gestDays2}")
				else
					gestArray+=("NA")
				fi

			else
				gestArray+=("NA")
			fi
			
			## Get Sociality
			# Code for Solitary on ADW database: 	#20020904145381
			# Code for Groups on ADW database: 	#20020904145492
			# Grep the indexADW.html for the different codes per species. 
			# Add 1 to Array if the species is solitary, add 2 if they live in groups.
			# Add NA if the data isn't available for the species.

			if [[ $(grep "#20020904145381" indexADW.html| wc -l) == 1  ]]
			then
				socArray+=("1")
			elif [[ $(grep "#20020904145492" indexADW.html | wc -l) == 1 ]]
			then
				socArray+=("2")
			else
				socArray+=("NA")
			fi
			
			## Get Social Hierarchy
			# Code for Dominance Hierarchy:		#20020904145738
			
			if [[ $(grep "#20020904145738" indexADW.html | wc -l) == 1  ]]
			then
				hierArray+=("1")
			else
				hierArray+=("2")
			fi
			
			## Get MaturityReach (Male and Female)
			if [[ $(grep "reproductive maturity (female)" indexADW.html | wc -l) == 1 ]] || [[ $(grep "reproductive maturity (female)" indexADW.html | wc -l) == 2 ]]
			then
				matf=$(grep -A 1 "reproductive maturity (female)" indexADW.html | grep "</dd>" | sed 's/<*dd>//g' | tr -d "</" | awk '{$1=$1};1')
				if [[ $(echo ${matf} | grep "to"  | wc -l) == 1 ]] || [[ $(echo ${matf} | grep "-" | wc -l) == 1 ]]
				then
					if [[ $(echo ${matf} | grep "years" | wc -l) == 1 ]]
					then
						matf=$(echo ${matf} | sed 's/-/ to /g')
						matfmean=$(echo ${matf} | awk '{printf (($1+$3)/2)}')
						matfmonths=$(echo "${matfmean}*12" | bc)
					elif [[ $(echo ${matf} | grep "months" | wc -l) == 1 ]]
					then
						matf=$(echo ${matf} | sed 's/-/ to /g')
						matfmean=$(echo ${matf} | awk '{printf (($1+$3)/2)}')
						matfmonths=${matfmean}
					elif [[ $(echo ${matf} | grep "days" | wc -l) == 1 ]]
					then
						matf=$(echo ${matf} | sed 's/-/ to /g' | tr -d ",")
						matfmean=$(echo ${matf} | awk '{printf (($1+$3)/2)}')
						matfmonths=$(echo "print ${matfmean}/30.4167" | python2)
					else
						matfmonths=("NA")
					fi
				elif [[ $(echo ${matf} | grep "to" | wc -l) == 0 ]]
				then
					if [[ $(echo ${matf} | grep "years" | wc -l) == 1 ]]
					then
						matfyear=$(echo ${matf} | awk '{printf $1}')
						matfmonths=$(echo "${matfyear}*12" | bc)
					elif [[ $(echo ${matf} | grep "months" | wc -l) == 1 ]]
					then
						matfmonths=$(echo ${matf} | awk '{printf $1}')
					elif [[ $(echo ${matf} | grep "days" | wc -l) == 1 ]]
					then
						matfdays=$(echo ${matf} | awk '{printf $1}' | tr -d ",")
						matfmonths=$(echo "print ${matfdays}/30.4167" | python2)
					else
						matfmonths=$("NA")
					fi
				fi
				maturefArray+=("${matfmonths}")
			else
				maturefArray+=("NA")
			fi

			if [[ $(grep "reproductive maturity (male)" indexADW.html | wc -l) == 1 ]] || [[ $(grep "reproductive maturity (male)" indexADW.html | wc -l) == 2 ]]
			then
				matm=$(grep -A 1 "reproductive maturity (male)" indexADW.html| grep "</dd>" | sed 's/<*dd>//g' | tr -d "</" | awk '{$1=$1};1')
				if [[ $(echo ${matm} | grep "to" | wc -l) == 1 ]] || [[ $(echo ${matm} | grep "-" | wc -l) == 1 ]]
				then
					if [[ $(echo ${matm} | grep "years" | wc -l) == 1 ]]
					then
						matm=$(echo ${matm} | sed 's/-/ to /g')
						matmmean=$(echo ${matm} | awk '{printf (($1+$3)/2)}')
						matmmonths=$(echo "${matmmean}*12" | bc)
					elif [[ $(echo ${matm} | grep "months" | wc -l) == 1 ]]
					then
						matm=$(echo ${matm} | sed 's/-/ to /g')
						matmmean=$(echo ${matm} | awk '{printf (($1+$3)/2)}')
						matmmonths=${matmmean}
					elif [[ $(echo ${matm} | grep "days" | wc -l) == 1 ]]
					then
						matm=$(echo ${matm} | sed 's/-/ to /g' | tr -d ",")
						matmmean=$(echo ${matm} | awk '{printf (($1+$3)/2)}')
						matmmonths=$(echo "print ${matmmean}/30.4167" | python2)
					else
						matmmonths=("NA")
					fi
				elif [[ $(echo ${matm} | grep "to" | wc -l) == 0 ]]
				then
					if [[ $(echo ${matm} | grep "years" | wc -l) == 1 ]]
					then
						matmyear=$(echo ${matm} | awk '{printf $1}')
						matmmonths=$(echo "${matmyear}*12" | bc)
					elif [[ $(echo ${matm} | grep "months" | wc -l) == 1 ]]
					then
						matmmonths=$(echo ${matm} | awk '{printf $1}')
					elif [[ $(echo ${matm} | grep "days" | wc -l) == 1 ]]
					then
						matmdays=$(echo ${matm} | awk '{printf $1}' | tr -d ",")
						matmmonths=$(echo "print ${matmdays}/30.4167" | python2)
					else
						matmmonths=$("NA")
					fi
				fi
				maturemArray+=("${matmmonths}")
			else
				maturemArray+=("NA")
			fi
			
			## Get MatingSystem
			# Monogamy (1), polyandry (2), polygyny (3) and polygynandry (4)
			if [[ $(grep "#20020904145332" indexADW.html | wc -l) == 1 ]]
			then
				matingArray+=("1")
			elif [[ $(grep "#20020904145372" indexADW.html | wc -l) == 1 ]]
			then
				matingArray+=("2")
			elif [[ $(grep "#20020904145840" indexADW.html | wc -l) == 1 ]]
			then
				matingArray+=("3")
			elif [[ $(grep "#20020904145483" indexADW.html | wc -l) == 1 ]]
			then
				matingArray+=("4")

			else
				matingArray+=("NA")
			fi
			
			## Get Litter size
			# Amount of litter per pregnancy from the EoL database
			if [[ $(grep -m 1 "clutch/brood/litter size</div>" indexEOL.html | wc -l) == 1 ]]
			then
				littersize=$(grep -m 1 -A 15 "clutch/brood/litter size</div>" indexEOL.html | grep -A 1 "trait-val" | tail -n 1)
			else
				littersize=("NA")
			fi

			litterArray+=("${littersize}")
			
			## Get Breeding Interval
			# From EoL
			if [[ $(grep "inter-birth interval</div>" indexEOL.html | wc -l) -ge 1 ]]
			then
				
				if [[ $(grep -B 3  "inter-birth interval</div>" indexEOL.html | grep "AnAge" | wc -l) == 1 ]]
				then
					birthInt=$(grep -B 3 -A 11 "inter-birth interval</div>" indexEOL.html | grep -A 14 "AnAge" | tail -n 1)
				else
					birthInt=$(grep -m 1 -A 11 "inter-birth interval</div>" indexEOL.html | tail -n 1)
				fi
				
				avgBirthint=$(echo ${birthInt} | sed 's/[^0-9]*//g')
				breedintArray+=("${avgBirthint}")		
			else
				breedintArray+=("NA")
			fi
		
			## Get Year Round Breeding
			# Code for year round on ADW database: 	#20020904145698
			# Code for seasonal on ADW database: 	#20020904145584
			# Grep the indexADW.html for the different codes per species. 
			# Add 1 to Array if the species breeds all year, add 2 if they only breed seasonal.
			# Add NA if the data isn't available for the species.
			if [[ $(grep "#20020904145698" indexADW.html | wc -l) == 1 ]]
			then
				yearbreedArray+=("1")

			elif [[ $(grep "#20020904145584" indexADW.html | wc -l) == 1 ]]
			then
				yearbreedArray+=("2")
			
			else
				yearbreedArray+=("NA")
			fi

			## Get Mature Weight
			# The amount of grams a mature animal of the species weighs from the EoL database.
			if [[ $(grep -A 16 "weight</div" indexEOL.html | grep "(adult)" | wc -l) == 1 ]]
			then
				weightGrams=$(grep -A 16 "weight</div" indexEOL.html | grep -B 2 "(adult)" | head -n 1 | sed 's/[^0-9]*//g')
				weightArray+=("${weightGrams}")
			else
				weightArray+=("NA")
			fi

			## Get Parental Care
			# Whether the parents of the offspring care for their litter from the EoL database.
			# Add 1 to Array if the species care for their offspring, add 2 if they don't.
			# Add NA if the data isn't available for the species. 
			if [[ $(grep "parental care</div>" indexEOL.html | wc -l) == 1 ]]
			then
				if [[ $(grep -A 13 "parental care</div>" indexEOL.html | grep "No Paternal Care" | wc -l) == 1 ]]
				then
					parcareArray+=("2")
				else
					test=$(grep -A 13 "parental care</div>" indexEOL.html | tail -n 1)
					parcareArray+=("${test}")
				fi
			else
				parcareArray+=("NA")
			fi
			
			## Get Development Strategy
			# Code for altricial in the AWD database:	#20020904145328
			# Code for precocial in the AWD database: 	#20020904145398
			# Grep the indexADW.html for the different codes per species. 
			# Add 1 to Array if the species is considered precocial, add 2 if it's altricial.
			# Add NA if the data isn't available for the species.
			if [[ $(grep "#20020904145398" indexADW.html  | wc -l) == 1 ]]
			then
				devstratArray+=("1")
			elif [[ $(grep "#20020904145328" indexADW.html  | wc -l) == 1 ]]
			then
				devstratArray+=("2")
			else
				devstratArray+=("NA")
			fi

			## Get lifespan in years
			# From the EoL database
			if [[ $(grep -m 1 "life span</div>" indexEOL.html | wc -l) == 1 ]]
			then
				if [[ $(grep -m 1 -A 14 "life span</div>" indexEOL.html | tail -n 1 | grep "months" | wc -l) == 1 ]]
				then
					lifeMonths=$(grep -m 1 -A 14 "life span</div>" indexEOL.html | tail -n 1 | sed 's/[^0-9]*//g')
					lifeYears=$(echo "print ${lifeMonths}/12" | python2)
				elif [[ $(grep -m 1 -A 14  "life span</div>" indexEOL.html | tail -n 1 | grep "years" | wc -l) == 1 ]]
				then
					lifeYears=$(grep -m 1 -A 14 "life span</div>" indexEOL.html | tail -n 1 | sed 's/[^0-9]*//g')
				elif [[ $(grep -m 1 -A 14  "life span</div>" indexEOL.html | tail -n 1 | grep "days" | wc -l) == 1 ]]
				then
					lifeDays=$(grep -m 1 -A 14 "life span</div>" indexEOL.html | tail -n 1 | sed 's/[^0-9]*//g')
					lifeYears=$(echo "print ${lifeDays}/365" | python2)
				fi
				lifeArray+=("${lifeYears}")			
			else
				lifeArray+=("NA")
			fi

			## Get Motility
			# From EoL
			if [[ $(grep -m 1 "motility</div>" indexEOL.html | wc -l) == 1 ]]
			then
				motility=$(grep -m 1 -A 12 "motility</div>" indexEOL.html | tail -n 1 | awk '{$1=$1};1')
				if [[ ${motility} == "actively mobile" ]]
				then
					motilArray+=("1")
				elif [[ ${motility} == "facultatively mobile" ]]
				then
					motilArray+=("2")
				elif [[ ${motility} == "fast moving" ]]
				then
					motilArray+=("3")
				fi
			else
				motilArray+=("NA")
			fi
		fi
		rm indexADW.html
		rm indexEOL.html
	fi
done

# Write the newly found species to a txt file
for (( i=0; i<=${#binomArray[@]}; i++ ))
do
	printf "%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s" "${eolIDarray[${i}]}" "${binomArray[${i}]}" "${orderArray[${i}]}" "${famArray[${i}]}" "${genusArray[${i}]}" "${speciesArray[${i}]}" "${domArray[${i}]}" "${pantArray1[${i}]}" "${dietArray[${i}]}" "${gestArray[${i}]}" "${avgfoodArray[${i}]}" "${socArray[${i}]}" "${hierArray[${i}]}" "${maleArray[${i}]}" "${maturemArray[${i}]}" "${maturefArray[${i}]}" "${matingArray[${i}]}" "${litterArray[${i}]}" "${breedintArray[${i}]}" "${yearbreedArray[${i}]}" "${weightArray[${i}]}" "${parcareArray[${i}]}" "${devstratArray[${i}]}" "${hornsArray[${i}]}" "${speedArray[${i}]}" "${lifeArray[${i}]}" "${activeArray[${i}]}" "${predArray[${i}]}" "${motilArray[${i}]}" >> ${speciesTXT} 

	printf "\n"  >> ${speciesTXT}

done

sed -i '$d' ${speciesTXT}
