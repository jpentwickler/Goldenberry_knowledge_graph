// =====================================================
// CycleWorks Bike Shop - Validation and Analysis Queries
// Use these queries to validate completeness and analyze business insights
// =====================================================

// =====================================================
// VALIDATION QUERIES - VERIFY COMPLETENESS
// =====================================================

// 1. Display business model summary
MATCH (bm:BusinessModel {id: "bm_cycleworks"})
RETURN "✅ CycleWorks Bike Shop Business Model" as Status,
       bm.name as BusinessName,
       bm.description as Description;

// 2. Check all 12 node types are present
MATCH (n)
WITH labels(n)[0] as NodeType, count(n) as Count
WHERE NodeType IN [
    'BusinessModel', 'ValueProposition', 'CustomerSegment', 
    'JobExecutor', 'JobToBeDone', 'Channel', 
    'CustomerRelationship', 'RevenueStream', 'KeyResource', 
    'KeyActivity', 'KeyPartnership', 'CostStructure'
]
RETURN "Node Type Coverage:" as Check,
       collect(NodeType + ": " + toString(Count)) as NodeTypes,
       count(NodeType) as TypesPresent,
       "Target: 12 types" as Target
ORDER BY TypesPresent DESC;

// 3. Show relationship type coverage (should show 16+ types)
MATCH ()-[r]->() 
RETURN type(r) as RelationshipType, count(r) as Count 
ORDER BY RelationshipType;

// 4. Verify all 3 channel types are present
MATCH (ch:Channel)
RETURN "Channel Type Coverage:" as Check,
       collect(DISTINCT ch.channelType) as ChannelTypes,
       count(DISTINCT ch.channelType) as TypesPresent,
       "Target: 3 types (acquisition, delivery, retention)" as Target;

// 5. Verify JTBD integration for all customer segments
MATCH (cs:CustomerSegment)
OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB_EXECUTOR]->(je:JobExecutor)
OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB]->(job:JobToBeDone)
WITH cs, 
     CASE WHEN je IS NOT NULL THEN 1 ELSE 0 END as HasExecutor,
     CASE WHEN job IS NOT NULL THEN 1 ELSE 0 END as HasJob
RETURN "JTBD Integration Check:" as Check,
       count(cs) as TotalSegments,
       sum(HasExecutor) as SegmentsWithExecutors,
       sum(HasJob) as SegmentsWithJobs,
       CASE WHEN sum(HasExecutor) = count(cs) AND sum(HasJob) = count(cs) 
            THEN "✅ Complete" 
            ELSE "❌ Incomplete" END as Status;

// 6. Verify JTBD integration details
MATCH (cs:CustomerSegment)
OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB_EXECUTOR]->(je:JobExecutor)
OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB]->(job:JobToBeDone)
RETURN cs.name as CustomerSegment, 
       je.name as JobExecutor, 
       job.jobStatement as JobToBeDone
ORDER BY cs.name;

// =====================================================
// BUSINESS ANALYSIS QUERIES
// =====================================================

// 7. Calculate total monthly costs
MATCH (cost:CostStructure)
WHERE cost.frequency = "monthly"
RETURN "Financial Summary:" as Category,
       "Total Monthly Costs: $" + toString(sum(cost.amount)) as MonthlyCosts;

// 8. Cost structure analysis by category
MATCH (cost:CostStructure)
RETURN cost.category as CostCategory,
       cost.type as CostType,
       sum(cost.amount) as TotalAmount,
       count(cost) as NumberOfCosts
ORDER BY TotalAmount DESC;

// 9. Revenue stream analysis
MATCH (rs:RevenueStream)
RETURN rs.name as RevenueStream,
       rs.type as Type,
       "$" + toString(rs.amount) as Amount,
       rs.frequency as Frequency
ORDER BY rs.amount DESC;

// 10. Show customer segment job alignment
MATCH (cs:CustomerSegment)-[:DEFINED_BY_JOB]->(job:JobToBeDone)
MATCH (vp:ValueProposition)-[:ADDRESSES_JOB]->(job)
RETURN cs.name as CustomerSegment,
       job.jobStatement as PrimaryJob,
       collect(vp.title) as AddressingValueProps
