####
# This is the script for storing the schema of your TerminusDB
# database for your project.
# Use 'terminusdb commit' to commit changes to the database and
# use 'terminusdb sync' to change this file according to
# the exsisting database schema
####
from typing import Optional

from terminusdb_client.woqlschema import (
    DocumentTemplate,
)


class UngulatesTraits(DocumentTemplate):
    avgbodymass: Optional[float]
    avgfoodconsumption: Optional[float]
    avgmovingspeed: Optional[float]
    avgtraveldistance: Optional[float]
    binomialname: Optional[str]
    breedinginterval: Optional[float]
    canonicalname: Optional[str]
    carryweight: Optional[float]
    developmentstrategy: Optional[float]
    diet: Optional[float]
    domestication: Optional[int]
    family: Optional[str]
    genus: Optional[str]
    headornaments: Optional[float]
    id_eol: Optional[int]
    lifespan: Optional[float]
    matingsystem: Optional[float]
    maturityreachfemale: Optional[float]
    maturityreachmale: Optional[float]
    motility: Optional[float]
    naturalpredators: Optional[float]
    nummales: Optional[float]
    numoffspring: Optional[float]
    order: Optional[str]
    parentalcare: Optional[float]
    pullstrength: Optional[float]
    socialhierarchy: Optional[float]
    sociality: Optional[float]
    species: Optional[str]
    x10_1_populationgrpsize: Optional[float]
    x10_2_socialgrpsize: Optional[float]
    x12_1_habitatbreadth: Optional[float]
    x12_2_terrestriality: Optional[float]
    x13_1_adultheadbodylen_mm: Optional[float]
    x13_2_neonateheadbodylen_mm: Optional[float]
    x13_3_weaningheadbodylen_mm: Optional[float]
    x14_1_interbirthinterval_d: Optional[float]
    x15_1_littersize: Optional[float]
    x16_1_littersperyear: Optional[float]
    x17_1_maxlongevity_m: Optional[float]
    x18_1_basalmetrate_mlo2hr: Optional[float]
    x1_1_activitycycle: Optional[float]
    x21_1_populationdensity_n_km2: Optional[float]
    x22_1_homerange_km2: Optional[float]
    x22_2_homerange_indiv_km2: Optional[float]
    x23_1_sexualmaturityage_d: Optional[float]
    x24_1_teatnumber: Optional[float]
    x25_1_weaningage_d: Optional[float]
    x2_1_ageateyeopening_d: Optional[float]
    x3_1_ageatfirstbirth_d: Optional[float]
    x5_1_adultbodymass_g: Optional[float]
    x5_2_basalmetratemass_g: Optional[float]
    x5_3_neonatebodymass_g: Optional[float]
    x5_4_weaningbodymass_g: Optional[float]
    x6_1_dietbreadth: Optional[float]
    x6_2_trophiclevel: Optional[float]
    x7_1_dispersalage_d: Optional[float]
    x8_1_adultforearmlen_mm: Optional[float]
    x9_1_gestationlen_d: Optional[float]
    yearroundbreeding: Optional[float]
