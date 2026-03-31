// 13 CRM queries - run each one separately in Neo4j Browser


// Q1 - all contacts at a company
MATCH (c:Contact)-[r:WORKS_AT]->(co:Company {name: 'Acme Corp'})
RETURN c.name AS Contact, c.title AS Title, c.email AS Email
ORDER BY c.title;


// Q2 - customer 360 view - contacts, deals, and services all in one query
MATCH (co:Company {name: 'Acme Corp'})
OPTIONAL MATCH (co)<-[:WORKS_AT]-(c:Contact)
OPTIONAL MATCH (co)-[:HAS_DEAL]->(d:Deal)
OPTIONAL MATCH (co)-[:USES_SERVICE]->(s:Service)
RETURN co.name AS Company,
       COLLECT(DISTINCT c.name) AS Contacts,
       COLLECT(DISTINCT {deal: d.title, stage: d.stage, value: d.value}) AS Deals,
       COLLECT(DISTINCT s.name) AS Services;


// Q3 - shortest path between two contacts (referral chain)
MATCH (a:Contact {name: 'Alice Johnson'}),
      (b:Contact {name: 'Leo Harris'}),
      p = shortestPath((a)-[:KNOWS*1..8]-(b))
RETURN [n IN nodes(p) | n.name] AS IntroductionChain,
       length(p) AS DegreesOfSeparation;


// Q4 - pipeline breakdown by stage
MATCH (d:Deal)
RETURN d.stage AS Stage,
       COUNT(d) AS Deals,
       SUM(d.value) AS TotalValue,
       ROUND(AVG(d.value)) AS AvgDealSize
ORDER BY TotalValue DESC;


// Q5 - cross-sell: companies using CRM Pro but not Analytics Suite
MATCH (co:Company)-[:USES_SERVICE]->(s1:Service {name: 'CRM Pro'})
WHERE NOT EXISTS {
  MATCH (co)-[:USES_SERVICE]->(:Service {name: 'Analytics Suite'})
}
MATCH (c:Contact)-[:WORKS_AT]->(co)
WHERE c.title IN ['CTO', 'CIO', 'IT Director', 'VP Technology']
RETURN co.name AS Company,
       COLLECT(c.name) AS KeyContacts,
       COLLECT(c.email) AS Emails;


// Q6 - full activity timeline for a deal, most recent first
MATCH (d:Deal {title: 'Enterprise Platform Upgrade'})-[:HAS_ACTIVITY]->(a:Activity)
OPTIONAL MATCH (u:User)-[:LOGGED]->(a)
RETURN a.type AS Type,
       a.date AS Date,
       a.description AS Notes,
       a.duration AS DurationMins,
       u.name AS LoggedBy
ORDER BY a.date DESC;


// Q7 - ERP service dashboard - shows activation status per company
// erp_activation_id is the reference back to the ERP system
MATCH (co:Company)-[r:USES_SERVICE]->(s:Service)
RETURN co.name AS Company,
       s.name AS Service,
       r.status AS Status,
       r.activated_date AS Activated,
       r.renewal_date AS Renewal,
       r.erp_activation_id AS ErpRef,
       CASE
         WHEN r.status = 'suspended' THEN 'SUSPENDED'
         WHEN r.renewal_date < date() THEN 'EXPIRED'
         WHEN r.renewal_date < date() + duration({months:3}) THEN 'EXPIRING SOON'
         ELSE 'ACTIVE'
       END AS Health
ORDER BY co.name, s.name;


// Q8 - high value deals with no recent activity (at risk)
MATCH (co:Company)-[:HAS_DEAL]->(d:Deal)
WHERE d.stage IN ['Proposal', 'Negotiation'] AND d.value > 100000
OPTIONAL MATCH (d)-[:HAS_ACTIVITY]->(a:Activity)
WITH d, co, MAX(a.date) AS LastActivity
WHERE LastActivity IS NULL OR LastActivity < date() - duration({days:30})
RETURN d.title AS Deal,
       d.stage AS Stage,
       d.value AS Value,
       co.name AS Company,
       LastActivity,
       'NEEDS ATTENTION' AS Flag
ORDER BY d.value DESC;


// Q9 - sales rep performance - closed revenue vs pipeline
MATCH (u:User {role:'sales_rep'})<-[:ASSIGNED_TO]-(d:Deal)
RETURN u.name AS SalesRep,
       COUNT(d) AS TotalDeals,
       SUM(CASE WHEN d.stage = 'Closed Won' THEN d.value ELSE 0 END) AS ClosedRevenue,
       SUM(CASE WHEN d.stage = 'Closed Lost' OR d.stage = 'Closed Won' THEN 0 ELSE d.value END) AS PipelineValue,
       COUNT(CASE WHEN d.stage = 'Closed Won' THEN 1 END) AS DealsWon
ORDER BY ClosedRevenue DESC;


// Q10 - contacts not linked to any company (data quality / GDPR audit)
MATCH (c:Contact)
WHERE NOT EXISTS { MATCH (c)-[:WORKS_AT]->(:Company) }
RETURN c.name AS Contact,
       c.email AS Email,
       c.gdpr_consent AS ConsentGiven,
       c.created_date AS Created,
       'MISSING COMPANY LINK' AS Issue
ORDER BY c.created_date DESC;

// Q11 - shortest path visualization (graph view)
MATCH (a:Contact {name: 'Alice Johnson'}),
      (b:Contact {name: 'Leo Harris'}),
      p = shortestPath((a)-[:KNOWS*1..8]-(b))
RETURN p;

// Q12 - graph stats overview using APOC
CALL apoc.meta.stats()
YIELD labels, relTypesCount, propertyKeyCount
RETURN labels, relTypesCount, propertyKeyCount;

// Q13 - ERP service catalog with supplier info
MATCH (s:Service)
RETURN s.name AS Service,
       s.erp_service_id AS ErpId,
       s.supplier_name AS Supplier,
       s.product_status AS Status,
       s.monthly_cost AS MonthlyCost,
       s.last_erp_sync AS LastSync
ORDER BY s.category;