// =====================================================
// Business Model Canvas + JTBD Relationship Creation Templates
// Copy and customize these templates for connecting your business model nodes
// =====================================================

// PREREQUISITE: Create all nodes first using node-templates.cypher
// Then use these templates to connect them into a complete business model

// =====================================================
// CORE BUSINESS MODEL RELATIONSHIPS
// =====================================================

// 1. Business Model to Value Propositions (HAS_VALUE_PROPOSITION)
// Connect your business model to all its value propositions
MATCH (bm:BusinessModel {id: "bm_001"}), (vp:ValueProposition {id: "vp_001"})
CREATE (bm)-[:HAS_VALUE_PROPOSITION]->(vp);

// Template for additional value propositions:
// MATCH (bm:BusinessModel {id: "bm_001"}), (vp:ValueProposition {id: "vp_002"})
// CREATE (bm)-[:HAS_VALUE_PROPOSITION]->(vp);

// =====================================================

// 2. Business Model to Customer Segments (HAS_CUSTOMER_SEGMENT)
// Connect your business model to all its customer segments
MATCH (bm:BusinessModel {id: "bm_001"}), (cs:CustomerSegment {id: "cs_001"})
CREATE (bm)-[:HAS_CUSTOMER_SEGMENT]->(cs);

// Template for additional customer segments:
// MATCH (bm:BusinessModel {id: "bm_001"}), (cs:CustomerSegment {id: "cs_002"})
// CREATE (bm)-[:HAS_CUSTOMER_SEGMENT]->(cs);

// =====================================================

// 3. Value Propositions to Customer Segments (TARGETS)
// Show which value propositions target which customer segments
MATCH (vp:ValueProposition {id: "vp_001"}), (cs:CustomerSegment {id: "cs_001"})
CREATE (vp)-[:TARGETS]->(cs);

// Templates for additional targeting relationships:
// MATCH (vp:ValueProposition {id: "vp_001"}), (cs:CustomerSegment {id: "cs_002"})
// CREATE (vp)-[:TARGETS]->(cs);
// 
// MATCH (vp:ValueProposition {id: "vp_002"}), (cs:CustomerSegment {id: "cs_001"})
// CREATE (vp)-[:TARGETS]->(cs);

// =====================================================
// JOBS-TO-BE-DONE INTEGRATION RELATIONSHIPS
// =====================================================

// 4. Customer Segments to Job Executors (DEFINED_BY_JOB_EXECUTOR)
// Each customer segment is defined by who executes the jobs
MATCH (cs:CustomerSegment {id: "cs_001"}), (je:JobExecutor {id: "je_001"})
CREATE (cs)-[:DEFINED_BY_JOB_EXECUTOR {
    segmentFit: "high"                               // Change: high, medium, low
}]->(je);

// Template for additional job executors:
// MATCH (cs:CustomerSegment {id: "cs_002"}), (je:JobExecutor {id: "je_002"})
// CREATE (cs)-[:DEFINED_BY_JOB_EXECUTOR {segmentFit: "high"}]->(je);

// =====================================================

// 5. Customer Segments to Jobs to be Done (DEFINED_BY_JOB)
// Each customer segment is defined by the jobs they need to accomplish
MATCH (cs:CustomerSegment {id: "cs_001"}), (job:JobToBeDone {id: "job_001"})
CREATE (cs)-[:DEFINED_BY_JOB {
    jobPriority: "primary"                           // Change: primary, secondary, tertiary
}]->(job);

// Template for additional jobs:
// MATCH (cs:CustomerSegment {id: "cs_002"}), (job:JobToBeDone {id: "job_002"})
// CREATE (cs)-[:DEFINED_BY_JOB {jobPriority: "primary"}]->(job);

// =====================================================

// 6. Job Executors to Jobs to be Done (EXECUTES_JOB)
// Show who executes which jobs and in what context
MATCH (je:JobExecutor {id: "je_001"}), (job:JobToBeDone {id: "job_001"})
CREATE (je)-[:EXECUTES_JOB {
    executionContext: "[DESCRIBE CONTEXT]",          // Change: Where/how they perform the job
    executionFrequency: "daily"                      // Change: daily, weekly, monthly, etc.
}]->(job);

// Template for additional job execution relationships:
// MATCH (je:JobExecutor {id: "je_002"}), (job:JobToBeDone {id: "job_002"})
// CREATE (je)-[:EXECUTES_JOB {
//     executionContext: "[CONTEXT]", 
//     executionFrequency: "weekly"
// }]->(job);

