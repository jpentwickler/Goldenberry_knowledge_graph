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

// =====================================================
// COST DATA VALIDATION QUERIES
// Added: 2025-09-30
// Source: complete_cost_data_integration.cypher
// =====================================================
// These queries validate the cost data integration
// from Cash_Flow_Model_v2.xlsx
// Run after executing cost data integration phases
// =====================================================

// Query 27: Verify CostData schema objects (Phase 1)
// Validates that constraints and indexes were created
// Expected: cost_data_id constraint, cost_data_period index
SHOW CONSTRAINTS WHERE name CONTAINS 'cost_data'
YIELD name, type
WITH collect({name: name, type: type}) as constraints
CALL {
  SHOW INDEXES WHERE name CONTAINS 'cost_data'
  YIELD name, type
  RETURN collect({name: name, type: type}) as indexes
}
RETURN "💾 COST DATA SCHEMA VALIDATION" as Check,
       constraints as Constraints,
       indexes as Indexes,
       CASE
         WHEN size(constraints) >= 1 AND size(indexes) >= 1
         THEN "✅ Phase 1 Complete: Schema objects created"
         ELSE "❌ ERROR: Schema objects missing"
       END as Phase1Status;

// Query 28: Verify CostData node count (Phases 2-4)
// Validates progressive data loading across phases
// Phase 1: 0 nodes (schema only)
// Phase 2: 52 nodes (personnel costs)
// Phase 3: 60 nodes (+ one-time events)
// Phase 4: 99 nodes (+ variable product costs)
MATCH (cd:CostData)
WITH count(cd) as ActualNodes,
     CASE
       WHEN count(cd) = 0 THEN "Phase 1: Schema only ✅"
       WHEN count(cd) = 52 THEN "Phase 2: Personnel costs ✅"
       WHEN count(cd) = 60 THEN "Phase 3: + One-time events ✅"
       WHEN count(cd) = 99 THEN "Phase 4: Complete ✅"
       ELSE "⚠️ Unexpected node count"
     END as PhaseStatus
RETURN "📊 COST DATA NODE COUNT" as Check,
       ActualNodes as CostDataNodes,
       "Target: 99 (after Phase 4)" as FinalTarget,
       PhaseStatus as CurrentPhase;

// Query 29: Detailed Personnel Cost Validation (Phase 2)
// Validates all personnel cost data in detail
// Expected: 52 nodes, 4 categories, $46,800 total, 104 relationships
// Part A: Node count by category
MATCH (cd:CostData)
WHERE cd.category STARTS WITH 'Personnel'
WITH cd.category as Category,
     count(cd) as NodeCount,
     SUM(cd.amount) as CategoryTotal
RETURN "📊 PERSONNEL COST BY CATEGORY" as Check,
       collect({
         category: Category,
         nodes: NodeCount,
         total: CategoryTotal,
         expected_nodes: 13,
         expected_total: CASE Category
           WHEN 'Personnel - Management' THEN 11050.0
           WHEN 'Personnel - Commercial' THEN 19500.0
           WHEN 'Personnel - Accounting' THEN 9100.0
           WHEN 'Personnel - Administrative' THEN 7150.0
           ELSE 0.0
         END,
         status: CASE
           WHEN NodeCount = 13 AND CategoryTotal = CASE Category
             WHEN 'Personnel - Management' THEN 11050.0
             WHEN 'Personnel - Commercial' THEN 19500.0
             WHEN 'Personnel - Accounting' THEN 9100.0
             WHEN 'Personnel - Administrative' THEN 7150.0
             ELSE 0.0
           END THEN '✅'
           ELSE '❌'
         END
       }) as ByCategory;

// Query 29 Part B: Monthly distribution
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category STARTS WITH 'Personnel'
WITH tp.year as Year, tp.month as Month, tp.id as PeriodID,
     count(cd) as NodesPerMonth,
     SUM(cd.amount) as MonthlyTotal
RETURN "📅 MONTHLY PERSONNEL COSTS" as Check,
       PeriodID,
       NodesPerMonth as Nodes,
       MonthlyTotal as Total,
       CASE
         WHEN NodesPerMonth = 4 AND MonthlyTotal = 3600.0
         THEN "✅ Correct"
         ELSE "❌ Expected 4 nodes, $3,600"
       END as Status
ORDER BY Year, Month;