ORDER BY cs.name;

// 11. Analyze channel strategy by segment
MATCH (cs:CustomerSegment)-[:REACHES_THROUGH]->(ch:Channel)
RETURN cs.name as CustomerSegment,
       collect(DISTINCT ch.channelType + ": " + ch.name) as ChannelMix
ORDER BY cs.name;

// 12. Channel type distribution analysis
MATCH (cs:CustomerSegment)-[:REACHES_THROUGH]->(ch:Channel)
RETURN ch.channelType as ChannelType, 
       collect(DISTINCT ch.name) as Channels,
       count(DISTINCT cs) as SegmentsReached
ORDER BY ch.channelType;

// 13. Show value proposition dependencies
MATCH (vp:ValueProposition)
OPTIONAL MATCH (vp)-[:REQUIRES_RESOURCE]->(kr:KeyResource)
OPTIONAL MATCH (vp)-[:REQUIRES_ACTIVITY]->(ka:KeyActivity)
RETURN vp.title as ValueProposition,
       collect(DISTINCT kr.name) as RequiredResources,
       collect(DISTINCT ka.name) as RequiredActivities
ORDER BY vp.title;

// 14. Partnership value analysis
MATCH (kp:KeyPartnership)
OPTIONAL MATCH (kp)-[:ENABLES]->(kr:KeyResource)
OPTIONAL MATCH (kp)-[:SUPPORTS]->(ka:KeyActivity)
RETURN kp.partnerName as Partner,
       kp.type as PartnershipType,
       "$" + toString(kp.value) as AnnualValue,
       count(DISTINCT kr) as ResourcesEnabled,
       count(DISTINCT ka) as ActivitiesSupported
ORDER BY kp.value DESC;

// 15. Resource utilization analysis
MATCH (kr:KeyResource)
OPTIONAL MATCH (vp:ValueProposition)-[:REQUIRES_RESOURCE]->(kr)
OPTIONAL MATCH (ka:KeyActivity)-[:USES_RESOURCE]->(kr)
OPTIONAL MATCH (kp:KeyPartnership)-[:ENABLES]->(kr)
RETURN kr.name as Resource,
       kr.type as ResourceType,
       count(DISTINCT vp) as UsedByValueProps,
       count(DISTINCT ka) as UsedByActivities,
       count(DISTINCT kp) as EnabledByPartnerships
ORDER BY kr.name;

// 16. Cost driver analysis
MATCH (cost:CostStructure)
OPTIONAL MATCH (kr:KeyResource)-[:INCURS_COST]->(cost)
OPTIONAL MATCH (ka:KeyActivity)-[:INCURS_COST]->(cost)
OPTIONAL MATCH (ch:Channel)-[:INCURS_COST]->(cost)
RETURN cost.name as CostCategory,
       cost.type as CostType,
       "$" + toString(cost.amount) as MonthlyAmount,
       count(kr) + count(ka) + count(ch) as NumberOfDrivers,
       collect(DISTINCT kr.name) + collect(DISTINCT ka.name) + collect(DISTINCT ch.name) as CostDrivers
ORDER BY cost.amount DESC;

// =====================================================
// STRATEGIC ANALYSIS QUERIES
// =====================================================

// 17. Customer segment revenue potential
MATCH (cs:CustomerSegment)-[:GENERATES]->(rs:RevenueStream)
RETURN cs.name as CustomerSegment,
       count(rs) as RevenueStreams,
       collect(rs.name + " ($" + toString(rs.amount) + ")") as RevenueDetails
ORDER BY RevenueStreams DESC;

// 18. Value proposition coverage analysis
MATCH (vp:ValueProposition)
OPTIONAL MATCH (vp)-[:TARGETS]->(cs:CustomerSegment)
OPTIONAL MATCH (vp)-[:ADDRESSES_JOB]->(job:JobToBeDone)
RETURN vp.title as ValueProposition,
       count(DISTINCT cs) as CustomerSegments,
       count(DISTINCT job) as JobsAddressed