// =====================================================

// 7. Value Propositions to Jobs to be Done (ADDRESSES_JOB)
// Show how your value propositions address customer jobs
MATCH (vp:ValueProposition {id: "vp_001"}), (job:JobToBeDone {id: "job_001"})
CREATE (vp)-[:ADDRESSES_JOB {
    jobSolutionFit: "strong"                         // Change: strong, medium, weak
}]->(job);

// Template for additional job addressing relationships:
// MATCH (vp:ValueProposition {id: "vp_002"}), (job:JobToBeDone {id: "job_002"})
// CREATE (vp)-[:ADDRESSES_JOB {jobSolutionFit: "strong"}]->(job);

// =====================================================
// CUSTOMER INTERACTION RELATIONSHIPS
// =====================================================

// 8. Customer Segments to Channels (REACHES_THROUGH)
// Show how you reach each customer segment through different channels
MATCH (cs:CustomerSegment {id: "cs_001"}), (ch:Channel {id: "ch_001"})
CREATE (cs)-[:REACHES_THROUGH]->(ch);

// Template for multiple channels per segment:
// MATCH (cs:CustomerSegment {id: "cs_001"}), (ch:Channel {id: "ch_002"})
// CREATE (cs)-[:REACHES_THROUGH]->(ch);
//
// MATCH (cs:CustomerSegment {id: "cs_002"}), (ch:Channel {id: "ch_001"})
// CREATE (cs)-[:REACHES_THROUGH]->(ch);

// =====================================================

// 9. Customer Segments to Customer Relationships (HAS_RELATIONSHIP_WITH)
// Define the relationship types you have with each customer segment
MATCH (cs:CustomerSegment {id: "cs_001"}), (cr:CustomerRelationship {id: "cr_001"})
CREATE (cs)-[:HAS_RELATIONSHIP_WITH]->(cr);

// Template for additional relationships:
// MATCH (cs:CustomerSegment {id: "cs_002"}), (cr:CustomerRelationship {id: "cr_002"})
// CREATE (cs)-[:HAS_RELATIONSHIP_WITH]->(cr);

// =====================================================

// 10. Customer Segments to Revenue Streams (GENERATES)
// Show how each customer segment contributes to revenue
MATCH (cs:CustomerSegment {id: "cs_001"}), (rs:RevenueStream {id: "rs_001"})
CREATE (cs)-[:GENERATES {
    contribution: 60.0                               // Change: Percentage contribution to this revenue stream
}]->(rs);

// Template for additional revenue relationships:
// MATCH (cs:CustomerSegment {id: "cs_002"}), (rs:RevenueStream {id: "rs_002"})
// CREATE (cs)-[:GENERATES {contribution: 40.0}]->(rs);
//
// MATCH (cs:CustomerSegment {id: "cs_001"}), (rs:RevenueStream {id: "rs_002"})
// CREATE (cs)-[:GENERATES {contribution: 25.0}]->(rs);

// =====================================================
// RESOURCE AND ACTIVITY DEPENDENCIES
// =====================================================

// 11. Value Propositions to Key Resources (REQUIRES_RESOURCE)
// Show which resources are needed to deliver each value proposition
MATCH (vp:ValueProposition {id: "vp_001"}), (kr:KeyResource {id: "kr_001"})
CREATE (vp)-[:REQUIRES_RESOURCE {
    dependency: "critical"                           // Change: critical, high, medium, low
}]->(kr);

// Template for additional resource dependencies:
// MATCH (vp:ValueProposition {id: "vp_001"}), (kr:KeyResource {id: "kr_002"})
// CREATE (vp)-[:REQUIRES_RESOURCE {dependency: "high"}]->(kr);
//
// MATCH (vp:ValueProposition {id: "vp_002"}), (kr:KeyResource {id: "kr_003"})
// CREATE (vp)-[:REQUIRES_RESOURCE {dependency: "medium"}]->(kr);

// =====================================================

// 12. Value Propositions to Key Activities (REQUIRES_ACTIVITY)
// Show which activities are needed to deliver each value proposition
MATCH (vp:ValueProposition {id: "vp_001"}), (ka:KeyActivity {id: "ka_001"})
CREATE (vp)-[:REQUIRES_ACTIVITY {
    criticality: "critical"                          // Change: critical, high, medium, low
}]->(ka);

