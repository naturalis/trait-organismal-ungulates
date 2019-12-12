#!/bin/bash

"""
Doesn't  work yet, can't figure out how to loop through the IDs and give them to the query as parameters/variables
"""

#id=311544
#uri=http://eol.org/schema/terms/AgeAtEyeOpening
# python3 cypher.py --tokenfile=api.token --queryfile=query.cypher

wget -O cypher.out --header "Authorization: JWT `cat api.token`" https://eol.org/service/cypher?query="`cat query.cypher`"

