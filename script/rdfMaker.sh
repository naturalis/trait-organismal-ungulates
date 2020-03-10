#!/bin/bash

## DECLARE
# Declare root
root="/home/zoe/Documents/GitHub/trait-organismal-ungulates/"

# Declare files and arrays
csv=${root}"data/CSV/ungulatesTraits.csv"
temp=${root}"temp.txt"
rdf=${root}"data/RDF/ungulate_traits.ttl"
wilreed=${root}"data/msw3-all.csv"
trait=()
species=()
value=()


## PREFIXES
# Add the prefixes to the rdf file
printf "@prefix species: <https://www.departments.bucknell.edu/biology/resources/msw3/browse.asp?s=y&id=> .\n@prefix trait: <https://github.com/naturalis/trait-organismal-ungulates/blob/master/terms/terms.md#> .\n@prefix pantheria: <http://esapubs.org/archive/ecol/E090/184/metadata.htm> .\n\n" > ${rdf}


## ID FILE
# Get the id, genus, species and subspecies columns from the msw3-all.csv file.
# File found on the Wilson & Reeder's Mammal species of the world site (https://www.departments.bucknell.edu/biology/resources/msw3/)
cat ${wilreed} | tr "," "\t" | awk '{printf $1 "\t" $9 "\t" $11 "\t" $13 "\n"}' | grep "SPECIES" | grep -v "SUBSPECIES" | tr -d "\"" > id.txt


## TRAITS
# Get all the traits and put them in the trait array
head -n 1 ${csv} | tr "," "\n" >> traits.txt

for (( x=1; x<=59; x++ ))
do
	t=$(cat traits.txt | sed -n ${x}p | tr -d "/" | tr "[:upper:]" "[:lower:]")
	trait[${x}]=${t}
done


## SPECIES
# Get names for the species (used later)
awk -F "\"*,\"*" '{print $2}' ${csv} | tail -n +2 >> species.txt

for (( y=1; y<=257; y++ ))
do
	species[${y}]=$(cat species.txt | sed -n ${y}p)
done


## LOOP
# Loop through species to get the values for each one of them
for (( z=1; z<=${#species[@]}; z++ ))
do
	## ID
	# Get the id for the Wilson & Reeder's Mammals species of the world database
	specie1=$(echo ${species[${z}]} | tr "_" " " | awk '{printf $1}')
	specie2=$(echo ${species[${z}]} | tr "_" " " | awk '{printf $2}')
	idSpecie[${z}]=$(cat id.txt | grep "${specie1}" | grep "${specie2}" | awk '{printf $1}')

	
	## VALUES
	# Get the trait values for the right species
	grep "${species[${z}]}" ${csv} | tr "," "\n" > value.txt

	for (( j=1; j<=59; j++ ))
	do
		value[${j}]=$(cat value.txt | sed -n ${j}p | tr "_" " ")
	done
	

	## WRITE
	# Write the values for the species to the txt file
	printf "species:%s trait:eol_id \"%s\" ;\n" "${idSpecie[z]}" "${value[1]}" >> ${temp}

	for (( i=2; i<=${#trait[@]}; i++ ))
	do
		if [[ ${trait[${i}]} =~ ^[[:digit:]] ]]
		then
			printf "\tpantheria:%s \"%s\" ;\n" "${trait[${i}]}" "${value[${i}]}" >> ${temp}
		else
			# Rewrite the values for the traits with non-literal values
			# Development Strategy trait
			if [[ ${trait[${i}]} == "developmentstrategy" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:precocial"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:altricial"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi

			# Diet trait
			elif [[ ${trait[${i}]} == "diet" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:frugivores"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:granivores"
				elif [[ ${value[${i}]} == 3 ]]
				then
					val="trait:nectivores"
				elif [[ ${value[${i}]} == 4 ]]
				then
					val="trait:folivores"
				elif [[ ${value[${i}]} == 5 ]]
				then
					val="trait:lignivores"
				elif [[ ${value[${i}]} == 6 ]]
				then
					val="trait:multiple"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi

			# Domestication trait
			elif [[ ${trait[${i}]} == "domestication" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:domesticated"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:wild"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi
			
			# Horns/Antlers trait
			elif [[ ${trait[${i}]} == "hornsantlers" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:male"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:female"	
				elif [[ ${value[${i}]} == 3 ]]
				then
					val="trait:Both"
				elif [[ ${value[${i}]} == 4 ]]
				then
					val="trait:neither"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi
			
			# Mating System trait
			elif [[ ${trait[${i}]} == "matingsystem" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:monogamy"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:polyandry"	
				elif [[ ${value[${i}]} == 3 ]]
				then
					val="trait:polygyny"
				elif [[ ${value[${i}]} == 4 ]]
				then
					val="trait:polygynandry"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi

			# Motility trait
			elif [[ ${trait[${i}]} == "motility" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:actively-mobile"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:facultatively-mobile"	
				elif [[ ${value[${i}]} == 3 ]]
				then
					val="trait:fast-moving"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi

			# Natural Predators trait
			elif [[ ${trait[${i}]} == "naturalpredators" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:Less-than-3"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:more-than-3"	
				elif [[ ${value[${i}]} == 3 ]]
				then
					val="trait:none"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi

			# Number of Males trait
			elif [[ ${trait[${i}]} == "nummales" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:multiple"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:one"	
				elif [[ ${value[${i}]} == 3 ]]
				then
					val="trait:none"
				elif [[ ${value[${i}]} == 4 ]]
				then
					val="trait:solitary"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"
				fi

			# Parental Care trait
			elif [[ ${trait[${i}]} == "parentalcare" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:care"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:no-care"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"	
				fi

			# Social Hierarchy trait
			elif [[ ${trait[${i}]} == "socialhierarchy" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:hierarchy"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:no-hierarchy"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"	
				fi

			# Sociality trait
			elif [[ ${trait[${i}]} == "sociality" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:solitary-1"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:group"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"	
				fi

			# Year Round Breeding trait
			elif [[ ${trait[${i}]} == "yearroundbreeding" ]]
			then
				if [[ ${value[${i}]} == 1 ]]
				then
					val="trait:year-round"
				elif [[ ${value[${i}]} == 2 ]]
				then
					val="trait:seasonal"
				elif [[ ${value[${i}]} == "NA" ]]
				then
					val="NA"	
				fi

			else
				val=\"${value[${i}]}\"
			fi

			if [[ ${val} == "NA" ]]
			then
				val="NA"
			else
				printf "\ttrait:%s %s ;\n" "${trait[${i}]}" "${val}" >> ${temp}
			fi
		fi
	done

	# Remove traits with NA as value
	sed -i '/"NA"/d' ${temp}

	sed -i '$s/;$//' ${temp}

done

for (( a=1; a<=9005; a++ ))
do
	turtle=$(cat ${temp} | sed -n ${a}p)
		
	if [[ ${turtle: -1} == ";" ]]
	then
		printf "%s\n" "${turtle}" >> ${rdf}
	else
		printf "%s .\n\n" "${turtle::-1}" >> ${rdf}
	fi

done

rm id.txt value.txt species.txt traits.txt ${temp}
