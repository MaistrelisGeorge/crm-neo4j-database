// constraints and indexes - run this first before loading any data

// unique constraints to prevent duplicate nodes
CREATE CONSTRAINT contact_email IF NOT EXISTS
  FOR (c:Contact) REQUIRE c.email IS UNIQUE;

CREATE CONSTRAINT company_erp_id IF NOT EXISTS
  FOR (co:Company) REQUIRE co.erp_id IS UNIQUE;

CREATE CONSTRAINT deal_id IF NOT EXISTS
  FOR (d:Deal) REQUIRE d.deal_id IS UNIQUE;

// erp_service_id is the foreign key reference back to the ERP system
CREATE CONSTRAINT service_erp_id IF NOT EXISTS
  FOR (s:Service) REQUIRE s.erp_service_id IS UNIQUE;

CREATE CONSTRAINT user_email IF NOT EXISTS
  FOR (u:User) REQUIRE u.email IS UNIQUE;

CREATE CONSTRAINT activity_id IF NOT EXISTS
  FOR (a:Activity) REQUIRE a.activity_id IS UNIQUE;

// indexes on fields we filter by most often
CREATE INDEX idx_contact_name IF NOT EXISTS FOR (c:Contact) ON (c.name);
CREATE INDEX idx_company_industry IF NOT EXISTS FOR (co:Company) ON (co.industry);
CREATE INDEX idx_deal_stage IF NOT EXISTS FOR (d:Deal) ON (d.stage);
CREATE INDEX idx_deal_value IF NOT EXISTS FOR (d:Deal) ON (d.value);
CREATE INDEX idx_service_status IF NOT EXISTS FOR (s:Service) ON (s.status);
CREATE INDEX idx_activity_type IF NOT EXISTS FOR (a:Activity) ON (a.type);
CREATE INDEX idx_activity_date IF NOT EXISTS FOR (a:Activity) ON (a.date);

// to verify: SHOW CONSTRAINTS; SHOW INDEXES;
