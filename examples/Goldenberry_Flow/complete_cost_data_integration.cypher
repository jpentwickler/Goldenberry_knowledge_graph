// ========================================
// COMPLETE COST DATA INTEGRATION
// Goldenberry Flow - Cost Data from Cash_Flow_Model_v2.xlsx
// ========================================
//
// PREREQUISITES:
// - goldenberry_complete_model.cypher must be loaded first (creates 33 CostStructure nodes)
// - complete_12month_real_data.cypher must be loaded first (creates 13 TimePeriod nodes)
//
// EXECUTION STATUS:
// ✅ Phase 1: Schema Extension (constraints + indexes)
// ✅ Phase 2: Personnel Costs (52 nodes)
// ✅ Phase 3: One-Time Events (8 nodes)
// ✅ Phase 4: Variable Product Costs (39 nodes)
// ⏸️ Phase 5: Validation Queries - NOT YET ADDED
// ⏸️ Phase 6: Analysis Queries - NOT YET ADDED
//
// TARGET STATE:
// - Total CostData nodes: 99 (COMPLETE after Phase 4)
// - Total relationships: 237 (99 COST_FOR_STRUCTURE + 99 INCURRED_IN_PERIOD + 39 COST_FOR_PRODUCT)
// - Total amount: $2,097,991
//
// ========================================

// ----------------------------------------
// PHASE 1: SCHEMA EXTENSION
// ----------------------------------------
// Creates CostData node type with constraints and indexes
// This phase adds no data - only prepares the schema
// Execution time: ~5 seconds
// ----------------------------------------

// Create unique constraint on CostData.id
// Ensures no duplicate cost data entries
CREATE CONSTRAINT cost_data_id IF NOT EXISTS
FOR (cd:CostData) REQUIRE cd.id IS UNIQUE;

// Create index on CostData.period for query performance
// Optimizes monthly/time-based cost queries
CREATE INDEX cost_data_period IF NOT EXISTS
FOR (cd:CostData) ON (cd.period);

// ----------------------------------------
// PHASE 1 VALIDATION
// ----------------------------------------
// Verify schema objects were created successfully
// Expected: CostDataNodes = 0 (no data loaded yet)

MATCH (n) WHERE n:CostData
RETURN count(n) as CostDataNodes,
       CASE
         WHEN count(n) = 0
         THEN '✅ Phase 1 Complete: Schema ready, no data loaded yet'
         ELSE '⚠️ Warning: ' + toString(count(n)) + ' CostData nodes already exist'
       END as Phase1Status;

// ========================================
// END OF PHASE 1
// ========================================

// ----------------------------------------
// PHASE 2: PERSONNEL COSTS - FIXED MONTHLY
// ----------------------------------------
// Creates 52 CostData nodes for personnel expenses
// 4 categories × 13 months = 52 nodes
// Total amount: $46,800
// Execution time: ~30 seconds
// ----------------------------------------

// MANAGER COSTS (13 nodes - $850/month = $11,050 total)
// September 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_manager_2024_09',
    amount: 850.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// October 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