ORDER BY CustomerSegments DESC, JobsAddressed DESC;

// 19. Activity-resource dependency mapping
MATCH (ka:KeyActivity)-[:USES_RESOURCE]->(kr:KeyResource)
RETURN ka.name as Activity,
       ka.priority as Priority,
       collect(kr.name) as RequiredResources,
       count(kr) as ResourceDependencies
ORDER BY ka.priority, ResourceDependencies DESC;

// 20. Relationship density analysis
MATCH (n)
OPTIONAL MATCH (n)-[r]->()
WITH labels(n)[0] as NodeType, count(n) as NodeCount, count(r) as RelationshipCount
RETURN NodeType,
       NodeCount,
       RelationshipCount,
       CASE WHEN NodeCount > 0 THEN round(toFloat(RelationshipCount) / toFloat(NodeCount) * 100) / 100 
            ELSE 0 END as AvgRelationshipsPerNode
ORDER BY AvgRelationshipsPerNode DESC;

// =====================================================
// SEMANTIC ENHANCEMENT DEMONSTRATION
// =====================================================

// 21. Display semantic descriptions for educational purposes
MATCH (bm:BusinessModel {id: "bm_cycleworks"})
RETURN "Business Model Framework Understanding:" as Category,
       bm.semanticDescription as Definition,
       bm.theoreticalFoundation as ResearchBasis,
       bm.purpose as PracticalApplication;

// 22. Show JTBD theoretical foundation
MATCH (job:JobToBeDone)
RETURN job.jobStatement as JobStatement,
       job.semanticDescription as JTBDTheory,
       job.stabilityCharacteristic as KeyInsight
LIMIT 1;

// 23. Display value proposition research basis
MATCH (vp:ValueProposition)
RETURN vp.title as ValueProposition,
       vp.valueElements as ValueCreationMethods
LIMIT 1;

// =====================================================
// PERFORMANCE AND OPTIMIZATION QUERIES
// =====================================================

// 24. Identify high-cost, high-value components
MATCH (cost:CostStructure)
OPTIONAL MATCH (kr:KeyResource)-[:INCURS_COST]->(cost)
OPTIONAL MATCH (vp:ValueProposition)-[:REQUIRES_RESOURCE]->(kr)
RETURN cost.name as CostCenter,
       cost.amount as MonthlyCost,
       count(DISTINCT vp) as ValuePropsSupported,
       CASE WHEN count(DISTINCT vp) > 0 
            THEN round(cost.amount / count(DISTINCT vp)) 
            ELSE cost.amount END as CostPerValueProp
ORDER BY CostPerValueProp;

// 25. Channel efficiency analysis
MATCH (ch:Channel)
OPTIONAL MATCH (cs:CustomerSegment)-[:REACHES_THROUGH]->(ch)
OPTIONAL MATCH (ch)-[:INCURS_COST]->(cost:CostStructure)
RETURN ch.name as Channel,
       ch.channelType as Type,
       count(DISTINCT cs) as SegmentsReached,
       sum(cost.amount) as MonthlyCost,
       CASE WHEN count(DISTINCT cs) > 0 
            THEN round(sum(cost.amount) / count(DISTINCT cs)) 
            ELSE sum(cost.amount) END as CostPerSegment
ORDER BY CostPerSegment;

// =====================================================
// FINAL COMPLETENESS CHECK
// =====================================================

// 26. Overall completeness summary
MATCH (n)
WITH labels(n)[0] as NodeType, count(n) as NodeCount
WITH collect({type: NodeType, count: NodeCount}) as NodeSummary
MATCH ()-[r]->()
WITH NodeSummary, count(DISTINCT type(r)) as RelationshipTypes, count(r) as TotalRelationships
RETURN "🎉 CycleWorks Knowledge Graph Complete!" as Status,
       size(NodeSummary) as NodeTypesPresent,
       "Target: 12" as NodeTarget,
       RelationshipTypes as RelationshipTypesPresent,
       "Target: 16+" as RelationshipTarget,
       TotalRelationships as TotalRelationships,
       "Ready for business analysis!" as FinalStatus;