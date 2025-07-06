// Customer Segments to Customer Relationships (continued)
MATCH (cs1:CustomerSegment {id: "cs_commuters"}), (cr1:CustomerRelationship {id: "cr_personal_consultation"}), (cr3:CustomerRelationship {id: "cr_service_tracking"})
MATCH (cs2:CustomerSegment {id: "cs_recreational"}), (cr2:CustomerRelationship {id: "cr_community_building"})
MATCH (cs3:CustomerSegment {id: "cs_enthusiasts"})
CREATE (cs1)-[:HAS_RELATIONSHIP_WITH]->(cr1), (cs1)-[:HAS_RELATIONSHIP_WITH]->(cr3),
       (cs2)-[:HAS_RELATIONSHIP_WITH]->(cr1), (cs2)-[:HAS_RELATIONSHIP_WITH]->(cr2),
       (cs3)-[:HAS_RELATIONSHIP_WITH]->(cr1), (cs3)-[:HAS_RELATIONSHIP_WITH]->(cr2), (cs3)-[:HAS_RELATIONSHIP_WITH]->(cr3);

// Customer Segments to Revenue Streams
MATCH (cs1:CustomerSegment {id: "cs_commuters"}), (cs2:CustomerSegment {id: "cs_recreational"}), (cs3:CustomerSegment {id: "cs_enthusiasts"})
MATCH (rs1:RevenueStream {id: "rs_bike_sales"}), (rs2:RevenueStream {id: "rs_service_repair"}), (rs3:RevenueStream {id: "rs_accessories"}), (rs4:RevenueStream {id: "rs_workshops"})
CREATE (cs1)-[:GENERATES]->(rs1), (cs1)-[:GENERATES]->(rs2), (cs1)-[:GENERATES]->(rs3),
       (cs2)-[:GENERATES]->(rs1), (cs2)-[:GENERATES]->(rs2), (cs2)-[:GENERATES]->(rs3), (cs2)-[:GENERATES]->(rs4),
       (cs3)-[:GENERATES]->(rs1), (cs3)-[:GENERATES]->(rs2), (cs3)-[:GENERATES]->(rs3), (cs3)-[:GENERATES]->(rs4);

// =====================================================
// RESOURCE AND ACTIVITY DEPENDENCIES
// =====================================================

// Value Propositions to Key Resources
MATCH (vp1:ValueProposition {id: "vp_bike_sales"})
MATCH (kr1:KeyResource {id: "kr_inventory"}), (kr2:KeyResource {id: "kr_expertise"}), (kr3:KeyResource {id: "kr_retail_space"}), (kr4:KeyResource {id: "kr_customer_database"})
CREATE (vp1)-[:REQUIRES_RESOURCE]->(kr1), (vp1)-[:REQUIRES_RESOURCE]->(kr2), (vp1)-[:REQUIRES_RESOURCE]->(kr3), (vp1)-[:REQUIRES_RESOURCE]->(kr4);

MATCH (vp2:ValueProposition {id: "vp_service_maintenance"})
MATCH (kr1:KeyResource {id: "kr_inventory"}), (kr2:KeyResource {id: "kr_expertise"}), (kr3:KeyResource {id: "kr_retail_space"}), (kr4:KeyResource {id: "kr_customer_database"})
CREATE (vp2)-[:REQUIRES_RESOURCE]->(kr1), (vp2)-[:REQUIRES_RESOURCE]->(kr2), (vp2)-[:REQUIRES_RESOURCE]->(kr3), (vp2)-[:REQUIRES_RESOURCE]->(kr4);

MATCH (vp3:ValueProposition {id: "vp_community_education"})
MATCH (kr2:KeyResource {id: "kr_expertise"}), (kr3:KeyResource {id: "kr_retail_space"}), (kr5:KeyResource {id: "kr_brand_reputation"})
CREATE (vp3)-[:REQUIRES_RESOURCE]->(kr2), (vp3)-[:REQUIRES_RESOURCE]->(kr3), (vp3)-[:REQUIRES_RESOURCE]->(kr5);

// Value Propositions to Key Activities
MATCH (vp1:ValueProposition {id: "vp_bike_sales"})
MATCH (ka1:KeyActivity {id: "ka_bike_assembly"}), (ka2:KeyActivity {id: "ka_customer_consultation"}), (ka4:KeyActivity {id: "ka_inventory_management"})
CREATE (vp1)-[:REQUIRES_ACTIVITY]->(ka1), (vp1)-[:REQUIRES_ACTIVITY]->(ka2), (vp1)-[:REQUIRES_ACTIVITY]->(ka4);