CREATE (cd:CostData {
    id: 'cd_manager_2024_10',
    amount: 850.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// November 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
CREATE (cd:CostData {
    id: 'cd_manager_2024_11',
    amount: 850.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// December 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
CREATE (cd:CostData {
    id: 'cd_manager_2024_12',
    amount: 850.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// January 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_01',
    amount: 850.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// February 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_02',
    amount: 850.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// March 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_03',
    amount: 850.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// April 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_04',
    amount: 850.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// May 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_05',
    amount: 850.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// June 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_06',
    amount: 850.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// July 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_07',
    amount: 850.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// August 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_08',
    amount: 850.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// September 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
CREATE (cd:CostData {
    id: 'cd_manager_2025_09',
    amount: 850.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'fixed',
    category: 'Personnel - Management',
    description: 'Export Operations Manager - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// EXPORT COMMERCIAL COSTS (13 nodes - $1,500/month = $19,500 total)
// September 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2024_09',
    amount: 1500.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// October 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2024_10',
    amount: 1500.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// November 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2024_11',
    amount: 1500.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// December 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2024_12',
    amount: 1500.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// January 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_01',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// February 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_02',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// March 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_03',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// April 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_04',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// May 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_05',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// June 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_06',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// July 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_07',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// August 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_08',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// September 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
CREATE (cd:CostData {
    id: 'cd_export_commercial_2025_09',
    amount: 1500.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'fixed',
    category: 'Personnel - Commercial',
    description: 'Export Commercial specialist salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// ACCOUNTING COSTS (13 nodes - $700/month = $9,100 total)
// September 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_accounting_2024_09',
    amount: 700.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// October 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
CREATE (cd:CostData {
    id: 'cd_accounting_2024_10',
    amount: 700.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// November 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
CREATE (cd:CostData {
    id: 'cd_accounting_2024_11',
    amount: 700.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// December 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
CREATE (cd:CostData {
    id: 'cd_accounting_2024_12',
    amount: 700.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// January 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_01',
    amount: 700.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// February 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_02',
    amount: 700.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// March 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_03',
    amount: 700.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// April 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_04',
    amount: 700.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// May 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_05',
    amount: 700.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// June 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_06',
    amount: 700.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// July 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_07',
    amount: 700.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// August 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_08',
    amount: 700.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// September 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
CREATE (cd:CostData {
    id: 'cd_accounting_2025_09',
    amount: 700.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'fixed',
    category: 'Personnel - Accounting',
    description: 'Accounting services - proportional allocation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// ASSISTANT COSTS (13 nodes - $550/month = $7,150 total)
// September 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_assistant_2024_09',
    amount: 550.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// October 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
CREATE (cd:CostData {
    id: 'cd_assistant_2024_10',
    amount: 550.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// November 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
CREATE (cd:CostData {
    id: 'cd_assistant_2024_11',
    amount: 550.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// December 2024
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
CREATE (cd:CostData {
    id: 'cd_assistant_2024_12',
    amount: 550.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// January 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_01',
    amount: 550.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// February 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_02',
    amount: 550.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// March 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_03',
    amount: 550.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// April 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_04',
    amount: 550.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// May 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_05',
    amount: 550.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// June 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_06',
    amount: 550.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// July 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_07',
    amount: 550.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// August 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_08',
    amount: 550.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// September 2025
MATCH (cs:CostStructure {id: 'cs_export_personnel'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
CREATE (cd:CostData {
    id: 'cd_assistant_2025_09',
    amount: 550.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'fixed',
    category: 'Personnel - Administrative',
    description: 'Administrative assistant salary'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// ----------------------------------------
// PHASE 2 VALIDATION
// ----------------------------------------
// Verify 52 personnel cost nodes were created successfully
// Expected: PersonnelNodes = 52, TotalAmount = 46800.0

MATCH (cd:CostData)
WHERE cd.category STARTS WITH 'Personnel'
RETURN count(cd) as PersonnelNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 52 AND SUM(cd.amount) = 46800.0
         THEN '✅ Phase 2 Complete: 52 personnel cost nodes, $46,800 total'
         ELSE '❌ ERROR: Expected 52 nodes and $46,800'
       END as Phase2Status;

// ========================================
// END OF PHASE 2
// ========================================

// ----------------------------------------
// PHASE 3: ONE-TIME EVENTS - FIXED COSTS
// ----------------------------------------
// Creates 8 CostData nodes for one-time setup and trade show expenses
// Total amount: $85,780
// Execution time: ~20 seconds
// ----------------------------------------

// SEPTEMBER 2024 SETUP COSTS (4 nodes - $25,000 total)

// GSS Rebranding - $3,500
MATCH (cs:CostStructure {id: 'cs_setup_costs'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_gss_rebranding_2024_09',
    amount: 3500.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Setup & Branding',
    description: 'GSS brand identity refresh - one-time investment'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// Packaging Materials - $10,000
MATCH (cs:CostStructure {id: 'cs_container_packaging'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_packaging_materials_2024_09',
    amount: 10000.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Product Packaging',
    description: 'Initial packaging materials inventory purchase'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// Certifications - $10,000
MATCH (cs:CostStructure {id: 'cs_certifications_compliance'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_certifications_2024_09',
    amount: 10000.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Certifications & Compliance',
    description: 'Export certifications and compliance documentation'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// Commercial Expense - $1,500
MATCH (cs:CostStructure {id: 'cs_market_development'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_commercial_expense_2024_09',
    amount: 1500.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Marketing & Sales',
    description: 'General commercial operations and sales materials'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// SEPTEMBER 2024 TRADE SHOWS (2 nodes - $24,080 total)

// GPF USA Trade Show - $8,280
MATCH (cs:CostStructure {id: 'cs_market_development'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_gpf_usa_2024_09',
    amount: 8280.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Trade Shows',
    description: 'GPF USA trade show participation - booth and travel'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// Fruit Attraction Trade Show - $15,800
MATCH (cs:CostStructure {id: 'cs_market_development'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
CREATE (cd:CostData {
    id: 'cd_fruit_attraction_2024_09',
    amount: 15800.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'fixed',
    category: 'Trade Shows',
    description: 'Fruit Attraction Madrid trade show - exhibition costs'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// NOVEMBER 2024 TRADE SHOW (1 node - $19,300)

// Fruit Logistica Berlin - $19,300
MATCH (cs:CostStructure {id: 'cs_market_development'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
CREATE (cd:CostData {
    id: 'cd_fruit_logistica_berlin_2024_11',
    amount: 19300.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'fixed',
    category: 'Trade Shows',
    description: 'Fruit Logistica Berlin - major European trade event'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// MAY 2025 TRADE SHOW (1 node - $17,400)

// Fruit Logistica Asia - $17,400
MATCH (cs:CostStructure {id: 'cs_market_development'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
CREATE (cd:CostData {
    id: 'cd_fruit_logistica_asia_2025_05',
    amount: 17400.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'fixed',
    category: 'Trade Shows',
    description: 'Fruit Logistica Asia - Asian market expansion event'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp);

// ----------------------------------------
// PHASE 3 VALIDATION
// ----------------------------------------
// Verify 8 one-time event cost nodes were created successfully
// Expected: OneTimeNodes = 8, TotalAmount = 85780.0

MATCH (cd:CostData)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN count(cd) as OneTimeNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 8 AND SUM(cd.amount) = 85780.0
         THEN '✅ Phase 3 Complete: 8 one-time event nodes, $85,780 total'
         ELSE '❌ ERROR: Expected 8 nodes and $85,780'
       END as Phase3Status;

// ========================================
// END OF PHASE 3
// ========================================

// ----------------------------------------
// PHASE 4: VARIABLE PRODUCT PROCUREMENT COSTS
// ----------------------------------------
// Creates 39 CostData nodes for variable procurement across 3 products × 13 months
// Total amount: $1,965,411
// Execution time: ~1 minute
// New relationship type: COST_FOR_PRODUCT (links costs to products)
// ----------------------------------------

// PITAHAYA (DRAGON FRUIT) PROCUREMENT - 13 nodes, $988,069 total

// September 2024 - $12,668
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2024_09',
    amount: 12668.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// October 2024 - $25,335
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2024_10',
    amount: 25335.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// November 2024 - $38,003
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2024_11',
    amount: 38003.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// December 2024 - $38,003
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2024_12',
    amount: 38003.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// January 2025 - $50,670
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_01',
    amount: 50670.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// February 2025 - $63,338
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_02',
    amount: 63338.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// March 2025 - $88,673
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_03',
    amount: 88673.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// April 2025 - $88,673
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_04',
    amount: 88673.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// May 2025 - $88,673
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_05',
    amount: 88673.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// June 2025 - $114,008
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_06',
    amount: 114008.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// July 2025 - $126,675
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_07',
    amount: 126675.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// August 2025 - $126,675
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_08',
    amount: 126675.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// September 2025 - $126,675
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
MATCH (p:Product {id: 'prod_pitahaya'})
CREATE (cd:CostData {
    id: 'cd_pitahaya_procurement_2025_09',
    amount: 126675.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Pitahaya (Dragon Fruit)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// GOLDENBERRIES (PHYSALIS) PROCUREMENT - 13 nodes, $912,092 total

// September 2024 - $0
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2024_09',
    amount: 0.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// October 2024 - $3,634
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2024_10',
    amount: 3634.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// November 2024 - $16,352
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2024_11',
    amount: 16352.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// December 2024 - $16,352
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2024_12',
    amount: 16352.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// January 2025 - $16,352
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_01',
    amount: 16352.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// February 2025 - $43,606
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_02',
    amount: 43606.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// March 2025 - $57,233
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_03',
    amount: 57233.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// April 2025 - $57,233
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_04',
    amount: 57233.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// May 2025 - $90,846
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_05',
    amount: 90846.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// June 2025 - $152,621
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_06',
    amount: 152621.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// July 2025 - $152,621
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_07',
    amount: 152621.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// August 2025 - $152,621
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_08',
    amount: 152621.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// September 2025 - $152,621
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
MATCH (p:Product {id: 'prod_goldenberries'})
CREATE (cd:CostData {
    id: 'cd_goldenberries_procurement_2025_09',
    amount: 152621.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Goldenberries (Physalis)',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// EXOTIC FRUITS MIX PROCUREMENT - 13 nodes, $65,250 total

// September 2024 - $0
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_09'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2024_09',
    amount: 0.0,
    unit: 'USD',
    period: '2024-09',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// October 2024 - $0
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_10'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2024_10',
    amount: 0.0,
    unit: 'USD',
    period: '2024-10',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// November 2024 - $2,250
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_11'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2024_11',
    amount: 2250.0,
    unit: 'USD',
    period: '2024-11',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// December 2024 - $2,250
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2024_12'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2024_12',
    amount: 2250.0,
    unit: 'USD',
    period: '2024-12',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// January 2025 - $2,250
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_01',
    amount: 2250.0,
    unit: 'USD',
    period: '2025-01',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// February 2025 - $4,500
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_02'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_02',
    amount: 4500.0,
    unit: 'USD',
    period: '2025-02',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// March 2025 - $4,500
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_03'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_03',
    amount: 4500.0,
    unit: 'USD',
    period: '2025-03',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// April 2025 - $4,500
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_04'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_04',
    amount: 4500.0,
    unit: 'USD',
    period: '2025-04',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// May 2025 - $4,500
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_05'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_05',
    amount: 4500.0,
    unit: 'USD',
    period: '2025-05',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// June 2025 - $9,000
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_06'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_06',
    amount: 9000.0,
    unit: 'USD',
    period: '2025-06',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// July 2025 - $9,000
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_07'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_07',
    amount: 9000.0,
    unit: 'USD',
    period: '2025-07',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// August 2025 - $9,000
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_08'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_08',
    amount: 9000.0,
    unit: 'USD',
    period: '2025-08',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// September 2025 - $13,500
MATCH (cs:CostStructure {id: 'cs_fruit_procurement'})
MATCH (tp:TimePeriod {id: 'tp_2025_09'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
CREATE (cd:CostData {
    id: 'cd_exotic_fruits_procurement_2025_09',
    amount: 13500.0,
    unit: 'USD',
    period: '2025-09',
    costBehavior: 'variable',
    category: 'Product Procurement',
    productName: 'Exotic Fruits Mix',
    description: 'Direct product procurement cost - scales with volume'
})
CREATE (cd)-[:COST_FOR_STRUCTURE]->(cs)
CREATE (cd)-[:INCURRED_IN_PERIOD]->(tp)
CREATE (cd)-[:COST_FOR_PRODUCT]->(p);

// ----------------------------------------
// PHASE 4 VALIDATION
// ----------------------------------------
// Verify 39 variable cost nodes were created successfully
// Expected: VariableNodes = 39, TotalAmount = 1965411.0

MATCH (cd:CostData {costBehavior: 'variable'})
RETURN count(cd) as VariableNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 39 AND SUM(cd.amount) = 1965411.0
         THEN '✅ Phase 4 Complete: 39 variable cost nodes, $1,965,411 total'
         ELSE '❌ ERROR: Expected 39 nodes and $1,965,411'
       END as Phase4Status;

// ========================================
// END OF PHASE 4
// ========================================
// Cost data integration complete: 99 nodes, $2,097,991 total
// Next: Phase 5-6 will add validation and analysis queries
// ========================================