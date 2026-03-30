// RBAC security setup
// note: role privileges need Neo4j Enterprise or Neo4j Desktop
// Community Edition only supports basic username/password auth
// Neo4j Desktop (free dev licence) was used for testing

// create users
CREATE USER crm_admin    SET PASSWORD 'Admin2026!'    SET PASSWORD CHANGE NOT REQUIRED;
CREATE USER crm_manager  SET PASSWORD 'Manager2026!'  SET PASSWORD CHANGE NOT REQUIRED;
CREATE USER crm_rep      SET PASSWORD 'SalesRep2026!' SET PASSWORD CHANGE NOT REQUIRED;
CREATE USER crm_readonly SET PASSWORD 'ReadOnly2026!' SET PASSWORD CHANGE NOT REQUIRED;

// create roles
CREATE ROLE crm_admin_role;
CREATE ROLE crm_manager_role;
CREATE ROLE crm_rep_role;
CREATE ROLE crm_readonly_role;

// admin - full access to everything
GRANT ALL ON DATABASE neo4j TO crm_admin_role;
GRANT MATCH {*} ON GRAPH neo4j TO crm_admin_role;
GRANT WRITE ON GRAPH neo4j TO crm_admin_role;

// sales manager - can read everything, write to CRM nodes, can't touch Service nodes (ERP-owned)
GRANT MATCH {*} ON GRAPH neo4j TO crm_manager_role;
GRANT CREATE ON GRAPH neo4j NODES Contact, Deal, Activity TO crm_manager_role;
GRANT SET PROPERTY {*} ON GRAPH neo4j NODES Contact, Deal, Activity TO crm_manager_role;
GRANT CREATE ON GRAPH neo4j RELATIONSHIP * TO crm_manager_role;
DENY SET PROPERTY {*} ON GRAPH neo4j NODES Service TO crm_manager_role;
DENY DELETE ON GRAPH neo4j TO crm_manager_role;

// sales rep - limited to logging activities and basic contact updates
GRANT MATCH {*} ON GRAPH neo4j TO crm_rep_role;
GRANT CREATE ON GRAPH neo4j NODES Activity TO crm_rep_role;
GRANT SET PROPERTY {*} ON GRAPH neo4j NODES Activity TO crm_rep_role;
DENY SET PROPERTY {*} ON GRAPH neo4j NODES Service, User TO crm_rep_role;
DENY DELETE ON GRAPH neo4j TO crm_rep_role;

// read only - for analysts, BI tools etc
GRANT MATCH {*} ON GRAPH neo4j TO crm_readonly_role;
DENY WRITE ON GRAPH neo4j TO crm_readonly_role;

// assign roles to users
GRANT ROLE crm_admin_role    TO crm_admin;
GRANT ROLE crm_manager_role  TO crm_manager;
GRANT ROLE crm_rep_role      TO crm_rep;
GRANT ROLE crm_readonly_role TO crm_readonly;

// verify
SHOW USERS;
SHOW ROLES;


// GDPR right-to-erasure
// DETACH DELETE removes the contact node and all its relationships
// run with the contact's email as a parameter

// MATCH (c:Contact {email: $email})
// DETACH DELETE c;

// check for contacts missing consent
MATCH (c:Contact)
WHERE c.gdpr_consent = false OR c.gdpr_consent IS NULL
RETURN c.name AS Contact, c.email AS Email, 'CONSENT MISSING' AS Flag;
