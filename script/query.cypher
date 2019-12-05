MATCH (t:Trait)<-[:trait]-(p:Page),
(t)-[:predicate]->(pred:Term)
WHERE p.page_id = 311544 AND pred.uri = "http://purl.obolibrary.org/obo/VT_0001933"
OPTIONAL MATCH (t)-[:units_term]->(units:Term)
RETURN p.canonical, pred.name, t.measurement, units.name
LIMIT 1
