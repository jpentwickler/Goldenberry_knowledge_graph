// =====================================================
// Goldenberry Flow - Validation and Analysis Queries
// Use these queries to validate completeness and analyze business insights
// =====================================================

// =====================================================
// VALIDATION QUERIES - VERIFY COMPLETENESS
// =====================================================

// 1. Display business model summary
MATCH (bm:BusinessModel {id: "bm_goldenberry_flow"})
RETURN "✅ Goldenberry Flow Digital Trust Export Platform" as Status,
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

// 7. Validate Value Proposition to JTBD alignment
MATCH (vp:ValueProposition)-[:ADDRESSES_JOB]->(job:JobToBeDone)
MATCH (cs:CustomerSegment)-[:DEFINED_BY_JOB]->(job)
RETURN "Value Prop - JTBD Alignment:" as Check,
       vp.title as ValueProposition,
       job.jobStatement as JobAddressed,
       cs.name as CustomerSegment
ORDER BY vp.title;

// =====================================================
// BUSINESS ANALYSIS QUERIES
// =====================================================

// 8. Cost structure frequency analysis
MATCH (cost:CostStructure)
RETURN "Cost Structure Frequency Analysis:" as Category,
       cost.frequency as Frequency,
       count(cost) as CostCount
ORDER BY CostCount DESC;

// 9. Cost structure analysis by category
MATCH (cost:CostStructure)
RETURN cost.category as CostCategory,
       cost.type as CostType,
       count(cost) as NumberOfCosts,
       collect(cost.name) as CostItems
ORDER BY NumberOfCosts DESC;

// 10. Revenue stream analysis
MATCH (rs:RevenueStream)
RETURN rs.name as RevenueStream,
       rs.type as Type,
       rs.frequency as Frequency,
       rs.description as Description
ORDER BY rs.name;

// 11. Show customer segment job alignment with value propositions
MATCH (cs:CustomerSegment)-[:DEFINED_BY_JOB]->(job:JobToBeDone)
MATCH (vp:ValueProposition)-[:ADDRESSES_JOB]->(job)
RETURN cs.name as CustomerSegment,
       job.jobStatement as PrimaryJob,
       collect(vp.title) as AddressingValueProps
ORDER BY cs.name;

// 12. Channel analysis by type and customer segment
MATCH (cs:CustomerSegment)-[:REACHES_THROUGH]->(ch:Channel)
RETURN cs.name as CustomerSegment,
       ch.channelType as ChannelType,
       collect(ch.name) as Channels
ORDER BY cs.name, ch.channelType;

// 13. Key resource dependency analysis
MATCH (vp:ValueProposition)-[:REQUIRES_RESOURCE]->(kr:KeyResource)
RETURN vp.title as ValueProposition,
       kr.type as ResourceType,
       collect(kr.name) as RequiredResources
ORDER BY vp.title;

// 14. Partnership value analysis
MATCH (kp:KeyPartnership)
RETURN kp.name as Partnership,
       kp.type as Type,
       kp.motivation as Motivation,
       kp.description as Description
ORDER BY kp.name;

// 15. Cost attribution analysis - which activities/resources drive costs
MATCH (source)-[r:INCURS_COST]->(cost:CostStructure)
RETURN cost.name as CostCategory,
       cost.category as CostCategoryType,
       labels(source)[0] as CostDriver,
       source.name as SpecificDriver,
       r.costDriver as DriverDescription,
       cost.costDriver as CostDriverDetails
ORDER BY cost.category, cost.name;

// =====================================================
// STRATEGIC ANALYSIS QUERIES
// =====================================================

