// services - ERP is the master, Neo4j just holds reference copies
// erp_service_id links back to the ERP system record
// last_synced tracks when we last pulled data from ERP

UNWIND [
  {name:'CRM Pro', category:'CRM', monthly_cost:1500, erp_service_id:'ERP-SVC-001', status:'active'},
  {name:'Analytics Suite', category:'Analytics', monthly_cost:2500, erp_service_id:'ERP-SVC-002', status:'active'},
  {name:'Marketing Automation', category:'Marketing', monthly_cost:2000, erp_service_id:'ERP-SVC-003', status:'active'},
  {name:'Help Desk Pro', category:'Support', monthly_cost:800, erp_service_id:'ERP-SVC-004', status:'active'},
  {name:'E-Commerce Platform', category:'Commerce', monthly_cost:3500, erp_service_id:'ERP-SVC-005', status:'active'},
  {name:'Data Warehouse', category:'Analytics', monthly_cost:4000, erp_service_id:'ERP-SVC-006', status:'active'},
  {name:'Security Shield', category:'Security', monthly_cost:1200, erp_service_id:'ERP-SVC-007', status:'active'},
  {name:'Cloud Backup', category:'Infrastructure', monthly_cost:600, erp_service_id:'ERP-SVC-008', status:'active'},
  {name:'API Gateway', category:'Integration', monthly_cost:900, erp_service_id:'ERP-SVC-009', status:'active'},
  {name:'Document Management', category:'Productivity', monthly_cost:500, erp_service_id:'ERP-SVC-010', status:'active'},
  {name:'Legacy ERP Connector', category:'Integration', monthly_cost:1800, erp_service_id:'ERP-SVC-011', status:'deprecated'},
  {name:'AI Assistant', category:'AI', monthly_cost:3000, erp_service_id:'ERP-SVC-012', status:'active'}
] AS row
CREATE (s:Service)
SET s = row, s.last_synced = datetime();

// add ERP supplier info to service nodes
MATCH (s:Service)
SET s.supplier_name = CASE s.erp_service_id
  WHEN 'ERP-SVC-001' THEN 'SalesCloud Ltd'
  WHEN 'ERP-SVC-002' THEN 'DataViz Corp'
  WHEN 'ERP-SVC-003' THEN 'MarketPro Inc'
  WHEN 'ERP-SVC-004' THEN 'SupportDesk Ltd'
  WHEN 'ERP-SVC-005' THEN 'CommerceHub Ltd'
  WHEN 'ERP-SVC-006' THEN 'DataViz Corp'
  WHEN 'ERP-SVC-007' THEN 'SecureNet Ltd'
  WHEN 'ERP-SVC-008' THEN 'CloudStore Inc'
  WHEN 'ERP-SVC-009' THEN 'IntegrationHub Ltd'
  WHEN 'ERP-SVC-010' THEN 'DocFlow Ltd'
  WHEN 'ERP-SVC-011' THEN 'LegacyBridge Ltd'
  WHEN 'ERP-SVC-012' THEN 'AILabs Corp'
  END,
s.product_status = s.status,
s.last_erp_sync = datetime();

MATCH (s:Service) RETURN count(s) AS TotalServices;


// internal CRM users
UNWIND [
  {name:'Emma Thompson', email:'emma.t@crm.com', role:'admin', department:'IT'},
  {name:'James Wilson', email:'james.w@crm.com', role:'sales_manager', department:'Sales'},
  {name:'Sarah Chen', email:'sarah.c@crm.com', role:'sales_rep', department:'Sales'},
  {name:'Michael Brown', email:'michael.b@crm.com', role:'sales_rep', department:'Sales'},
  {name:'Lisa Garcia', email:'lisa.g@crm.com', role:'sales_rep', department:'Sales'},
  {name:'David Kim', email:'david.k@crm.com', role:'sales_manager', department:'Sales'}
] AS row
CREATE (u:User)
SET u = row, u.is_active = true;

MATCH (u:User) RETURN count(u) AS TotalUsers;


