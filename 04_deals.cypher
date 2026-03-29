// deals + HAS_DEAL + ASSIGNED_TO + INVOLVED_IN relationships

UNWIND [
  {deal_id:'DEAL-001', title:'Enterprise Platform Upgrade', value:250000, stage:'Proposal', probability:60, company:'Acme Corp', rep:'Sarah Chen'},
  {deal_id:'DEAL-002', title:'Analytics Implementation', value:180000, stage:'Negotiation', probability:75, company:'Acme Corp', rep:'Sarah Chen'},
  {deal_id:'DEAL-003', title:'Manufacturing MES Integration', value:320000, stage:'Qualification', probability:40, company:'Globex Industries', rep:'Michael Brown'},
  {deal_id:'DEAL-004', title:'Cloud Migration Project', value:95000, stage:'Closed Won', probability:100, company:'Initech Solutions', rep:'Lisa Garcia'},
  {deal_id:'DEAL-005', title:'Healthcare Data Platform', value:450000, stage:'Prospect', probability:20, company:'Umbrella Healthcare', rep:'Sarah Chen'},
  {deal_id:'DEAL-006', title:'Energy Trading System', value:175000, stage:'Proposal', probability:55, company:'Stark Energy', rep:'Michael Brown'},
  {deal_id:'DEAL-007', title:'Core Banking Refresh', value:800000, stage:'Negotiation', probability:70, company:'Wayne Financial', rep:'Lisa Garcia'},
  {deal_id:'DEAL-008', title:'SaaS Platform Build', value:65000, stage:'Closed Won', probability:100, company:'Pied Piper Tech', rep:'Sarah Chen'},
  {deal_id:'DEAL-009', title:'Media Asset Management', value:120000, stage:'Qualification', probability:35, company:'Hooli Media', rep:'Michael Brown'},
  {deal_id:'DEAL-010', title:'Retail POS Upgrade', value:85000, stage:'Proposal', probability:50, company:'Sterling Retail', rep:'Lisa Garcia'},
  {deal_id:'DEAL-011', title:'Supply Chain Optimization', value:210000, stage:'Proposal', probability:45, company:'Oceanic Logistics', rep:'Sarah Chen'},
  {deal_id:'DEAL-012', title:'Clinical Data Management', value:380000, stage:'Qualification', probability:30, company:'Phoenix Pharma', rep:'Michael Brown'},
  {deal_id:'DEAL-013', title:'Project Management System', value:55000, stage:'Closed Won', probability:100, company:'Atlas Construction', rep:'Lisa Garcia'},
  {deal_id:'DEAL-014', title:'LMS Platform Upgrade', value:72000, stage:'Proposal', probability:60, company:'Zenith Education', rep:'Sarah Chen'},
  {deal_id:'DEAL-015', title:'Policy Management System', value:290000, stage:'Negotiation', probability:65, company:'Meridian Insurance', rep:'Michael Brown'},
  {deal_id:'DEAL-016', title:'Quantum Research DB', value:150000, stage:'Qualification', probability:25, company:'Quantum Computing Ltd', rep:'Lisa Garcia'},
  {deal_id:'DEAL-017', title:'Passenger Analytics', value:420000, stage:'Proposal', probability:50, company:'BlueSky Airlines', rep:'Sarah Chen'},
  {deal_id:'DEAL-018', title:'Crop Yield Analytics', value:45000, stage:'Prospect', probability:15, company:'GreenField Agriculture', rep:'Michael Brown'},
  {deal_id:'DEAL-019', title:'Product Launch CRM', value:68000, stage:'Closed Won', probability:100, company:'NovaTech Systems', rep:'Lisa Garcia'},
  {deal_id:'DEAL-020', title:'Document Workflow System', value:88000, stage:'Proposal', probability:55, company:'Summit Legal', rep:'Sarah Chen'},
  {deal_id:'DEAL-021', title:'Guest Experience Platform', value:195000, stage:'Negotiation', probability:72, company:'Cascade Hospitality', rep:'Michael Brown'},
  {deal_id:'DEAL-022', title:'Dealer Management System', value:340000, stage:'Qualification', probability:38, company:'Vertex Automotive', rep:'Lisa Garcia'},
  {deal_id:'DEAL-023', title:'BI Dashboard Implementation', value:78000, stage:'Closed Won', probability:100, company:'Prism Analytics', rep:'Sarah Chen'},
  {deal_id:'DEAL-024', title:'Freight Tracking System', value:125000, stage:'Proposal', probability:48, company:'Harbor Shipping', rep:'Michael Brown'},
  {deal_id:'DEAL-025', title:'Property Portfolio DB', value:92000, stage:'Qualification', probability:32, company:'Crestview Properties', rep:'Lisa Garcia'},
  {deal_id:'DEAL-026', title:'Network Operations Center', value:510000, stage:'Negotiation', probability:68, company:'Nexus Telecom', rep:'Sarah Chen'},
  {deal_id:'DEAL-027', title:'Security Audit System', value:145000, stage:'Prospect', probability:18, company:'Acme Corp', rep:'Michael Brown'},
  {deal_id:'DEAL-028', title:'ERP Data Migration', value:275000, stage:'Proposal', probability:52, company:'Globex Industries', rep:'Lisa Garcia'},
  {deal_id:'DEAL-029', title:'Patient Portal Upgrade', value:185000, stage:'Qualification', probability:28, company:'Umbrella Healthcare', rep:'Sarah Chen'},
  {deal_id:'DEAL-030', title:'Smart Grid Analytics', value:230000, stage:'Negotiation', probability:62, company:'Stark Energy', rep:'Michael Brown'},
  {deal_id:'DEAL-031', title:'Trading Risk Dashboard', value:620000, stage:'Proposal', probability:45, company:'Wayne Financial', rep:'Lisa Garcia'},
  {deal_id:'DEAL-032', title:'HR Management System', value:48000, stage:'Closed Won', probability:100, company:'Pied Piper Tech', rep:'Sarah Chen'},
  {deal_id:'DEAL-033', title:'Content Management Platform', value:135000, stage:'Qualification', probability:35, company:'Hooli Media', rep:'Michael Brown'},
  {deal_id:'DEAL-034', title:'Loyalty Programme DB', value:98000, stage:'Proposal', probability:55, company:'Sterling Retail', rep:'Lisa Garcia'},
  {deal_id:'DEAL-035', title:'Last Mile Delivery System', value:165000, stage:'Negotiation', probability:70, company:'Oceanic Logistics', rep:'Sarah Chen'}
] AS row
CREATE (d:Deal {
  deal_id: row.deal_id,
  title: row.title,
  value: row.value,
  stage: row.stage,
  probability: row.probability,
  expected_close: date('2026-09-30'),
  created_date: date('2025-01-15'),
  currency: 'GBP'
})
WITH d, row
MATCH (co:Company {name: row.company})
CREATE (co)-[:HAS_DEAL]->(d)
WITH d, row
MATCH (u:User {name: row.rep})
CREATE (d)-[:ASSIGNED_TO {since: date('2025-01-20'), is_primary: true}]->(u);