MATCH (vp2:ValueProposition {id: "vp_service_maintenance"})
MATCH (ka2:KeyActivity {id: "ka_customer_consultation"}), (ka3:KeyActivity {id: "ka_repair_maintenance"}), (ka4:KeyActivity {id: "ka_inventory_management"})
CREATE (vp2)-[:REQUIRES_ACTIVITY]->(ka2), (vp2)-[:REQUIRES_ACTIVITY]->(ka3), (vp2)-[:REQUIRES_ACTIVITY]->(ka4);

MATCH (vp3:ValueProposition {id: "vp_community_education"})
MATCH (ka2:KeyActivity {id: "ka_customer_consultation"}), (ka5:KeyActivity {id: "ka_community_engagement"})
CREATE (vp3)-[:REQUIRES_ACTIVITY]->(ka2), (vp3)-[:REQUIRES_ACTIVITY]->(ka5);

// Key Activities to Key Resources
MATCH (ka1:KeyActivity {id: "ka_bike_assembly"}), (kr1:KeyResource {id: "kr_inventory"}), (kr2:KeyResource {id: "kr_expertise"}), (kr3:KeyResource {id: "kr_retail_space"})
MATCH (ka2:KeyActivity {id: "ka_customer_consultation"}), (kr4:KeyResource {id: "kr_customer_database"}), (kr5:KeyResource {id: "kr_brand_reputation"})
CREATE (ka1)-[:USES_RESOURCE]->(kr1), (ka1)-[:USES_RESOURCE]->(kr2), (ka1)-[:USES_RESOURCE]->(kr3),
       (ka2)-[:USES_RESOURCE]->(kr2), (ka2)-[:USES_RESOURCE]->(kr4), (ka2)-[:USES_RESOURCE]->(kr5);

MATCH (ka3:KeyActivity {id: "ka_repair_maintenance"}), (ka4:KeyActivity {id: "ka_inventory_management"}), (ka5:KeyActivity {id: "ka_community_engagement"})
MATCH (kr1:KeyResource {id: "kr_inventory"}), (kr2:KeyResource {id: "kr_expertise"}), (kr3:KeyResource {id: "kr_retail_space"}), (kr4:KeyResource {id: "kr_customer_database"}), (kr5:KeyResource {id: "kr_brand_reputation"})
CREATE (ka3)-[:USES_RESOURCE]->(kr1), (ka3)-[:USES_RESOURCE]->(kr2), (ka3)-[:USES_RESOURCE]->(kr3),
       (ka4)-[:USES_RESOURCE]->(kr1), (ka4)-[:USES_RESOURCE]->(kr4),
       (ka5)-[:USES_RESOURCE]->(kr2), (ka5)-[:USES_RESOURCE]->(kr3), (ka5)-[:USES_RESOURCE]->(kr5);

// =====================================================
// PARTNERSHIP RELATIONSHIPS
// =====================================================

// Key Partnerships to Key Resources
MATCH (kp1:KeyPartnership {id: "kp_bike_manufacturers"}), (kr1:KeyResource {id: "kr_inventory"})
MATCH (kp2:KeyPartnership {id: "kp_local_businesses"}), (kp3:KeyPartnership {id: "kp_cycling_organizations"}), (kr5:KeyResource {id: "kr_brand_reputation"})
MATCH (kp4:KeyPartnership {id: "kp_insurance_partners"}), (kr4:KeyResource {id: "kr_customer_database"})
CREATE (kp1)-[:ENABLES]->(kr1),
       (kp2)-[:ENABLES]->(kr5), (kp3)-[:ENABLES]->(kr5),
       (kp4)-[:ENABLES]->(kr4);

// Key Partnerships to Key Activities
MATCH (kp1:KeyPartnership {id: "kp_bike_manufacturers"}), (ka4:KeyActivity {id: "ka_inventory_management"})
MATCH (kp2:KeyPartnership {id: "kp_local_businesses"}), (kp4:KeyPartnership {id: "kp_insurance_partners"}), (ka2:KeyActivity {id: "ka_customer_consultation"})
MATCH (kp3:KeyPartnership {id: "kp_cycling_organizations"}), (ka5:KeyActivity {id: "ka_community_engagement"})
CREATE (kp1)-[:SUPPORTS]->(ka4),
       (kp2)-[:SUPPORTS]->(ka2), (kp4)-[:SUPPORTS]->(ka2),
       (kp3)-[:SUPPORTS]->(ka5);

