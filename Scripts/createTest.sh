#!/bin/bash


#WERKT NOG NIET
# Laat alleen de eerste met 2 _ zien


for names in ~/Documents/GitHub/trait-organismal-ungulates/Scripts/notFound.txt
do
	length=$(printf ${names} | sed 's/[^_]//g' | awk '{ print length }')
	
	if [[ ${length} -eq 2 ]]
	then
		namesArray+=(${names})
	fi
done

echo ${namesArray[@]}
