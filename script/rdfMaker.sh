#!/bin/bash

## DECLARE
# Declare files and arrays
csv="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/CSV/ungulatesTraits.csv"
rdf="/home/zoe/Documents/GitHub/trait-organismal-ungulates/data/RDF/ungulate_traits.ttl"
trait=()
species=()
value=()


## PREFIXES
# Add the prefixes to the rdf file
printf "@prefix species: <https://www.departments.bucknell.edu/biology/resources/msw3/browse.asp?s=y&id=> .\n@prefix trait: <https://github.com/naturalis/trait-organismal-ungulates/blob/master/terms/> .\n@prefix pantheria: <http://esapubs.org/archive/ecol/E090/184/metadata.htm> .\n\n" > ${rdf}


## ID FILE
# Get the id, genus, species and subspecies columns from the msw3-all.csv file.
# File found on the Wilson & Reeder's Mammal species of the world site (https://www.departments.bucknell.edu/biology/resources/msw3/)
cat msw3-all.csv | tr "," "\t" | awk '{printf $1 "\t" $9 "\t" $11 "\t" $13 "\n"}' | grep "SPECIES" | grep -v "SUBSPECIES" | tr -d "\"" > id.txt


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
	grep "${species[${z}]}" ${csv} | tr "," "\n" >> value.txt

	for (( j=1; j<=59; j++ ))
	do
		value[${j}]=$(cat value.txt | sed -n ${j}p)
	done
	

	## WRITE
	# Write the values for the species to the txt file
	printf "species:%s trait:eol_id \"%s\" ;\n" "${idSpecie[z]}" "${value[1]}" >> ${rdf}

	for (( i=2; i<${#trait[@]}; i++ ))
	do
		if [[ ${trait[${i}]} =~ ^[[:digit:]] ]]
		then
			printf "\tpantheria:%s \"%s\" ;\n" "${trait[${i}]}" "${value[${i}]}" >> ${rdf}
		else
			printf "\ttrait:%s \"%s\" ;\n" "${trait[${i}]}" "${value[${i}]}" >> ${rdf}
		fi
	done
	
	printf "\ttrait:%s \"%s\" .\n\n" "${trait[-1]}" "${value[-1]}" >> ${rdf}

done

rm id.txt value.txt species.txt traits.txt