// which contacts are involved in each deal and in what role
MATCH (c:Contact {email:'alice.j@acme.com'}), (d:Deal {deal_id:'DEAL-001'})
CREATE (c)-[:INVOLVED_IN {role:'decision_maker'}]->(d);
MATCH (c:Contact {email:'bob.s@acme.com'}), (d:Deal {deal_id:'DEAL-001'})
CREATE (c)-[:INVOLVED_IN {role:'influencer'}]->(d);
MATCH (c:Contact {email:'carol.d@acme.com'}), (d:Deal {deal_id:'DEAL-001'})
CREATE (c)-[:INVOLVED_IN {role:'champion'}]->(d);
MATCH (c:Contact {email:'alice.j@acme.com'}), (d:Deal {deal_id:'DEAL-002'})
CREATE (c)-[:INVOLVED_IN {role:'decision_maker'}]->(d);
MATCH (c:Contact {email:'dan.l@globex.com'}), (d:Deal {deal_id:'DEAL-003'})
CREATE (c)-[:INVOLVED_IN {role:'decision_maker'}]->(d);
MATCH (c:Contact {email:'eva.m@globex.com'}), (d:Deal {deal_id:'DEAL-003'})
CREATE (c)-[:INVOLVED_IN {role:'influencer'}]->(d);
MATCH (c:Contact {email:'irene.f@umbrellahc.com'}), (d:Deal {deal_id:'DEAL-005'})
CREATE (c)-[:INVOLVED_IN {role:'decision_maker'}]->(d);
MATCH (c:Contact {email:'jack.t@umbrellahc.com'}), (d:Deal {deal_id:'DEAL-005'})
CREATE (c)-[:INVOLVED_IN {role:'champion'}]->(d);
MATCH (c:Contact {email:'nathan.b@waynefin.com'}), (d:Deal {deal_id:'DEAL-007'})
CREATE (c)-[:INVOLVED_IN {role:'decision_maker'}]->(d);
MATCH (c:Contact {email:'peter.k@waynefin.com'}), (d:Deal {deal_id:'DEAL-007'})
CREATE (c)-[:INVOLVED_IN {role:'influencer'}]->(d);

MATCH (d:Deal) RETURN count(d) AS TotalDeals;