// Template for additional activity dependencies:
// MATCH (vp:ValueProposition {id: "vp_002"}), (ka:KeyActivity {id: "ka_002"})
// CREATE (vp)-[:REQUIRES_ACTIVITY {criticality: "high"}]->(ka);

// =====================================================

// 13. Key Activities to Key Resources (USES_RESOURCE)
// Show which resources are used by which activities
MATCH (ka:KeyActivity {id: "ka_001"}), (kr:KeyResource {id: "kr_001"})
CREATE (ka)-[:USES_RESOURCE {
    usage: "[DESCRIBE HOW RESOURCE IS USED]"         // Change: Describe how the resource is used
}]->(kr);

// Template for additional resource usage:
// MATCH (ka:KeyActivity {id: "ka_002"}), (kr:KeyResource {id: "kr_002"})
// CREATE (ka)-[:USES_RESOURCE {usage: "[USAGE DESCRIPTION]"}]->(kr);

// =====================================================
// PARTNERSHIP RELATIONSHIPS
// =====================================================

// 14. Key Partnerships to Key Resources (ENABLES)
// Show how partnerships provide access to key resources
MATCH (kp:KeyPartnership {id: "kp_001"}), (kr:KeyResource {id: "kr_001"})
CREATE (kp)-[:ENABLES {
    accessType: "infrastructure"                     // Change: infrastructure, data, expertise, funding, etc.
}]->(kr);

// Template for additional partnership-resource relationships:
// MATCH (kp:KeyPartnership {id: "kp_002"}), (kr:KeyResource {id: "kr_002"})
// CREATE (kp)-[:ENABLES {accessType: "expertise"}]->(kr);

// =====================================================

// 15. Key Partnerships to Key Activities (SUPPORTS)
// Show how partnerships support key activities
MATCH (kp:KeyPartnership {id: "kp_001"}), (ka:KeyActivity {id: "ka_001"})
CREATE (kp)-[:SUPPORTS {
    supportLevel: "high"                             // Change: high, medium, low
}]->(ka);

// Template for additional partnership-activity relationships:
// MATCH (kp:KeyPartnership {id: "kp_002"}), (ka:KeyActivity {id: "ka_002"})
// CREATE (kp)-[:SUPPORTS {supportLevel: "medium"}]->(ka);

// =====================================================
// COST STRUCTURE RELATIONSHIPS
// =====================================================

// 16. Key Resources to Cost Structures (INCURS_COST)
// Show how resources drive costs
MATCH (kr:KeyResource {id: "kr_001"}), (cost:CostStructure {id: "cost_001"})
CREATE (kr)-[:INCURS_COST {
    costDriver: "[WHAT DRIVES THE COST]"             // Change: Describe what about this resource drives cost
}]->(cost);

// Template for additional resource costs:
// MATCH (kr:KeyResource {id: "kr_002"}), (cost:CostStructure {id: "cost_002"})
// CREATE (kr)-[:INCURS_COST {costDriver: "[COST DRIVER]"}]->(cost);

// =====================================================

// 17. Key Activities to Cost Structures (INCURS_COST)
// Show how activities drive costs
MATCH (ka:KeyActivity {id: "ka_001"}), (cost:CostStructure {id: "cost_001"})
CREATE (ka)-[:INCURS_COST {
    costDriver: "[WHAT ABOUT THIS ACTIVITY DRIVES COST]" // Change: Describe activity cost drivers
}]->(cost);

// Template for additional activity costs:
// MATCH (ka:KeyActivity {id: "ka_002"}), (cost:CostStructure {id: "cost_003"})
// CREATE (ka)-[:INCURS_COST {costDriver: "[COST DRIVER]"}]->(cost);

// =====================================================

// 18. Channels to Cost Structures (INCURS_COST)
// Show how channels drive costs
MATCH (ch:Channel {id: "ch_001"}), (cost:CostStructure {id: "cost_002"})
CREATE (ch)-[:INCURS_COST {
    costDriver: "[WHAT ABOUT THIS CHANNEL DRIVES COST]" // Change: Describe channel cost drivers
}]->(cost);

// Template for additional channel costs:
// MATCH (ch:Channel {id: "ch_002"}), (cost:CostStructure {id: "cost_003"})
// CREATE (ch)-[:INCURS_COST {costDriver: "[COST DRIVER]"}]->(cost);

// =====================================================
// BATCH RELATIONSHIP CREATION EXAMPLES
// =====================================================

