# CRM Database - Neo4j Implementation

Advanced Database SWE6008 - Assessment 002  
Topic 2: Database for a CRM System  
George Maistrelis | Student ID: 2331873

---

## Overview

Graph database implementation of a B2B CRM system using Neo4j. The ERP system is the master of Services, the CRM holds reference copies and tracks per-customer activation state on the relationship.

CRM data is naturally graph-shaped, contacts know contacts, companies own deals, services are subscribed per customer. Neo4j models this directly without needing join tables.

## Data Model

```
(Contact)-[:WORKS_AT]->(Company)
(Contact)-[:INVOLVED_IN {role}]->(Deal)
(Contact)-[:KNOWS {context}]->(Contact)
(Company)-[:HAS_DEAL]->(Deal)
(Company)-[:USES_SERVICE {status, erp_activation_id}]->(Service)
(Deal)-[:ASSIGNED_TO]->(User)
(Deal)-[:HAS_ACTIVITY]->(Activity)
(User)-[:LOGGED]->(Activity)
```

## ERP Integration

The ERP is the master of Services. Neo4j stores:
- `Service.erp_service_id` - foreign reference to ERP master record
- `USES_SERVICE.status` - per-customer activation state (active/suspended)
- `USES_SERVICE.erp_activation_id` - foreign reference to ERP activation record

When the ERP suspends a service it updates `USES_SERVICE.status` on the relevant relationship.

## Dataset

| Node | Count |
|------|-------|
| Company | 25 |
| Contact | 55 |
| Deal | 35 |
| Service | 12 |
| User | 6 |
| Activity | 10 |

## Setup

Requirements: Docker Desktop

```bash
docker-compose up -d
```

Open http://localhost:7474 — login: `neo4j` / `CrmSecure2026!`

Run the scripts in order in Neo4j Browser:

| File | What it does |
|------|-------------|
| 01_constraints_indexes.cypher | Schema setup |
| 02_services_users_companies.cypher | Services (ERP), Users, Companies |
| 03_contacts.cypher | 55 Contacts + WORKS_AT |
| 04_deals.cypher | 35 Deals + ASSIGNED_TO + INVOLVED_IN |
| 05_relationships_activities.cypher | USES_SERVICE, Activities, KNOWS |
| 06_queries.cypher | 12 CRM queries |
| 07_security_rbac.cypher | RBAC (requires Enterprise Edition or Desktop Edition, based on Neo4j docs - not deployable on Community Edition on Docker, tested locally on Desktop Edition) |

Verify data loaded correctly:
```cypher
MATCH (n) RETURN labels(n)[0] AS Label, count(n) AS Count ORDER BY Label;
```

## Technologies

- Neo4j 5
- Cypher (graph query language)
- Docker
- APOC plugin (graph metadata and advanced procedures)