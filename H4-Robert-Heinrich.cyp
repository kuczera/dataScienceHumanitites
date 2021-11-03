// 1 - Robert II. von Flandern
MATCH (n:IndexPerson)
WHERE n.xmlId = 'RI003-002-P02526'
RETURN *;

// 2 - Robert II. von Flandern mit Netzwerk
MATCH (n:IndexPerson)-[:PERSON_IN]->(r:Regesta)<-[:PERSON_IN]-
(m:IndexPerson)
WHERE n.xmlId = 'RI003-002-P02526'
RETURN *;

// 3 - Robert II. von Flandern und Herzog Heinrich von Niederlothringen
MATCH
(n:IndexPerson)-[:PERSON_IN]->
(r:Regesta)<-[:PERSON_IN]-(m:IndexPerson)
WHERE n.xmlId = 'RI003-002-P02526'
AND m.xmlId = 'RI003-002-P01291'
RETURN *;

// 4 - Robert und Heinrich mit gemeinsamen Bekannten
MATCH (n0:IndexPerson)-->(r1:Regesta)--(n:IndexPerson)
MATCH (m:IndexPerson)--(r2:Regesta)--(n3:IndexPerson)
WHERE n.xmlId = 'RI003-002-P02526'
AND m.xmlId = 'RI003-002-P01291'
RETURN *;

// 5 - Bekannten Graph
MATCH
(startPerson:IndexPerson)-[:PERSON_IN]->
(regest:Regesta)<-[:PERSON_IN]-(endPerson:IndexPerson)
WHERE startPerson.xmlId in ['RI003-002-P02526', 'RI003-002-P01291']
AND startPerson.xmlId <> endPerson.xmlId
WITH startPerson, endPerson, count(regest) as anzahl,
collect(distinct(regest.identifier)) as idents
CALL apoc.create.vRelationship(startPerson, "APPEARS_WITH",
{anzahl:anzahl, regesten:idents}, endPerson) YIELD rel
RETURN startPerson, endPerson, rel;

// 6 - Bekannten Tabelle
MATCH
(startPerson:IndexPerson)-[:PERSON_IN]->
(regest1:Regesta)<-[:PERSON_IN]-(middlePerson:IndexPerson)
-[:PERSON_IN]->(regest2:Regesta)<-[:PERSON_IN]-(endPerson:IndexPerson)
WHERE startPerson.xmlId in ['RI003-002-P01291']
AND endPerson.xmlId in ['RI003-002-P02526']
AND startPerson.xmlId <> endPerson.xmlId
RETURN DISTINCT startPerson.name1, regest1.identifier, regest1.summary,
middlePerson.name1, regest2.identifier, regest2.summary, endPerson.name1;

// Robert II. von Flandern mit Regesten und weiteren Entitäten
MATCH (n:IndexPerson)-[:PERSON_IN]->(r)--(e)
WHERE n.xmlId = 'RI003-002-P02526'
RETURN *;
