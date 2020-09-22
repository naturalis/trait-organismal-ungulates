# RDF data files
The RDF folder contains the ungulate trait data using both Turtle and XML syntax, and a visualized part of the RDF as an example.

- [Trait data - Turtle](ungulate_traits.ttl)
- [Trait data - XML](ungulate_traits.xml)
- [Visualized RDF part](Elaphodus_cephalophus_RDF.png)

The data set was transformed into an RDF data set, expressed in Turtle syntax. Due to the dataset containing hundreds of species,
[a bash script](trait-organismal-ungulates/script/rdfMaker.sh) was used to create the RDF. The subjects are the species, and 
the URIs used for this are from _Wilson & Reeder’s Mammal species of the world_. The predicates are the traits, for which the URIs are
different per trait. For the taxonomy and PanTHERIA traits, the PanTHERIA URIs are used. These URIs were collected from the EoL database, 
which contains URIs for all kinds of definitions. The URIs for the different traits can be found in the 
[definition file](https://github.com/naturalis/trait-organismal-ungulates/blob/master/script/rdfMaker.sh) in the data folder.

The Turtle trait data was converted to XML format using the EasyRDF converter, after which the XML trait data was validated 
using the online validation service of the W3C. The online validation service also visualized the RDF part.