// 16. Dual-segment business model analysis
MATCH (cs:CustomerSegment)
OPTIONAL MATCH (cs)-[:GENERATES]->(rs:RevenueStream)
OPTIONAL MATCH (cs)-[:REACHES_THROUGH]->(ch:Channel)
OPTIONAL MATCH (cs)-[:HAS_RELATIONSHIP_WITH]->(cr:CustomerRelationship)
RETURN cs.name as CustomerSegment,
       count(DISTINCT rs) as RevenueStreams,
       count(DISTINCT ch) as Channels,
       count(DISTINCT cr) as RelationshipTypes,
       collect(DISTINCT cr.type) as RelationshipStyle
ORDER BY cs.name;

// 17. Digital trust platform dependency analysis
MATCH (kr:KeyResource {id: "kr_digital_trust_platform"})
OPTIONAL MATCH (vp:ValueProposition)-[:REQUIRES_RESOURCE]->(kr)
OPTIONAL MATCH (ka:KeyActivity)-[:USES_RESOURCE]->(kr)
OPTIONAL MATCH (kp:KeyPartnership)-[:ENABLES]->(kr)
RETURN "Digital Trust Platform Analysis" as Analysis,
       collect(DISTINCT vp.title) as ValuePropsDependent,
       collect(DISTINCT ka.name) as ActivitiesDependent,
       collect(DISTINCT kp.name) as PartnershipsEnabling;

// 18. Export operations infrastructure analysis
MATCH (kr:KeyResource {id: "kr_export_operations_infrastructure"})
OPTIONAL MATCH (vp:ValueProposition)-[:REQUIRES_RESOURCE]->(kr)
OPTIONAL MATCH (ka:KeyActivity)-[:USES_RESOURCE]->(kr)
OPTIONAL MATCH (kp:KeyPartnership)-[:ENABLES]->(kr)
RETURN "Export Operations Analysis" as Analysis,
       collect(DISTINCT vp.title) as ValuePropsDependent,
       collect(DISTINCT ka.name) as ActivitiesDependent,
       collect(DISTINCT kp.name) as PartnershipsEnabling;

// 19. Channel effectiveness by customer segment
MATCH (cs:CustomerSegment)-[:REACHES_THROUGH]->(ch:Channel)
RETURN cs.name as CustomerSegment,
       ch.channelType as ChannelType,
       ch.medium as Medium,
       ch.ownership as Ownership,
       count(ch) as ChannelCount
ORDER BY cs.name, ch.channelType;

// 20. Complete business model network visualization query
MATCH (bm:BusinessModel)-[:HAS_VALUE_PROPOSITION]->(vp:ValueProposition)-[:TARGETS]->(cs:CustomerSegment)
MATCH (cs)-[:DEFINED_BY_JOB_EXECUTOR]->(je:JobExecutor)-[:EXECUTES_JOB]->(job:JobToBeDone)
MATCH (vp)-[:ADDRESSES_JOB]->(job)
RETURN "Business Model Network:" as Analysis,
       bm.name as BusinessModel,
       collect(DISTINCT vp.title) as ValuePropositions,
       collect(DISTINCT cs.name) as CustomerSegments,
       collect(DISTINCT je.name) as JobExecutors,
       collect(DISTINCT job.jobStatement) as JobsToBeDone;

// =====================================================
// VALIDATION SUMMARY
// =====================================================

// 21. Exact node count verification
MATCH (n)
WITH labels(n)[0] as NodeType, count(n) as Count
WHERE NodeType IN [
    'BusinessModel', 'ValueProposition', 'CustomerSegment',
    'JobExecutor', 'JobToBeDone', 'Channel',
    'CustomerRelationship', 'RevenueStream', 'KeyResource',
    'KeyActivity', 'KeyPartnership', 'CostStructure'
]
WITH collect({nodeType: NodeType, count: Count}) as nodeCounts
RETURN "📊 EXACT NODE COUNT VERIFICATION" as Check,
       nodeCounts as NodeCounts,
       "Expected: BusinessModel(1), ValueProposition(2), CustomerSegment(2), JobExecutor(2), JobToBeDone(2), Channel(28), CustomerRelationship(2), RevenueStream(3), KeyResource(5), KeyActivity(6), KeyPartnership(5), CostStructure(33)" as ExpectedCounts;