// Example: Connect one value proposition to multiple customer segments
// MATCH (vp:ValueProposition {id: "vp_001"})
// MATCH (cs1:CustomerSegment {id: "cs_001"}), (cs2:CustomerSegment {id: "cs_002"})
// CREATE (vp)-[:TARGETS]->(cs1), (vp)-[:TARGETS]->(cs2);

// Example: Connect one customer segment to multiple channels
// MATCH (cs:CustomerSegment {id: "cs_001"})
// MATCH (ch1:Channel {id: "ch_001"}), (ch2:Channel {id: "ch_002"}), (ch3:Channel {id: "ch_003"})
// CREATE (cs)-[:REACHES_THROUGH]->(ch1), 
//        (cs)-[:REACHES_THROUGH]->(ch2), 
//        (cs)-[:REACHES_THROUGH]->(ch3);

// Example: Connect multiple resources to one cost structure
// MATCH (cost:CostStructure {id: "cost_001"})
// MATCH (kr1:KeyResource {id: "kr_001"}), (kr2:KeyResource {id: "kr_002"})
// CREATE (kr1)-[:INCURS_COST {costDriver: "development costs"}]->(cost),
//        (kr2)-[:INCURS_COST {costDriver: "personnel costs"}]->(cost);

// =====================================================
// VALIDATION AND COMPLETION CHECK
// =====================================================

// After creating all relationships, run these queries to verify completeness:

// 1. Check relationship type coverage (should show 17+ types)
// MATCH ()-[r]->() 
// RETURN type(r) as RelationshipType, count(r) as Count 
// ORDER BY RelationshipType;

// 2. Verify JTBD integration for all customer segments
// MATCH (cs:CustomerSegment)
// OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB_EXECUTOR]->(je:JobExecutor)
// OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB]->(job:JobToBeDone)
// RETURN cs.name as Segment, 
//        je.name as JobExecutor, 
//        job.jobStatement as Job;

// 3. Check channel type distribution
// MATCH (cs:CustomerSegment)-[:REACHES_THROUGH]->(ch:Channel)
// RETURN ch.channelType as ChannelType, 
//        collect(DISTINCT ch.name) as Channels,
//        count(DISTINCT cs) as SegmentsReached;

// =====================================================
// RELATIONSHIP CREATION CHECKLIST
// =====================================================

// Core Business Model (3 relationship types):
// [ ] HAS_VALUE_PROPOSITION: BusinessModel → ValueProposition
// [ ] HAS_CUSTOMER_SEGMENT: BusinessModel → CustomerSegment  
// [ ] TARGETS: ValueProposition → CustomerSegment

// JTBD Integration (4 relationship types):
// [ ] DEFINED_BY_JOB_EXECUTOR: CustomerSegment → JobExecutor
// [ ] DEFINED_BY_JOB: CustomerSegment → JobToBeDone
// [ ] EXECUTES_JOB: JobExecutor → JobToBeDone
// [ ] ADDRESSES_JOB: ValueProposition → JobToBeDone

// Customer Interaction (3 relationship types):
// [ ] REACHES_THROUGH: CustomerSegment → Channel
// [ ] HAS_RELATIONSHIP_WITH: CustomerSegment → CustomerRelationship
// [ ] GENERATES: CustomerSegment → RevenueStream

// Operations (3 relationship types):
// [ ] REQUIRES_RESOURCE: ValueProposition → KeyResource
// [ ] REQUIRES_ACTIVITY: ValueProposition → KeyActivity
// [ ] USES_RESOURCE: KeyActivity → KeyResource

// Partnerships (2 relationship types):
// [ ] ENABLES: KeyPartnership → KeyResource
// [ ] SUPPORTS: KeyPartnership → KeyActivity

// Cost Structure (3 relationship types):
// [ ] INCURS_COST: KeyResource → CostStructure
// [ ] INCURS_COST: KeyActivity → CostStructure  
// [ ] INCURS_COST: Channel → CostStructure

// =====================================================
// Total: 18 relationship types minimum
// Goal: Every relationship type represented in your business model
// =====================================================

// USAGE INSTRUCTIONS:
// 1. Create all nodes first using node-templates.cypher
// 2. Copy relevant relationship templates from above
// 3. Update node IDs to match your actual node IDs
// 4. Customize property values for your business context
// 5. Execute relationship creation queries in Neo4j
// 6. Run validation queries to ensure completeness
// 7. Verify all 18+ relationship types are present

// NEXT STEPS:
// After creating all relationships, use validation-queries.cypher 
// to verify your business model is complete and properly connected.