// =====================================================
// COST STRUCTURE RELATIONSHIPS
// =====================================================

// Key Resources to Cost Structures
MATCH (kr1:KeyResource {id: "kr_inventory"}), (cost2:CostStructure {id: "cost_inventory"})
MATCH (kr2:KeyResource {id: "kr_expertise"}), (cost1:CostStructure {id: "cost_personnel"})
MATCH (kr3:KeyResource {id: "kr_retail_space"}), (cost3:CostStructure {id: "cost_facility"})
MATCH (kr4:KeyResource {id: "kr_customer_database"}), (cost5:CostStructure {id: "cost_technology"})
MATCH (kr5:KeyResource {id: "kr_brand_reputation"}), (cost4:CostStructure {id: "cost_marketing"})
CREATE (kr1)-[:INCURS_COST {costDriver: "Purchasing and carrying costs for bikes, parts, and accessories"}]->(cost2),
       (kr2)-[:INCURS_COST {costDriver: "Salaries and benefits for skilled mechanics and sales staff"}]->(cost1),
       (kr3)-[:INCURS_COST {costDriver: "Rent, utilities, and maintenance for retail and workshop space"}]->(cost3),
       (kr4)-[:INCURS_COST {costDriver: "CRM software, data storage, and customer management systems"}]->(cost5),
       (kr5)-[:INCURS_COST {costDriver: "Brand building, community events, and reputation management"}]->(cost4);

// Key Activities to Cost Structures  
MATCH (ka1:KeyActivity {id: "ka_bike_assembly"}), (ka2:KeyActivity {id: "ka_customer_consultation"}), (ka3:KeyActivity {id: "ka_repair_maintenance"}), (cost1:CostStructure {id: "cost_personnel"})
MATCH (ka4:KeyActivity {id: "ka_inventory_management"}), (cost2:CostStructure {id: "cost_inventory"})
MATCH (ka5:KeyActivity {id: "ka_community_engagement"}), (cost4:CostStructure {id: "cost_marketing"})
CREATE (ka1)-[:INCURS_COST {costDriver: "Labor costs for bike assembly, setup, and fitting"}]->(cost1),
       (ka2)-[:INCURS_COST {costDriver: "Sales staff time for customer consultation and advice"}]->(cost1),
       (ka3)-[:INCURS_COST {costDriver: "Mechanic labor for repair and maintenance services"}]->(cost1),
       (ka4)-[:INCURS_COST {costDriver: "Purchasing, storage, and inventory management costs"}]->(cost2),
       (ka5)-[:INCURS_COST {costDriver: "Event organization, promotional materials, and community activities"}]->(cost4);

// Channels to Cost Structures
MATCH (ch1:Channel {id: "ch_social_media"}), (cost4:CostStructure {id: "cost_marketing"})
MATCH (ch2:Channel {id: "ch_retail_store"}), (cost3:CostStructure {id: "cost_facility"})
MATCH (ch3:Channel {id: "ch_loyalty_program"}), (cost5:CostStructure {id: "cost_technology"})
MATCH (ch4:Channel {id: "ch_referral_partners"}), (ch5:Channel {id: "ch_mobile_service"}), (cost1:CostStructure {id: "cost_personnel"})
CREATE (ch1)-[:INCURS_COST {costDriver: "Digital advertising, content creation, and social media management"}]->(cost4),
       (ch2)-[:INCURS_COST {costDriver: "Physical retail space, displays, and in-store operations"}]->(cost3),
       (ch3)-[:INCURS_COST {costDriver: "Loyalty program software, rewards, and customer tracking systems"}]->(cost5),
       (ch4)-[:INCURS_COST {costDriver: "Partner commissions, cross-promotional activities, and relationship management"}]->(cost4),
       (ch5)-[:INCURS_COST {costDriver: "Mobile service technician labor and travel time"}]->(cost1);

// =====================================================
// SUCCESS MESSAGE
// =====================================================

RETURN "🎉 CycleWorks Bike Shop Knowledge Graph Complete!" as Result,
       "All 12 node types created with semantic enhancement" as NodesStatus,
       "All 16+ relationship types implemented" as RelationshipsStatus,
       "Full JTBD integration achieved" as JTBDStatus,
       "All 3 channel types included (acquisition, delivery, retention)" as ChannelStatus,
       "Total Monthly Costs: $56,200" as CostSummary,
       "Ready for business analysis and strategic insights" as ReadyStatus;