// 22. Cost structure category distribution validation
MATCH (cost:CostStructure)
WITH cost.category as Category, count(cost) as Count, collect(cost.name) as CostNames
RETURN "💰 COST STRUCTURE VALIDATION" as Check,
       Category as CostCategory,
       Count as ActualCount,
       CASE Category
           WHEN "Direct Product Costs" THEN "Expected: 8"
           WHEN "Export Operations Overhead" THEN "Expected: 6"
           WHEN "Digital Trust Infrastructure" THEN "Expected: 6"
           WHEN "Trust Administration & Governance" THEN "Expected: 5"
           WHEN "Financial Operations" THEN "Expected: 4"
           WHEN "Risk Management & Contingency" THEN "Expected: 4"
           ELSE "Unknown Category"
       END as ExpectedCount,
       CostNames as CostItems
ORDER BY Category;

// 23. Complete validation summary
MATCH (bm:BusinessModel)
WITH bm,
     [(n) WHERE labels(n)[0] IN ['BusinessModel', 'ValueProposition', 'CustomerSegment', 'JobExecutor', 'JobToBeDone', 'Channel', 'CustomerRelationship', 'RevenueStream', 'KeyResource', 'KeyActivity', 'KeyPartnership', 'CostStructure'] | labels(n)[0]] as nodeTypes
WITH bm, size(apoc.coll.toSet(nodeTypes)) as uniqueNodeTypes
MATCH ()-[r]->()
WITH bm, uniqueNodeTypes, collect(DISTINCT type(r)) as relationshipTypes
MATCH (ch:Channel)
WITH bm, uniqueNodeTypes, relationshipTypes, collect(DISTINCT ch.channelType) as channelTypes
MATCH (cs:CustomerSegment)
OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB_EXECUTOR]->()
OPTIONAL MATCH (cs)-[:DEFINED_BY_JOB]->()
WITH bm, uniqueNodeTypes, relationshipTypes, channelTypes, count(cs) as totalSegments,
     sum(CASE WHEN exists((cs)-[:DEFINED_BY_JOB_EXECUTOR]->()) THEN 1 ELSE 0 END) as segmentsWithExecutors,
     sum(CASE WHEN exists((cs)-[:DEFINED_BY_JOB]->()) THEN 1 ELSE 0 END) as segmentsWithJobs
RETURN "🎯 GOLDENBERRY FLOW VALIDATION SUMMARY" as ValidationSummary,
       "Business Model: " + bm.name as BusinessModelName,
       "Node Types: " + toString(uniqueNodeTypes) + "/12" as NodeTypesStatus,
       "Relationships: " + toString(size(relationshipTypes)) + " types" as RelationshipStatus,
       "Channel Coverage: " + toString(size(channelTypes)) + "/3 types (" + apoc.text.join(channelTypes, ", ") + ")" as ChannelStatus,
       "JTBD Integration: " + toString(segmentsWithExecutors) + "/" + toString(totalSegments) + " segments with executors, " + toString(segmentsWithJobs) + "/" + toString(totalSegments) + " segments with jobs" as JTBDStatus,
       CASE WHEN uniqueNodeTypes = 12 AND size(channelTypes) = 3 AND segmentsWithExecutors = totalSegments AND segmentsWithJobs = totalSegments
            THEN "✅ FULLY COMPLIANT - Ready for Strategic Analysis"
            ELSE "⚠️ VALIDATION ISSUES DETECTED" END as OverallStatus;

-- =====================================
-- RELATIONSHIP INTEGRITY VALIDATION
-- =====================================
-- CRITICAL: Detect and prevent Cartesian product relationships

