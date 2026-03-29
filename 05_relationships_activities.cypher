// USES_SERVICE relationships - ERP integration
// the activation status lives on the relationship, not the Service node
// this way each company can have a different status for the same service
// erp_activation_id is the foreign key back to the ERP activation record

MATCH (co:Company {name:'Acme Corp'}), (s:Service {erp_service_id:'ERP-SVC-001'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-03-01'), status:'active', erp_activation_id:'ERP-ACT-001', renewal_date:date('2026-03-01')}]->(s);

MATCH (co:Company {name:'Acme Corp'}), (s:Service {erp_service_id:'ERP-SVC-002'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-06-01'), status:'active', erp_activation_id:'ERP-ACT-002', renewal_date:date('2026-06-01')}]->(s);

MATCH (co:Company {name:'Acme Corp'}), (s:Service {erp_service_id:'ERP-SVC-007'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-01-10'), status:'active', erp_activation_id:'ERP-ACT-003', renewal_date:date('2026-01-10')}]->(s);

MATCH (co:Company {name:'Wayne Financial'}), (s:Service {erp_service_id:'ERP-SVC-001'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2023-09-01'), status:'active', erp_activation_id:'ERP-ACT-010', renewal_date:date('2025-09-01')}]->(s);

MATCH (co:Company {name:'Wayne Financial'}), (s:Service {erp_service_id:'ERP-SVC-007'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2023-09-01'), status:'active', erp_activation_id:'ERP-ACT-011', renewal_date:date('2025-09-01')}]->(s);

MATCH (co:Company {name:'Wayne Financial'}), (s:Service {erp_service_id:'ERP-SVC-006'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-02-01'), status:'active', erp_activation_id:'ERP-ACT-012', renewal_date:date('2026-02-01')}]->(s);

MATCH (co:Company {name:'Umbrella Healthcare'}), (s:Service {erp_service_id:'ERP-SVC-001'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-04-01'), status:'active', erp_activation_id:'ERP-ACT-020', renewal_date:date('2026-04-01')}]->(s);

MATCH (co:Company {name:'Umbrella Healthcare'}), (s:Service {erp_service_id:'ERP-SVC-004'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-04-01'), status:'active', erp_activation_id:'ERP-ACT-021', renewal_date:date('2026-04-01')}]->(s);

// Globex suspended - ERP pushed the status update
MATCH (co:Company {name:'Globex Industries'}), (s:Service {erp_service_id:'ERP-SVC-001'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2023-11-01'), status:'suspended', erp_activation_id:'ERP-ACT-030', renewal_date:date('2025-11-01')}]->(s);

MATCH (co:Company {name:'Stark Energy'}), (s:Service {erp_service_id:'ERP-SVC-002'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-07-01'), status:'active', erp_activation_id:'ERP-ACT-040', renewal_date:date('2026-07-01')}]->(s);

MATCH (co:Company {name:'Initech Solutions'}), (s:Service {erp_service_id:'ERP-SVC-003'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-05-01'), status:'active', erp_activation_id:'ERP-ACT-050', renewal_date:date('2026-05-01')}]->(s);

MATCH (co:Company {name:'BlueSky Airlines'}), (s:Service {erp_service_id:'ERP-SVC-006'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-01-01'), status:'active', erp_activation_id:'ERP-ACT-060', renewal_date:date('2026-01-01')}]->(s);

MATCH (co:Company {name:'Nexus Telecom'}), (s:Service {erp_service_id:'ERP-SVC-009'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-08-01'), status:'active', erp_activation_id:'ERP-ACT-070', renewal_date:date('2026-08-01')}]->(s);

MATCH (co:Company {name:'Phoenix Pharma'}), (s:Service {erp_service_id:'ERP-SVC-004'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-09-01'), status:'active', erp_activation_id:'ERP-ACT-080', renewal_date:date('2026-09-01')}]->(s);

MATCH (co:Company {name:'Sterling Retail'}), (s:Service {erp_service_id:'ERP-SVC-005'})
CREATE (co)-[:USES_SERVICE {activated_date:date('2024-03-15'), status:'active', erp_activation_id:'ERP-ACT-090', renewal_date:date('2026-03-15')}]->(s);


// activity nodes - calls, emails, meetings etc
UNWIND [
  {activity_id:'ACT-001', type:'call', date:date('2025-11-15'), description:'Initial discovery call - identified 3 pain points', duration:45},
  {activity_id:'ACT-002', type:'demo', date:date('2025-11-28'), description:'Product demo - positive response from CTO', duration:90},
  {activity_id:'ACT-003', type:'email', date:date('2025-12-05'), description:'Sent proposal follow-up and pricing sheet', duration:15},
  {activity_id:'ACT-004', type:'meeting', date:date('2026-01-10'), description:'In-person executive review meeting', duration:120},
  {activity_id:'ACT-005', type:'call', date:date('2026-01-20'), description:'Negotiation call - discussed discount options', duration:60},
  {activity_id:'ACT-006', type:'email', date:date('2026-02-03'), description:'Contract draft sent for legal review', duration:10},
  {activity_id:'ACT-007', type:'meeting', date:date('2026-02-14'), description:'Technical deep dive with engineering team', duration:180},
  {activity_id:'ACT-008', type:'call', date:date('2026-02-25'), description:'Budget approval confirmed', duration:30},
  {activity_id:'ACT-009', type:'email', date:date('2026-03-01'), description:'Final contract signed - project kickoff scheduled', duration:20},
  {activity_id:'ACT-010', type:'note', date:date('2026-03-10'), description:'Customer reported onboarding issue - escalated to support', duration:0}
] AS row
CREATE (a:Activity) SET a = row;

// link activities to deals and track who logged them
MATCH (a:Activity {activity_id:'ACT-001'}), (d:Deal {deal_id:'DEAL-001'}), (u:User {name:'Sarah Chen'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-002'}), (d:Deal {deal_id:'DEAL-001'}), (u:User {name:'Sarah Chen'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-003'}), (d:Deal {deal_id:'DEAL-001'}), (u:User {name:'James Wilson'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-004'}), (d:Deal {deal_id:'DEAL-007'}), (u:User {name:'Lisa Garcia'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-005'}), (d:Deal {deal_id:'DEAL-007'}), (u:User {name:'James Wilson'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-006'}), (d:Deal {deal_id:'DEAL-026'}), (u:User {name:'Sarah Chen'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-007'}), (d:Deal {deal_id:'DEAL-026'}), (u:User {name:'David Kim'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-008'}), (d:Deal {deal_id:'DEAL-015'}), (u:User {name:'Michael Brown'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-009'}), (d:Deal {deal_id:'DEAL-004'}), (u:User {name:'Lisa Garcia'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

MATCH (a:Activity {activity_id:'ACT-010'}), (d:Deal {deal_id:'DEAL-004'}), (u:User {name:'Emma Thompson'})
CREATE (d)-[:HAS_ACTIVITY]->(a), (u)-[:LOGGED]->(a);

// KNOWS - who knows who (referral network between contacts)
MATCH (a:Contact {email:'alice.j@acme.com'}), (b:Contact {email:'dan.l@globex.com'})
CREATE (a)-[:KNOWS {since:date('2022-05-01'), context:'conference'}]->(b);

MATCH (a:Contact {email:'bob.s@acme.com'}), (b:Contact {email:'grace.p@initech.com'})
CREATE (a)-[:KNOWS {since:date('2021-03-15'), context:'former_colleague'}]->(b);

MATCH (a:Contact {email:'irene.f@umbrellahc.com'}), (b:Contact {email:'olivia.s@waynefin.com'})
CREATE (a)-[:KNOWS {since:date('2023-09-10'), context:'industry_group'}]->(b);

MATCH (a:Contact {email:'dan.l@globex.com'}), (b:Contact {email:'leo.h@starkenergy.com'})
CREATE (a)-[:KNOWS {since:date('2020-11-01'), context:'board_member'}]->(b);

MATCH (a:Contact {email:'nathan.b@waynefin.com'}), (b:Contact {email:'hannah.e@bluesky.com'})
CREATE (a)-[:KNOWS {since:date('2024-01-15'), context:'referral'}]->(b);

MATCH (a:Contact {email:'alice.j@acme.com'}), (b:Contact {email:'fiona.m@quantumcl.com'})
CREATE (a)-[:KNOWS {since:date('2023-06-01'), context:'conference'}]->(b);

MATCH (a:Contact {email:'peter.k@waynefin.com'}), (b:Contact {email:'zach.b@phoenixpharma.com'})
CREATE (a)-[:KNOWS {since:date('2022-11-15'), context:'industry_group'}]->(b);

// final count to verify everything loaded correctly
MATCH (n) RETURN labels(n)[0] AS Label, count(n) AS Count ORDER BY Label;