// Query 29 Part C: Relationship verification
MATCH (cd:CostData)-[r1:COST_FOR_STRUCTURE]->(cs:CostStructure)
WHERE cd.category STARTS WITH 'Personnel'
WITH count(r1) as CostForStructureCount
MATCH (cd:CostData)-[r2:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category STARTS WITH 'Personnel'
RETURN "🔗 PERSONNEL RELATIONSHIPS" as Check,
       CostForStructureCount,
       count(r2) as IncurredInPeriodCount,
       CASE
         WHEN CostForStructureCount = 52 AND count(r2) = 52
         THEN "✅ All relationships correct"
         ELSE "❌ Expected 52 of each type"
       END as Status;

// Query 29 Part D: Total validation
MATCH (cd:CostData)
WHERE cd.category STARTS WITH 'Personnel'
RETURN "💰 TOTAL PERSONNEL COSTS" as Check,
       count(cd) as TotalNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 52 AND SUM(cd.amount) = 46800.0
         THEN "✅ Phase 2 Complete"
         ELSE "❌ Expected 52 nodes, $46,800"
       END as ValidationStatus;

// ========================================
// Query 30: Detailed One-Time Events Cost Validation (Phase 3)
// ========================================
// Expected: 8 nodes, 5 categories, $85,780 total
// Validates setup costs, trade shows, and period distribution

// Query 30 Part A: Node count by category
MATCH (cd:CostData)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
WITH cd.category as Category,
     count(cd) as NodeCount,
     SUM(cd.amount) as CategoryTotal
RETURN "📊 ONE-TIME COSTS BY CATEGORY" as Check,
       collect({
         category: Category,
         nodes: NodeCount,
         total: CategoryTotal,
         expected: CASE Category
           WHEN 'Setup & Branding' THEN {nodes: 1, total: 3500.0}
           WHEN 'Product Packaging' THEN {nodes: 1, total: 10000.0}
           WHEN 'Certifications & Compliance' THEN {nodes: 1, total: 10000.0}
           WHEN 'Marketing & Sales' THEN {nodes: 1, total: 1500.0}
           WHEN 'Trade Shows' THEN {nodes: 4, total: 60780.0}
           ELSE {nodes: 0, total: 0.0}
         END,
         status: CASE
           WHEN (Category = 'Setup & Branding' AND NodeCount = 1 AND CategoryTotal = 3500.0)
             OR (Category = 'Product Packaging' AND NodeCount = 1 AND CategoryTotal = 10000.0)
             OR (Category = 'Certifications & Compliance' AND NodeCount = 1 AND CategoryTotal = 10000.0)
             OR (Category = 'Marketing & Sales' AND NodeCount = 1 AND CategoryTotal = 1500.0)
             OR (Category = 'Trade Shows' AND NodeCount = 4 AND CategoryTotal = 60780.0)
           THEN '✅' ELSE '❌'
         END
       }) as ByCategory;

// Query 30 Part B: Period distribution
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
WITH tp.id as Period,
     count(cd) as CostsInPeriod,
     SUM(cd.amount) as PeriodTotal
RETURN "📅 ONE-TIME COSTS BY PERIOD" as Check,
       Period,
       CostsInPeriod as Nodes,
       PeriodTotal as Total,
       CASE
         WHEN Period = 'tp_2024_09' AND CostsInPeriod = 6 AND PeriodTotal = 49080.0
           THEN '✅ Sep 2024: 6 setup costs'
         WHEN Period = 'tp_2024_11' AND CostsInPeriod = 1 AND PeriodTotal = 19300.0
           THEN '✅ Nov 2024: 1 trade show'
         WHEN Period = 'tp_2025_05' AND CostsInPeriod = 1 AND PeriodTotal = 17400.0
           THEN '✅ May 2025: 1 trade show'
         ELSE '❌ Unexpected values'
       END as Status
ORDER BY Period;

// Query 30 Part C: Relationship verification
MATCH (cd:CostData)-[r1:COST_FOR_STRUCTURE]->(cs:CostStructure)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
WITH count(r1) as CostForStructureCount
MATCH (cd:CostData)-[r2:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN "🔗 ONE-TIME EVENT RELATIONSHIPS" as Check,
       CostForStructureCount,
       count(r2) as IncurredInPeriodCount,
       CASE
         WHEN CostForStructureCount = 8 AND count(r2) = 8
         THEN "✅ All relationships correct"
         ELSE "❌ Expected 8 of each type"
       END as Status;

// Query 30 Part D: Total validation
MATCH (cd:CostData)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN "💰 TOTAL ONE-TIME COSTS" as Check,
       count(cd) as TotalNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 8 AND SUM(cd.amount) = 85780.0
         THEN "✅ Phase 3 Complete"
         ELSE "❌ Expected 8 nodes, $85,780"
       END as Phase3Status;

// ========================================
// Query 31: Detailed Variable Product Procurement Validation (Phase 4)
// ========================================
// Expected: 39 nodes, 3 products, $1,965,411 total
// Validates variable costs by product and monthly trends

// Query 31 Part A: Node count by product
MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(p:Product)
WITH p.name as Product,
     count(cd) as NodeCount,
     SUM(cd.amount) as ProductTotal
RETURN "📊 VARIABLE COSTS BY PRODUCT" as Check,
       collect({
         product: Product,
         nodes: NodeCount,
         total: ProductTotal,
         expected_nodes: 13,
         expected_total: CASE Product
           WHEN 'Pitahaya (Dragon Fruit)' THEN 988069.0
           WHEN 'Goldenberries (Physalis)' THEN 912092.0
           WHEN 'Exotic Fruits Mix' THEN 65250.0
           ELSE 0.0
         END,
         status: CASE
           WHEN NodeCount = 13 AND (
             (Product = 'Pitahaya (Dragon Fruit)' AND ProductTotal = 988069.0) OR
             (Product = 'Goldenberries (Physalis)' AND ProductTotal = 912092.0) OR
             (Product = 'Exotic Fruits Mix' AND ProductTotal = 65250.0)
           )
           THEN '✅' ELSE '❌'
         END
       }) as ByProduct
ORDER BY ProductTotal DESC;

// Query 31 Part B: Monthly variable cost trend
MATCH (cd:CostData {costBehavior: 'variable'})-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WITH tp.id as Period,
     tp.year as Year,
     tp.month as Month,
     count(cd) as NodesPerMonth,
     SUM(cd.amount) as MonthlyTotal
RETURN "📈 MONTHLY VARIABLE COST TREND" as Check,
       Period,
       NodesPerMonth as Nodes,
       MonthlyTotal as Total,
       CASE
         WHEN NodesPerMonth = 3
         THEN '✅ 3 products per month'
         ELSE '❌ Expected 3 products'
       END as Status
ORDER BY Year, Month
LIMIT 5;

// Query 31 Part C: COST_FOR_PRODUCT relationship verification
MATCH (cd:CostData)-[r:COST_FOR_PRODUCT]->(p:Product)
WITH p.name as Product, count(r) as RelCount
RETURN "🔗 COST_FOR_PRODUCT RELATIONSHIPS" as Check,
       collect({
         product: Product,
         relationships: RelCount,
         expected: 13,
         status: CASE
           WHEN RelCount = 13 THEN '✅'
           ELSE '❌'
         END
       }) as ProductRelationships;

// Query 31 Part D: Total relationship count
MATCH (cd:CostData {costBehavior: 'variable'})
WITH count(cd) as TotalNodes
MATCH (cd:CostData)-[r1:COST_FOR_STRUCTURE]->(cs:CostStructure {id: 'cs_fruit_procurement'})
WHERE cd.costBehavior = 'variable'
WITH TotalNodes, count(r1) as StructureRels
MATCH (cd:CostData {costBehavior: 'variable'})-[r2:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WITH TotalNodes, StructureRels, count(r2) as PeriodRels
MATCH (cd:CostData)-[r3:COST_FOR_PRODUCT]->(p:Product)
RETURN "🔗 VARIABLE COST RELATIONSHIPS" as Check,
       TotalNodes as VariableNodes,
       StructureRels as CostForStructure,
       PeriodRels as IncurredInPeriod,
       count(r3) as CostForProduct,
       CASE
         WHEN TotalNodes = 39 AND StructureRels = 39 AND PeriodRels = 39 AND count(r3) = 39
         THEN '✅ All 117 relationships correct (39×3)'
         ELSE '❌ ERROR: Expected 39 of each type'
       END as Status;

// Query 31 Part E: Total validation
MATCH (cd:CostData {costBehavior: 'variable'})
RETURN "💰 TOTAL VARIABLE COSTS" as Check,
       count(cd) as TotalNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 39 AND SUM(cd.amount) = 1965411.0
         THEN "✅ Phase 4 Complete"
         ELSE "❌ Expected 39 nodes, $1,965,411"
       END as Phase4Status;