// companies (customer accounts)
// erp_id links to the company record in the ERP system
UNWIND [
  {name:'Acme Corp', industry:'Technology', size:'Enterprise', revenue:50000000, website:'acme.com', erp_id:'ERP-CO-001'},
  {name:'Globex Industries', industry:'Manufacturing', size:'Large', revenue:32000000, website:'globex.com', erp_id:'ERP-CO-002'},
  {name:'Initech Solutions', industry:'Technology', size:'Medium', revenue:8500000, website:'initech.com', erp_id:'ERP-CO-003'},
  {name:'Umbrella Healthcare', industry:'Healthcare', size:'Enterprise', revenue:120000000, website:'umbrellahc.com', erp_id:'ERP-CO-004'},
  {name:'Stark Energy', industry:'Energy', size:'Large', revenue:45000000, website:'starkenergy.com', erp_id:'ERP-CO-005'},
  {name:'Wayne Financial', industry:'Finance', size:'Enterprise', revenue:200000000, website:'waynefin.com', erp_id:'ERP-CO-006'},
  {name:'Pied Piper Tech', industry:'Technology', size:'Small', revenue:2000000, website:'piedpiper.io', erp_id:'ERP-CO-007'},
  {name:'Hooli Media', industry:'Media', size:'Large', revenue:38000000, website:'hooli.com', erp_id:'ERP-CO-008'},
  {name:'Sterling Retail', industry:'Retail', size:'Medium', revenue:12000000, website:'sterlingretail.com', erp_id:'ERP-CO-009'},
  {name:'Oceanic Logistics', industry:'Logistics', size:'Large', revenue:28000000, website:'oceaniclog.com', erp_id:'ERP-CO-010'},
  {name:'Phoenix Pharma', industry:'Healthcare', size:'Enterprise', revenue:95000000, website:'phoenixpharma.com', erp_id:'ERP-CO-011'},
  {name:'Atlas Construction', industry:'Construction', size:'Medium', revenue:15000000, website:'atlascon.com', erp_id:'ERP-CO-012'},
  {name:'Zenith Education', industry:'Education', size:'Small', revenue:3500000, website:'zenithedu.com', erp_id:'ERP-CO-013'},
  {name:'Meridian Insurance', industry:'Finance', size:'Large', revenue:55000000, website:'meridianins.com', erp_id:'ERP-CO-014'},
  {name:'Quantum Computing Ltd', industry:'Technology', size:'Medium', revenue:11000000, website:'quantumcl.com', erp_id:'ERP-CO-015'},
  {name:'BlueSky Airlines', industry:'Transport', size:'Enterprise', revenue:180000000, website:'bluesky.com', erp_id:'ERP-CO-016'},
  {name:'GreenField Agriculture', industry:'Agriculture', size:'Medium', revenue:9000000, website:'greenfieldagri.com', erp_id:'ERP-CO-017'},
  {name:'NovaTech Systems', industry:'Technology', size:'Small', revenue:4200000, website:'novatech.io', erp_id:'ERP-CO-018'},
  {name:'Summit Legal', industry:'Legal', size:'Medium', revenue:7500000, website:'summitlegal.com', erp_id:'ERP-CO-019'},
  {name:'Cascade Hospitality', industry:'Hospitality', size:'Large', revenue:22000000, website:'cascadehotels.com', erp_id:'ERP-CO-020'},
  {name:'Vertex Automotive', industry:'Manufacturing', size:'Enterprise', revenue:75000000, website:'vertexauto.com', erp_id:'ERP-CO-021'},
  {name:'Prism Analytics', industry:'Technology', size:'Small', revenue:3000000, website:'prismanalytics.com', erp_id:'ERP-CO-022'},
  {name:'Harbor Shipping', industry:'Logistics', size:'Large', revenue:35000000, website:'harborshipping.com', erp_id:'ERP-CO-023'},
  {name:'Crestview Properties', industry:'Real Estate', size:'Medium', revenue:18000000, website:'crestviewprop.com', erp_id:'ERP-CO-024'},
  {name:'Nexus Telecom', industry:'Telecom', size:'Large', revenue:42000000, website:'nexustelecom.com', erp_id:'ERP-CO-025'}
] AS row
CREATE (co:Company)
SET co = row, co.created_date = date('2024-01-15');

MATCH (co:Company) RETURN count(co) AS TotalCompanies;