-- Query 22: Validate TimePeriod relationship counts
MATCH (tp:TimePeriod)<-[:OCCURS_IN_PERIOD]-(vd:VolumeData)
WITH tp, count(vd) as VolumeCount
WHERE VolumeCount != 3
RETURN tp.id as ProblematicTimePeriod, VolumeCount as ActualVolumeConnections, "Each TimePeriod should connect to exactly 3 VolumeData nodes" as ExpectedPattern
UNION
MATCH (tp:TimePeriod)<-[:PRICED_IN_PERIOD]-(pd:PriceData)
WITH tp, count(pd) as PriceCount
WHERE PriceCount != 3
RETURN tp.id as ProblematicTimePeriod, PriceCount as ActualPriceConnections, "Each TimePeriod should connect to exactly 3 PriceData nodes" as ExpectedPattern;

-- Query 23: Total relationship count validation
MATCH (tp:TimePeriod)-[r1]-(vd:VolumeData)
MATCH (tp:TimePeriod)-[r2]-(pd:PriceData)
RETURN
    "Time-Series Relationships" as ValidationCategory,
    count(r1) as VolumeDataRelationships,
    count(r2) as PriceDataRelationships,
    count(r1) + count(r2) as TotalTimeSeriesRelationships,
    CASE WHEN count(r1) = 39 AND count(r2) = 39
         THEN "✅ CORRECT: 78 total relationships"
         ELSE "❌ INCORRECT: Expected 78 total (39 VolumeData + 39 PriceData)" END as Status;

-- Query 24: Duplicate node detection
MATCH (vd:VolumeData)
WITH vd.id as id, count(vd) as nodeCount
WHERE nodeCount > 1
RETURN "Duplicate VolumeData" as IssueType, id as DuplicateNodeId, nodeCount as DuplicateCount, "Remove duplicate nodes immediately" as Action
UNION
MATCH (pd:PriceData)
WITH pd.id as id, count(pd) as nodeCount
WHERE nodeCount > 1
RETURN "Duplicate PriceData" as IssueType, id as DuplicateNodeId, nodeCount as DuplicateCount, "Remove duplicate nodes immediately" as Action;

-- Query 25: Monthly data coverage validation
MATCH (tp:TimePeriod)
OPTIONAL MATCH (tp)<-[:OCCURS_IN_PERIOD]-(vd:VolumeData)
OPTIONAL MATCH (tp)<-[:PRICED_IN_PERIOD]-(pd:PriceData)
WITH tp, count(DISTINCT vd) as VolumeDataCount, count(DISTINCT pd) as PriceDataCount
WHERE VolumeDataCount != 3 OR PriceDataCount != 3
RETURN tp.id as TimePeriodId, tp.year as Year, tp.month as Month,
       VolumeDataCount as ActualVolumeNodes, PriceDataCount as ActualPriceNodes,
       "Each month should have exactly 3 VolumeData and 3 PriceData nodes" as Expected;

-- Query 26: Revenue calculation integrity check
MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p:Product)
WITH p.name as Product, SUM(vd.volume) as TotalVolume, p.baseUnitPrice as Price
WITH Product, TotalVolume, Price, ROUND(TotalVolume * Price, 2) as CalculatedRevenue
RETURN "Revenue Integrity" as ValidationCategory,
       Product,
       TotalVolume as TotalVolumeKg,
       Price as PricePerKg,
       CalculatedRevenue as TotalRevenueUSD,
       CASE
         WHEN Product = "Pitahaya (Dragon Fruit)" AND CalculatedRevenue = 1223260.86 THEN "✅ CORRECT"
         WHEN Product = "Goldenberries (Physalis)" AND CalculatedRevenue = 1033113.69 THEN "✅ CORRECT"
         WHEN Product = "Exotic Fruits Mix" AND CalculatedRevenue = 82500.00 THEN "✅ CORRECT"
         ELSE "❌ REVENUE CALCULATION ERROR"
       END as Status
ORDER BY CalculatedRevenue DESC;