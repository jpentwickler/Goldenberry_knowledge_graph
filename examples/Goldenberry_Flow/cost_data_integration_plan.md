# Cost Data Integration Plan - Incremental Database Extension

## Project Overview

**Objective**: Integrate real cost data from `Cash_Flow_Model_v2.xlsx` into the existing Goldenberry Flow Neo4j database

**Approach**: Incremental extension - add time-series cost data to existing database without rebuilding from scratch

**Total Phases**: 6 phases with testable checkpoints after each

**Estimated Total Time**: 8-10 hours

---

## 🚀 EXECUTION PROGRESS SUMMARY

**Project Started**: 2025-09-30
**Current Status**: Phase 4 Complete - Variable Product Procurement
**Overall Progress**: 66.7% (4/6 phases complete)

### Phase Completion Status

| Phase | Status | Nodes Created | Amount Loaded | Duration | Completed |
|-------|--------|---------------|---------------|----------|-----------|
| Phase 1: Schema Extension | ✅ **COMPLETE** | 0 | $0 | 5 min | 2025-09-30 |
| Phase 2: Personnel Costs | ✅ **COMPLETE** | 52/52 | $46,800/$46,800 | 2 min | 2025-09-30 |
| Phase 3: One-Time Events | ✅ **COMPLETE** | 8/8 | $85,780/$85,780 | 2 min | 2025-09-30 |
| Phase 4: Variable Costs | ✅ **COMPLETE** | 39/39 | $1,965,411/$1,965,411 | 3 min | 2025-09-30 |
| Phase 5: Validation | ⏸️ Pending | - | - | - | - |
| Phase 6: Analysis | ⏸️ Pending | - | - | - | - |

### Cumulative Statistics
- **Total CostData Nodes**: 99 / 99 (100%)
- **Total Amount Loaded**: $2,097,991 / $2,097,991 (100%)
- **Schema Objects Created**: 3 (1 constraint, 2 indexes)
- **Total Relationships**: 237 / 237 expected (100%)

---

## Prerequisites

### Required Tools
- Neo4j Database (already populated with business model)
- Neo4j Browser or Cypher client
- Python 3.x with pandas, openpyxl
- Excel file: `Cash_Flow_Model_v2.xlsx`

### Required Existing Database State
- ✅ 33 CostStructure nodes already exist
- ✅ 13 TimePeriod nodes already exist (Sep 2024 - Sep 2025)
- ✅ 3 Product nodes already exist
- ✅ All INCURS_COST relationships already exist

### Verification Query
```cypher
// Run this to verify database is ready
MATCH (cs:CostStructure)
WITH count(cs) as CostStructureCount
MATCH (tp:TimePeriod)
WITH CostStructureCount, count(tp) as TimePeriodCount
MATCH (p:Product)
RETURN CostStructureCount, TimePeriodCount, count(p) as ProductCount;

// Expected: CostStructureCount=33, TimePeriodCount=13, ProductCount=3
```

---

## Excel to Neo4j Cost Data Mapping

### Source File: Cash_Flow_Model_v2.xlsx
**Tab**: Cash Flow
**Section**: EXPENSES (Rows 3-24)

### Mapping Overview

```
Excel Data                          Neo4j Nodes                    Relationships
-----------                         -----------                    -------------
Cost Line Items     →   CostStructure (existing 33 nodes)
                              ↓
Monthly Amounts     →   CostData (NEW ~100 nodes)        →  COST_FOR_STRUCTURE
                              ↓                           →  INCURRED_IN_PERIOD
                              ↓                           →  COST_FOR_PRODUCT (variable only)
Time Periods        →   TimePeriod (existing 13 nodes)
```

---

## NEW Node Type: CostData

### Node Schema
```cypher
(:CostData {
    id: String,              // Unique identifier: "cd_{category}_{product}_{YYYY_MM}"
    amount: Float,           // Cost amount in USD
    unit: String,            // Always "USD"
    period: String,          // YYYY-MM format
    costBehavior: String,    // "fixed" | "variable"
    category: String,        // Cost category for grouping
    productName: String,     // Optional - only for variable product costs
    description: String      // Human-readable description
})
```

### NEW Relationships
```cypher
// Link CostData to CostStructure
(cd:CostData)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)

// Link CostData to TimePeriod
(cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)

// Link CostData to Product (variable costs only)
(cd:CostData)-[:COST_FOR_PRODUCT]->(p:Product)
```

---

## Complete Excel to Neo4j Mapping Table

### FIXED COSTS - Personnel (Monthly Recurring)

| Excel Row | Excel Item | Monthly Amount | Annual Total | Neo4j CostStructure | Cost Behavior | CostData Nodes | Period Coverage |
|-----------|------------|----------------|--------------|---------------------|---------------|----------------|-----------------|
| 8 | Manager (Proportional) | $850 | $11,050 | `cs_export_personnel` | fixed | 13 | Sep 2024 - Sep 2025 |
| 9 | Export Commercial | $1,500 | $19,500 | `cs_export_personnel` | fixed | 13 | Sep 2024 - Sep 2025 |
| 10 | Accounting (Proportional) | $700 | $9,100 | `cs_export_personnel` | fixed | 13 | Sep 2024 - Sep 2025 |
| 11 | Assistant | $550 | $7,150 | `cs_export_personnel` | fixed | 13 | Sep 2024 - Sep 2025 |

**Subtotal**: 4 personnel categories × 13 months = **52 CostData nodes**

---

### FIXED COSTS - One-Time Events

| Excel Row | Excel Item | Amount | Month | Neo4j CostStructure | Cost Behavior | CostData Nodes |
|-----------|------------|--------|-------|---------------------|---------------|----------------|
| 5 | GSS Rebranding | $3,500 | Sep 2024 | `cs_setup_costs` | fixed | 1 |
| 6 | Packaging Materials | $10,000 | Sep 2024 | `cs_container_packaging` | fixed | 1 |
| 7 | Certifications | $10,000 | Sep 2024 | `cs_certifications_compliance` | fixed | 1 |
| 12 | Commercial Expense | $1,500 | Sep 2024 | `cs_market_development` | fixed | 1 |
| 13 | GPF USA (Trade Show) | $8,280 | Sep 2024 | `cs_market_development` | fixed | 1 |
| 14 | Fruit Attraction (Trade Show) | $15,800 | Sep 2024 | `cs_market_development` | fixed | 1 |
| 15 | Fruit Logistica Berlin | $19,300 | Nov 2024 | `cs_market_development` | fixed | 1 |
| 16 | Fruit Logistica Asia | $17,400 | May 2025 | `cs_market_development` | fixed | 1 |

**Subtotal**: 8 one-time events = **8 CostData nodes**

**Total Fixed Costs**: 60 CostData nodes | $132,580 total

---

### VARIABLE COSTS - Product Procurement

| Excel Row | Excel Item | Calculation | Annual Total | Neo4j CostStructure | Product Link | CostData Nodes | Period Coverage |
|-----------|------------|-------------|--------------|---------------------|--------------|----------------|-----------------|
| 20 | Pitahaya (Cost × Volume) | Volume-based | $988,069 | `cs_fruit_procurement` | `prod_pitahaya` | 13 | Sep 2024 - Sep 2025 |
| 21 | Goldenberries (Cost × Volume) | Volume-based | $912,092 | `cs_fruit_procurement` | `prod_goldenberries` | 13 | Sep 2024 - Sep 2025 |
| 22 | Exotic Fruits (Cost × Volume) | Volume-based | $65,250 | `cs_fruit_procurement` | `prod_exotic_fruits` | 13 | Sep 2024 - Sep 2025 |

**Subtotal**: 3 products × 13 months = **39 CostData nodes**

**Total Variable Costs**: 39 CostData nodes | $1,965,411 total

---

### Monthly Cost Data Details

| Period | Manager | Export Comm | Accounting | Assistant | Trade Shows | Pitahaya | Goldenberries | Exotic | Monthly Fixed | Monthly Variable | Total |
|--------|---------|-------------|------------|-----------|-------------|----------|---------------|--------|---------------|------------------|-------|
| 2024-09 | 850 | 1,500 | 700 | 550 | 47,080* | 12,668 | 0 | 0 | 52,680 | 12,668 | 65,348 |
| 2024-10 | 850 | 1,500 | 700 | 550 | 0 | 25,335 | 3,634 | 0 | 3,600 | 28,969 | 32,569 |
| 2024-11 | 850 | 1,500 | 700 | 550 | 19,300 | 38,003 | 16,352 | 2,250 | 22,900 | 56,605 | 79,505 |
| 2024-12 | 850 | 1,500 | 700 | 550 | 0 | 38,003 | 16,352 | 2,250 | 3,600 | 56,605 | 60,205 |
| 2025-01 | 850 | 1,500 | 700 | 550 | 0 | 50,670 | 16,352 | 2,250 | 3,600 | 69,272 | 72,872 |
| 2025-02 | 850 | 1,500 | 700 | 550 | 0 | 63,338 | 43,606 | 4,500 | 3,600 | 111,444 | 115,044 |
| 2025-03 | 850 | 1,500 | 700 | 550 | 0 | 88,673 | 57,233 | 4,500 | 3,600 | 150,406 | 154,006 |
| 2025-04 | 850 | 1,500 | 700 | 550 | 0 | 88,673 | 57,233 | 4,500 | 3,600 | 150,406 | 154,006 |
| 2025-05 | 850 | 1,500 | 700 | 550 | 17,400 | 88,673 | 90,846 | 4,500 | 21,000 | 184,019 | 205,019 |
| 2025-06 | 850 | 1,500 | 700 | 550 | 0 | 114,008 | 152,621 | 9,000 | 3,600 | 275,629 | 279,229 |
| 2025-07 | 850 | 1,500 | 700 | 550 | 0 | 126,675 | 152,621 | 9,000 | 3,600 | 288,296 | 291,896 |
| 2025-08 | 850 | 1,500 | 700 | 550 | 0 | 126,675 | 152,621 | 9,000 | 3,600 | 288,296 | 291,896 |
| 2025-09 | 850 | 1,500 | 700 | 550 | 0 | 126,675 | 152,621 | 13,500 | 3,600 | 292,796 | 296,396 |
| **TOTAL** | **11,050** | **19,500** | **9,100** | **7,150** | **83,780** | **988,069** | **912,092** | **65,250** | **132,580** | **1,965,411** | **2,097,991** |

*September 2024 Trade Shows: GSS ($3,500) + Packaging ($10,000) + Certs ($10,000) + Commercial ($1,500) + GPF ($8,280) + Fruit Attraction ($15,800) = $49,080 setup costs

---

## GRAND TOTAL: 99 CostData Nodes

- Fixed Costs: 60 nodes ($132,580)
- Variable Costs: 39 nodes ($1,965,411)
- **Total: 99 nodes ($2,097,991)**

---

# PHASE 1: Database Schema Extension

## Objective
Add CostData node type and relationships to existing database schema

## Duration
30 minutes

## Executable Script
**File**: `complete_cost_data_integration.cypher` (Phase 1 section)
**Location**: `examples/Goldenberry_Flow/`

## Execution Instructions

### Option 1: Run Complete Script (Recommended)
```bash
# Execute Phase 1 section from the complete integration script
# Open Neo4j Browser and run:
:play file:///path/to/complete_cost_data_integration.cypher
```

### Option 2: Run Individual Commands
Execute the following Cypher statements in Neo4j Browser:

### Task 1.1: Create CostData Node Constraint
```cypher
// Create unique constraint for CostData nodes
CREATE CONSTRAINT cost_data_id IF NOT EXISTS
FOR (cd:CostData) REQUIRE cd.id IS UNIQUE;
```

**Expected Result**: Constraint created successfully

### Task 1.2: Create Performance Index
```cypher
// Create index for period-based queries
CREATE INDEX cost_data_period IF NOT EXISTS
FOR (cd:CostData) ON (cd.period);
```

**Expected Result**: Index created successfully

### Task 1.3: Verify Schema Updates
```cypher
// List constraints
SHOW CONSTRAINTS WHERE name CONTAINS 'cost_data';

// List indexes
SHOW INDEXES WHERE name CONTAINS 'cost_data';
```

**Expected Result**:
- Should see `cost_data_id` constraint (UNIQUENESS)
- Should see `cost_data_period` index (RANGE)
- Should see `cost_data_id` index (RANGE - auto-created with constraint)

---

## PHASE 1 TEST CHECKPOINT

### Centralized Validation Queries
**File**: `validation_queries.cypher`
**Location**: `examples/Goldenberry_Flow/`
**Queries**: 27-28 (Cost Data Validation section)

Run these validation queries to verify Phase 1 completion:

### Test 1.1: Verify Schema Objects (Query 27)
```cypher
// Query 27: Verify CostData schema objects
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
```
**Expected**: Phase1Status shows "✅ Phase 1 Complete"

### Test 1.2: Verify CostData Node Count (Query 28)
```cypher
// Query 28: Verify progressive data loading
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
```
**Expected**: CurrentPhase shows "Phase 1: Schema only ✅" (0 nodes)

### Test 1.3: Test Constraint Enforcement (Optional)
```cypher
// This should succeed (create test node)
CREATE (cd:CostData {id: 'test_001', amount: 100.0});

// This should FAIL (duplicate id)
CREATE (cd:CostData {id: 'test_001', amount: 200.0});

// Cleanup test node
MATCH (cd:CostData {id: 'test_001'}) DELETE cd;
```
**Expected**: First CREATE succeeds, second CREATE fails with constraint violation

---

# PHASE 2: Fixed Costs - Personnel (Monthly Recurring)

## Objective
Create 52 CostData nodes for 4 personnel categories across 13 months

## Duration
1 hour

## Tasks

### Task 2.1: Create Manager Cost Data (13 months)
```cypher
// Manager (Proportional) - $850/month
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

// Repeat for October 2024
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

// Continue for all 13 months (2024-09 through 2025-09)...
// [Similar blocks for tp_2024_11, tp_2024_12, tp_2025_01, ... tp_2025_09]
```

**Note**: Complete Cypher for all months provided in Phase 2 execution section

### Task 2.2: Create Export Commercial Cost Data (13 months)
```cypher
// Export Commercial - $1,500/month
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

// Repeat for all 13 months...
```

### Task 2.3: Create Accounting Cost Data (13 months)
```cypher
// Accounting (Proportional) - $700/month
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

// Repeat for all 13 months...
```

### Task 2.4: Create Assistant Cost Data (13 months)
```cypher
// Assistant - $550/month
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

// Repeat for all 13 months...
```

---

## PHASE 2 TEST CHECKPOINT

### Test 2.1: Verify CostData Node Count
```cypher
MATCH (cd:CostData)
WHERE cd.category STARTS WITH 'Personnel'
RETURN count(cd) as PersonnelCostDataNodes;
```
**Expected**: 52 nodes

### Test 2.2: Verify Monthly Personnel Costs
```cypher
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category STARTS WITH 'Personnel'
WITH tp, SUM(cd.amount) as MonthlyPersonnelCost
RETURN tp.year as Year, tp.month as Month,
       MonthlyPersonnelCost
ORDER BY Year, Month;
```
**Expected**: Each month should show $3,600 (850 + 1,500 + 700 + 550)

### Test 2.3: Verify Relationships
```cypher
MATCH (cd:CostData)-[r:COST_FOR_STRUCTURE]->(cs:CostStructure {id: 'cs_export_personnel'})
WHERE cd.category STARTS WITH 'Personnel'
RETURN count(r) as PersonnelRelationships;
```
**Expected**: 52 relationships

### Test 2.4: Verify Time Period Coverage
```cypher
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category STARTS WITH 'Personnel'
WITH tp, count(cd) as PersonnelCostsPerMonth
RETURN tp.id, PersonnelCostsPerMonth
ORDER BY tp.year, tp.month;
```
**Expected**: Each of 13 months should have 4 cost nodes

### Test 2.5: Calculate Total Personnel Costs
```cypher
MATCH (cd:CostData)
WHERE cd.category STARTS WITH 'Personnel'
RETURN SUM(cd.amount) as TotalPersonnelCosts;
```
**Expected**: $46,800 (3,600 × 13 months)

---

# PHASE 3: Fixed Costs - One-Time Events

## Objective
Create 8 CostData nodes for one-time setup and marketing events

## Duration
45 minutes

## Tasks

### Task 3.1: Setup Costs (September 2024)
```cypher
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
```

### Task 3.2: Trade Show Expenses
```cypher
// GPF USA Trade Show - $8,280 (September 2024)
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

// Fruit Attraction Trade Show - $15,800 (September 2024)
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

// Fruit Logistica Berlin - $19,300 (November 2024)
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

// Fruit Logistica Asia - $17,400 (May 2025)
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
```

---

## PHASE 3 TEST CHECKPOINT

### Test 3.1: Verify One-Time Cost Node Count
```cypher
MATCH (cd:CostData)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN count(cd) as OneTimeCostNodes;
```
**Expected**: 8 nodes

### Test 3.2: Verify Total One-Time Costs
```cypher
MATCH (cd:CostData)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN SUM(cd.amount) as TotalOneTimeCosts;
```
**Expected**: $85,780

### Test 3.3: Verify September 2024 Setup Spike
```cypher
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod {id: 'tp_2024_09'})
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN SUM(cd.amount) as September2024OneTimeCosts;
```
**Expected**: $49,080

### Test 3.4: Verify Trade Show Schedule
```cypher
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WHERE cd.category = 'Trade Shows'
RETURN tp.year + '-' + tp.month as Period,
       cd.description as TradeShow,
       cd.amount as Cost
ORDER BY tp.year, tp.month;
```
**Expected**: 4 trade shows across Sep 2024, Nov 2024, and May 2025

### Test 3.5: Cumulative Fixed Costs So Far
```cypher
MATCH (cd:CostData {costBehavior: 'fixed'})
RETURN count(cd) as TotalFixedCostNodes,
       SUM(cd.amount) as TotalFixedCostsUSD;
```
**Expected**: 60 nodes, $132,580

---

# PHASE 4: Variable Costs - Product Procurement

## Objective
Create 39 CostData nodes for 3 products across 13 months with COST_FOR_PRODUCT relationships

## Duration
1.5 hours

## Tasks

### Task 4.1: Pitahaya Procurement Costs (13 months)
```cypher
// Pitahaya - September 2024: $12,668
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

// Pitahaya - October 2024: $25,335
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

// Pitahaya - November 2024: $38,003
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

// Continue for all 13 months with amounts:
// Dec 2024: 38003, Jan 2025: 50670, Feb 2025: 63338, Mar 2025: 88673
// Apr 2025: 88673, May 2025: 88673, Jun 2025: 114008, Jul 2025: 126675
// Aug 2025: 126675, Sep 2025: 126675
```

### Task 4.2: Goldenberries Procurement Costs (13 months)
```cypher
// Goldenberries - September 2024: $0
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

// Goldenberries - October 2024: $3,634
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

// Continue for all 13 months with amounts:
// Nov 2024: 16352, Dec 2024: 16352, Jan 2025: 16352, Feb 2025: 43606
// Mar 2025: 57233, Apr 2025: 57233, May 2025: 90846, Jun 2025: 152621
// Jul 2025: 152621, Aug 2025: 152621, Sep 2025: 152621
```

### Task 4.3: Exotic Fruits Procurement Costs (13 months)
```cypher
// Exotic Fruits - September 2024: $0
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

// Exotic Fruits - October 2024: $0
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

// Continue for all 13 months with amounts:
// Nov 2024-May 2025: 2250 each, Jun 2025-Aug 2025: 9000 each, Sep 2025: 13500
```

---

## PHASE 4 TEST CHECKPOINT

### Test 4.1: Verify Variable Cost Node Count
```cypher
MATCH (cd:CostData {costBehavior: 'variable'})
RETURN count(cd) as VariableCostNodes;
```
**Expected**: 39 nodes

### Test 4.2: Verify Total Variable Costs by Product
```cypher
MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(p:Product)
WITH p.name as Product, SUM(cd.amount) as TotalCost
RETURN Product, TotalCost
ORDER BY TotalCost DESC;
```
**Expected**:
- Pitahaya: $988,069
- Goldenberries: $912,092
- Exotic Fruits: $65,250

### Test 4.3: Verify COST_FOR_PRODUCT Relationships
```cypher
MATCH (cd:CostData)-[r:COST_FOR_PRODUCT]->(p:Product)
RETURN p.name as Product, count(r) as CostDataRelationships;
```
**Expected**: Each product has 13 relationships

### Test 4.4: Verify Monthly Variable Cost Trend
```cypher
MATCH (cd:CostData {costBehavior: 'variable'})-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WITH tp, SUM(cd.amount) as MonthlyVariableCost
RETURN tp.year + '-' + tp.month as Period,
       MonthlyVariableCost
ORDER BY tp.year, tp.month;
```
**Expected**: Increasing trend from $12,668 (Sep 2024) to $292,796 (Sep 2025)

### Test 4.5: Verify Total Variable Costs
```cypher
MATCH (cd:CostData {costBehavior: 'variable'})
RETURN SUM(cd.amount) as TotalVariableCosts;
```
**Expected**: $1,965,411

---

# PHASE 5: Data Validation & Reconciliation

## Objective
Comprehensive validation of all integrated cost data against Excel source

## Duration
1 hour

## Tasks

### Task 5.1: Validate Total Node Counts
```cypher
// Count all CostData nodes by type
MATCH (cd:CostData)
RETURN cd.costBehavior as CostType,
       count(cd) as NodeCount,
       SUM(cd.amount) as TotalAmount
ORDER BY CostType;
```
**Expected**:
- fixed: 60 nodes, $132,580
- variable: 39 nodes, $1,965,411

### Task 5.2: Validate Relationship Counts
```cypher
// Count all cost-related relationships
MATCH (cd:CostData)-[r1:COST_FOR_STRUCTURE]->()
WITH count(r1) as CostForStructureCount
MATCH (cd:CostData)-[r2:INCURRED_IN_PERIOD]->()
WITH CostForStructureCount, count(r2) as IncurredInPeriodCount
MATCH (cd:CostData)-[r3:COST_FOR_PRODUCT]->()
RETURN CostForStructureCount,
       IncurredInPeriodCount,
       count(r3) as CostForProductCount;
```
**Expected**:
- COST_FOR_STRUCTURE: 99
- INCURRED_IN_PERIOD: 99
- COST_FOR_PRODUCT: 39

### Task 5.3: Reconcile Total Expenses with Excel
```cypher
// Calculate total expenses across all cost data
MATCH (cd:CostData)
RETURN SUM(cd.amount) as TotalExpenses;
```
**Expected**: $2,097,991 (matches Excel row 24)

### Task 5.4: Validate Monthly Expense Totals
```cypher
// Compare monthly totals with Excel
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WITH tp, SUM(cd.amount) as MonthlyTotal
RETURN tp.year + '-' + tp.month as Period,
       MonthlyTotal
ORDER BY tp.year, tp.month;
```
**Expected** (from Excel):
| Period | Expected Total |
|--------|----------------|
| 2024-09 | $65,348 |
| 2024-10 | $32,569 |
| 2024-11 | $79,505 |
| 2024-12 | $60,205 |
| 2025-01 | $72,872 |
| 2025-02 | $115,044 |
| 2025-03 | $154,006 |
| 2025-04 | $154,006 |
| 2025-05 | $205,019 |
| 2025-06 | $279,229 |
| 2025-07 | $291,896 |
| 2025-08 | $291,896 |
| 2025-09 | $296,396 |

### Task 5.5: Validate Cost Structure Attribution
```cypher
// Verify all costs are properly attributed
MATCH (cs:CostStructure)
OPTIONAL MATCH (cs)<-[:COST_FOR_STRUCTURE]-(cd:CostData)
WITH cs, count(cd) as CostDataCount, SUM(cd.amount) as TotalAmount
WHERE CostDataCount > 0
RETURN cs.name as CostStructure,
       CostDataCount,
       TotalAmount
ORDER BY TotalAmount DESC;
```
**Expected**: 5 CostStructure nodes with data:
- cs_fruit_procurement
- cs_market_development
- cs_export_personnel
- cs_container_packaging
- cs_certifications_compliance
- cs_setup_costs

### Task 5.6: Verify No Orphaned Nodes
```cypher
// Find CostData nodes without required relationships
MATCH (cd:CostData)
WHERE NOT (cd)-[:COST_FOR_STRUCTURE]->()
   OR NOT (cd)-[:INCURRED_IN_PERIOD]->()
RETURN count(cd) as OrphanedCostDataNodes;
```
**Expected**: 0 (no orphaned nodes)

---

## PHASE 5 TEST CHECKPOINT

### Test 5.1: Excel Reconciliation Report
```cypher
// Comprehensive reconciliation with Excel totals
MATCH (cd:CostData)
WITH cd.costBehavior as CostType,
     SUM(cd.amount) as Total,
     count(cd) as NodeCount
RETURN CostType, NodeCount, Total
UNION
MATCH (cd:CostData)
RETURN 'TOTAL' as CostType,
       count(cd) as NodeCount,
       SUM(cd.amount) as Total;
```
**Expected**:
```
CostType   | NodeCount | Total
-----------|-----------|------------
fixed      | 60        | $132,580
variable   | 39        | $1,965,411
TOTAL      | 99        | $2,097,991
```

### Test 5.2: Monthly Variance Check
```cypher
// Check for any months with zero costs (data gap indicator)
MATCH (tp:TimePeriod)
OPTIONAL MATCH (tp)<-[:INCURRED_IN_PERIOD]-(cd:CostData)
WITH tp, SUM(cd.amount) as MonthlyTotal
WHERE MonthlyTotal IS NULL OR MonthlyTotal = 0
RETURN count(*) as MonthsWithZeroCosts;
```
**Expected**: 0 (all 13 months have cost data)

### Test 5.3: Product Cost Coverage
```cypher
// Verify all 3 products have cost data
MATCH (p:Product)
OPTIONAL MATCH (p)<-[:COST_FOR_PRODUCT]-(cd:CostData)
RETURN p.name as Product,
       count(cd) as CostDataNodes,
       SUM(cd.amount) as TotalCost;
```
**Expected**: All 3 products with 13 cost nodes each

---

# PHASE 6: Integration Analysis & Documentation

## Objective
Create analytical queries demonstrating cost-revenue integration and document findings

## Duration
1 hour

## Tasks

### Task 6.1: Cost-to-Revenue Ratio Analysis
```cypher
// Monthly profitability analysis
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WITH tp, SUM(cd.amount) as TotalCosts
MATCH (vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp)
MATCH (pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
WITH tp, TotalCosts, SUM(vd.volume * pd.price) as TotalRevenue
RETURN tp.year + '-' + tp.month as Period,
       ROUND(TotalRevenue, 2) as Revenue,
       ROUND(TotalCosts, 2) as Costs,
       ROUND(TotalRevenue - TotalCosts, 2) as Profit,
       ROUND((TotalCosts / TotalRevenue) * 100, 2) as CostRatio,
       CASE WHEN TotalRevenue > TotalCosts THEN 'Profitable' ELSE 'Loss' END as Status
ORDER BY tp.year, tp.month;
```

### Task 6.2: Product-Level Profitability
```cypher
// Gross profit by product
MATCH (p:Product)
MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(p)
WITH p, SUM(cd.amount) as ProductCosts
MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
WITH p, ProductCosts, SUM(vd.volume * pd.price) as ProductRevenue
RETURN p.name as Product,
       ROUND(ProductRevenue, 2) as Revenue,
       ROUND(ProductCosts, 2) as DirectCosts,
       ROUND(ProductRevenue - ProductCosts, 2) as GrossProfit,
       ROUND(((ProductRevenue - ProductCosts) / ProductRevenue) * 100, 2) as GrossProfitMargin
ORDER BY GrossProfit DESC;
```

### Task 6.3: Cost Structure Breakdown
```cypher
// Cost distribution by category
MATCH (cd:CostData)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
WITH cs.category as Category,
     SUM(cd.amount) as CategoryTotal,
     cd.costBehavior as CostBehavior
RETURN Category,
       CostBehavior,
       ROUND(CategoryTotal, 2) as Total,
       ROUND((CategoryTotal / 2097991.0) * 100, 2) as PercentOfTotal
ORDER BY CategoryTotal DESC;
```

### Task 6.4: Break-Even Analysis
```cypher
// Calculate cumulative profit over time
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
WITH tp, SUM(cd.amount) as Costs
MATCH (vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp)
MATCH (pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
WITH tp, Costs, SUM(vd.volume * pd.price) as Revenue
WITH tp.year + '-' + tp.month as Period,
     Revenue - Costs as MonthlyProfit,
     tp.year as Year, tp.month as Month
ORDER BY Year, Month
WITH collect({period: Period, profit: MonthlyProfit}) as MonthlyData
UNWIND range(0, size(MonthlyData)-1) as idx
WITH MonthlyData, idx,
     reduce(cumulative = 0.0, i IN range(0, idx) |
        cumulative + MonthlyData[i].profit) as CumulativeProfit
RETURN MonthlyData[idx].period as Period,
       ROUND(MonthlyData[idx].profit, 2) as MonthlyProfit,
       ROUND(CumulativeProfit, 2) as CumulativeProfit,
       CASE WHEN CumulativeProfit >= 0 THEN 'Break-Even Achieved' ELSE 'Pre-Break-Even' END as Status;
```

### Task 6.5: Cost Driver Impact Analysis
```cypher
// Identify which activities/resources drive most costs
MATCH (source)-[:INCURS_COST]->(cs:CostStructure)<-[:COST_FOR_STRUCTURE]-(cd:CostData)
WITH labels(source)[0] as SourceType,
     source.name as SourceName,
     SUM(cd.amount) as TotalCostDriven
RETURN SourceType, SourceName,
       ROUND(TotalCostDriven, 2) as TotalCost
ORDER BY TotalCostDriven DESC
LIMIT 10;
```

---

## PHASE 6 TEST CHECKPOINT

### Test 6.1: Verify Profitability Calculations
Run the Cost-to-Revenue Ratio query and verify:
- September 2024 shows a loss (high fixed costs)
- Break-even occurs around December 2024
- Cumulative profit is positive by end of fiscal year

### Test 6.2: Verify Product Margins
Run the Product-Level Profitability query and verify:
- All three products show positive gross margins
- Margins align with business model expectations

### Test 6.3: Document Key Findings
Expected insights:
- Total annual profit: ~$171,192
- Break-even month: December 2024
- Most profitable product: Pitahaya or Goldenberries
- Cost-to-revenue ratio improves over time (economies of scale)

---

# PROJECT COMPLETION CHECKLIST

## Database State Verification
- [ ] 99 CostData nodes created
- [ ] 237 cost-related relationships created (99+99+39)
- [ ] Total expenses reconcile to $2,097,991
- [ ] All 13 TimePeriods have cost data
- [ ] All 3 Products have variable cost data
- [ ] 5 CostStructure nodes have cost data attribution

## Data Quality Verification
- [ ] No orphaned CostData nodes
- [ ] No duplicate cost entries
- [ ] All amounts match Excel source
- [ ] All relationships are correctly typed
- [ ] Monthly totals reconcile with Excel

## Functional Verification
- [ ] Cost-revenue integration queries work
- [ ] Product profitability analysis works
- [ ] Monthly trend analysis works
- [ ] Cost attribution analysis works
- [ ] Break-even analysis works

## Documentation Complete
- [ ] All mapping tables documented
- [ ] All test checkpoints passed
- [ ] Key findings documented
- [ ] Known issues documented (if any)

---

# APPENDIX A: Complete Cypher Generation Script

For automated generation of all 99 CostData node creation statements, use this Python script:

```python
import pandas as pd

# Read Excel file
df = pd.read_excel('Cash_Flow_Model_v2.xlsx', sheet_name='Cash Flow', header=None)

# Extract cost data from rows 8-22 (personnel and one-time costs)
# and rows 20-22 (variable product costs)

# Generate Cypher statements for each cost item
# [Script would iterate through Excel data and generate CREATE statements]
```

---

# APPENDIX B: Known Limitations & Future Enhancements

## Current Limitations
1. **No Cost Forecasting**: Only historical/planned cost data loaded
2. **No Cost Allocation**: Overhead costs not allocated to products
3. **No Working Capital**: Working capital requirements not modeled
4. **No Cash Flow Timing**: Payment terms and cash flow timing not captured

## Future Enhancement Opportunities
1. Add CostForecast nodes for predictive analytics
2. Implement overhead allocation algorithms
3. Model working capital as separate node type
4. Add payment term properties to cost relationships
5. Create cost variance tracking (planned vs actual)
6. Implement cost center hierarchy for organizational reporting

---

# SUPPORT & TROUBLESHOOTING

## Common Issues

### Issue 1: Constraint Violations
**Symptom**: Error creating CostData nodes with duplicate IDs
**Solution**: Verify ID uniqueness, check for typos in id generation

### Issue 2: Node Not Found
**Symptom**: Cannot find CostStructure or TimePeriod nodes
**Solution**: Verify prerequisite database state, check node IDs

### Issue 3: Relationship Creation Fails
**Symptom**: CREATE relationship statement fails
**Solution**: Use MATCH before CREATE, verify all nodes exist

### Issue 4: Amount Discrepancies
**Symptom**: Totals don't match Excel
**Solution**: Check for decimal precision issues, verify all months loaded

---

# 📋 EXECUTION LOG - DETAILED PHASE REPORTS

## Phase 1: Database Schema Extension ✅ COMPLETE

**Executed**: 2025-09-30
**Duration**: 5 minutes
**Status**: SUCCESS
**Nodes Created**: 0 (schema only)
**Schema Objects Added**: 3

### Execution Steps Completed

#### Step 1: Verify Database Prerequisites ✅
**Query Executed**:
```cypher
MATCH (cs:CostStructure)
WITH count(cs) as CostStructureCount
MATCH (tp:TimePeriod)
WITH CostStructureCount, count(tp) as TimePeriodCount
MATCH (p:Product)
RETURN CostStructureCount, TimePeriodCount, count(p) as ProductCount;
```

**Result**:
```
CostStructureCount: 33
TimePeriodCount: 13
ProductCount: 3
```
✅ All prerequisites met

---

#### Step 2: Create CostData Node Constraint ✅
**Query Executed**:
```cypher
CREATE CONSTRAINT cost_data_id IF NOT EXISTS
FOR (cd:CostData) REQUIRE cd.id IS UNIQUE;
```

**Result**: Constraint created successfully
- Constraints added: 1
- Constraint name: `cost_data_id`
- Constraint type: UNIQUENESS

---

#### Step 3: Create CostData Performance Index ✅
**Query Executed**:
```cypher
CREATE INDEX cost_data_period IF NOT EXISTS
FOR (cd:CostData) ON (cd.period);
```

**Result**: Index created successfully
- Indexes added: 1
- Index name: `cost_data_period`
- Index type: RANGE

---

#### Step 4: Verify Schema Changes ✅
**Queries Executed**:
```cypher
// Verify constraint
SHOW CONSTRAINTS WHERE name CONTAINS 'cost_data';

// Verify indexes
SHOW INDEXES WHERE name CONTAINS 'cost_data';
```

**Results**:
- **Constraints**: `cost_data_id` (UNIQUENESS) ✅
- **Indexes**:
  - `cost_data_id` (RANGE - auto-created with constraint) ✅
  - `cost_data_period` (RANGE) ✅

---

#### Step 5: Test Constraint Enforcement ✅
**Test 1 - Create Test Node**:
```cypher
CREATE (cd:CostData {id: 'test_001', amount: 100.0});
```
✅ Result: Node created successfully (1 node, 2 properties)

**Test 2 - Attempt Duplicate**:
```cypher
CREATE (cd:CostData {id: 'test_001', amount: 200.0});
```
✅ Result: Constraint violation error (as expected)
```
Neo.ClientError.Schema.ConstraintValidationFailed
Node already exists with label `CostData` and property `id` = 'test_001'
```

**Test 3 - Cleanup**:
```cypher
MATCH (cd:CostData {id: 'test_001'}) DELETE cd;
```
✅ Result: Test node deleted (1 node deleted)

---

### Phase 1 Summary

**Schema Objects Created**:
1. ✅ Constraint: `cost_data_id` (ensures unique CostData IDs)
2. ✅ Index: `cost_data_period` (optimizes period-based queries)
3. ✅ Index: `cost_data_id` (auto-created with constraint)

**Database State After Phase 1**:
- CostData nodes: 0
- Schema ready for data loading: YES
- All tests passed: YES
- Issues encountered: NONE

**Validation Passed**: All 5 test checkpoints successful

---

### Next Phase Preview

**Phase 2**: Fixed Costs - Personnel (Monthly Recurring)
- Target: 52 CostData nodes
- Amount: $46,800
- Duration estimate: 1 hour
- Categories: Manager, Export Commercial, Accounting, Assistant

**Ready to proceed when approved** ✅

---

## Phase 2: Fixed Costs - Personnel (Monthly Recurring) ✅ COMPLETE

**Executed**: 2025-09-30
**Duration**: 2 minutes
**Status**: SUCCESS
**Nodes Created**: 52
**Amount Loaded**: $46,800

### Execution Steps Completed

#### Step 1: Execute Manager Costs (13 nodes) ✅
**Query Executed via Neo4j MCP**:
- Created 13 CostData nodes for Manager role
- Amount: $850/month × 13 months = $11,050
- Created 26 relationships (13 COST_FOR_STRUCTURE + 13 INCURRED_IN_PERIOD)

**Result**:
```
labels_added: 13
nodes_created: 13
relationships_created: 26
properties_set: 91
```
✅ Manager costs successfully created

---

#### Step 2: Execute Export Commercial Costs (13 nodes) ✅
**Query Executed via Neo4j MCP**:
- Created 13 CostData nodes for Export Commercial role
- Amount: $1,500/month × 13 months = $19,500
- Created 26 relationships (13 COST_FOR_STRUCTURE + 13 INCURRED_IN_PERIOD)

**Result**:
```
labels_added: 13
nodes_created: 13
relationships_created: 26
properties_set: 91
```
✅ Export Commercial costs successfully created

---

#### Step 3: Execute Accounting Costs (13 nodes) ✅
**Query Executed via Neo4j MCP**:
- Created 13 CostData nodes for Accounting role
- Amount: $700/month × 13 months = $9,100
- Created 26 relationships (13 COST_FOR_STRUCTURE + 13 INCURRED_IN_PERIOD)

**Result**:
```
labels_added: 13
nodes_created: 13
relationships_created: 26
properties_set: 91
```
✅ Accounting costs successfully created

---

#### Step 4: Execute Assistant Costs (13 nodes) ✅
**Query Executed via Neo4j MCP**:
- Created 13 CostData nodes for Assistant role
- Amount: $550/month × 13 months = $7,150
- Created 26 relationships (13 COST_FOR_STRUCTURE + 13 INCURRED_IN_PERIOD)

**Result**:
```
labels_added: 13
nodes_created: 13
relationships_created: 26
properties_set: 91
```
✅ Assistant costs successfully created

---

#### Step 5: Run Phase 2 Inline Validation ✅
**Query Executed**:
```cypher
MATCH (cd:CostData)
WHERE cd.category STARTS WITH 'Personnel'
RETURN count(cd) as PersonnelNodes,
       SUM(cd.amount) as TotalAmount,
       CASE
         WHEN count(cd) = 52 AND SUM(cd.amount) = 46800.0
         THEN '✅ Phase 2 Complete: 52 personnel cost nodes, $46,800 total'
         ELSE '❌ ERROR: Expected 52 nodes and $46,800'
       END as Phase2Status;
```

**Result**:
```
PersonnelNodes: 52
TotalAmount: 46800.0
Phase2Status: "✅ Phase 2 Complete: 52 personnel cost nodes, $46,800 total"
```
✅ Phase 2 validation successful

---

#### Step 6: Run Query 29 (Detailed Validation) ✅
**Query 29 Part A - By Category**:
```
✅ Personnel - Management: 13 nodes, $11,050
✅ Personnel - Commercial: 13 nodes, $19,500
✅ Personnel - Accounting: 13 nodes, $9,100
✅ Personnel - Administrative: 13 nodes, $7,150
```

**Query 29 Part D - Total Validation**:
```
TotalNodes: 52
TotalAmount: $46,800
ValidationStatus: "✅ Phase 2 Complete"
```
✅ Query 29 validation successful

---

#### Step 7: Run Query 28 (Phase Progression) ✅
**Query Executed**:
```cypher
MATCH (cd:CostData)
WITH count(cd) as ActualNodes
RETURN ActualNodes as CostDataNodes,
       CASE
         WHEN count(cd) = 52 THEN "Phase 2: Personnel costs ✅"
       END as CurrentPhase;
```

**Result**:
```
CostDataNodes: 52
CurrentPhase: "Phase 2: Personnel costs ✅"
```
✅ Phase progression confirmed

---

### Phase 2 Summary

**Total Execution Statistics**:
- **Nodes Created**: 52 CostData nodes (4 categories × 13 months)
- **Relationships Created**: 104 total
  - COST_FOR_STRUCTURE: 52 (all to cs_export_personnel)
  - INCURRED_IN_PERIOD: 52 (4 per TimePeriod × 13 periods)
- **Total Amount**: $46,800
- **Database Operations**: 4 batched write queries + 3 validation read queries
- **Execution Time**: ~2 minutes
- **Success Rate**: 100% (all validation checks passed)

**Database State After Phase 2**:
- CostData nodes: 52 (was 0, now 52)
- Total relationships: 104 (was 0, now 104)
- Personnel cost coverage: 100% (all 4 categories × 13 months)
- All tests passed: YES
- Issues encountered: NONE

**Validation Passed**: All test checkpoints successful
- ✅ Phase 2 inline validation
- ✅ Query 29 detailed validation (4 parts)
- ✅ Query 28 phase progression

---

### Next Phase Preview

**Phase 3**: Fixed Costs - One-Time Events
- Target: 8 CostData nodes
- Amount: $85,780
- Duration estimate: 15-20 minutes
- Categories: Setup costs, trade show expenses

**Ready to proceed when approved** ✅

---

## Phase 3: Fixed Costs - One-Time Events ✅ COMPLETE

**Executed**: 2025-09-30
**Duration**: 2 minutes
**Status**: SUCCESS
**Nodes Created**: 8
**Amount Loaded**: $85,780

### Execution Steps Completed

#### Step 1: Pre-Execution Validation ✅
**Validation Checks**:
- Current CostData nodes: 52 (Phase 2 complete) ✅
- Required CostStructure nodes: 4 exist ✅
- Required TimePeriod nodes: 3 exist ✅

#### Step 2: Execute Setup Costs - September 2024 (4 nodes) ✅
**Result**: 4 nodes created, 8 relationships
- GSS Rebranding: $3,500 → cs_setup_costs
- Packaging Materials: $10,000 → cs_container_packaging
- Certifications: $10,000 → cs_certifications_compliance
- Commercial Expense: $1,500 → cs_market_development

#### Step 3: Execute Trade Shows - September 2024 (2 nodes) ✅
**Result**: 2 nodes created, 4 relationships
- GPF USA: $8,280 → cs_market_development
- Fruit Attraction Madrid: $15,800 → cs_market_development

#### Step 4: Execute Trade Show - November 2024 (1 node) ✅
**Result**: 1 node created, 2 relationships
- Fruit Logistica Berlin: $19,300 → cs_market_development

#### Step 5: Execute Trade Show - May 2025 (1 node) ✅
**Result**: 1 node created, 2 relationships
- Fruit Logistica Asia: $17,400 → cs_market_development

#### Step 6: Inline Validation ✅
**Query**:
```cypher
MATCH (cd:CostData)
WHERE cd.category IN ['Setup & Branding', 'Product Packaging',
                      'Certifications & Compliance', 'Marketing & Sales',
                      'Trade Shows']
RETURN count(cd) as OneTimeNodes, SUM(cd.amount) as TotalAmount;
```
**Result**: 8 nodes, $85,780 ✅

#### Step 7: Query 30 Comprehensive Validation ✅
**Part A - By Category**: All 5 categories validated ✅
- Setup & Branding: 1 node, $3,500
- Product Packaging: 1 node, $10,000
- Certifications & Compliance: 1 node, $10,000
- Marketing & Sales: 1 node, $1,500
- Trade Shows: 4 nodes, $60,780

**Part B - By Period**: All 3 periods validated ✅
- tp_2024_09: 6 nodes, $49,080 (setup spike)
- tp_2024_11: 1 node, $19,300
- tp_2025_05: 1 node, $17,400

**Part C - Relationships**: All relationships validated ✅
- COST_FOR_STRUCTURE: 8 relationships
- INCURRED_IN_PERIOD: 8 relationships

**Part D - Totals**: Phase 3 complete ✅
- Total nodes: 8
- Total amount: $85,780

#### Step 8: Query 28 Phase Progression Check ✅
**Result**: "Phase 3: + One-time events ✅" with 60 CostData nodes

### Phase 3 Summary

**Total Execution Statistics**:
- Nodes Created: 8 CostData nodes (5 categories across 3 time periods)
- Relationships Created: 16 total (8 COST_FOR_STRUCTURE + 8 INCURRED_IN_PERIOD)
- Total Amount: $85,780
- Success Rate: 100%
- Zero errors encountered

**Database State After Phase 3**:
- CostData nodes: 60 (was 52, +8)
- Total relationships: 120 (was 104, +16)
- Total amount loaded: $132,580 (was $46,800, +$85,780)
- Progress: 60/99 nodes (60.6% complete)

**Key Insights**:
- September 2024 shows significant setup cost spike ($49,080)
- Trade shows concentrated in Q4 2024 and Q2 2025
- All one-time events properly linked to market development cost structures
- Fixed cost behavior correctly attributed to all nodes

**Next Phase Preview**:
- Phase 4: Variable Product Procurement Costs
- Expected: 39 nodes (3 products × 13 months)
- Amount: $1,965,411
- New relationship type: COST_FOR_PRODUCT

## Phase 4: Variable Costs - Product Procurement ✅ COMPLETE

**Executed**: 2025-09-30
**Duration**: 3 minutes
**Status**: SUCCESS
**Nodes Created**: 39
**Amount Loaded**: $1,965,411

### Execution Steps Completed

#### Step 1: Pre-Execution Validation ✅
**Validation Checks**:
- Current CostData nodes: 60 (Phase 3 complete) ✅
- cs_fruit_procurement exists: YES ✅
- 3 Product nodes exist: YES ✅
- 13 TimePeriod nodes exist: YES ✅

#### Step 2: Execute Pitahaya Procurement Costs (13 nodes) ✅
**Batch 1 - Pitahaya (Dragon Fruit)**:
- Executed 13 individual CREATE statements
- Amount range: $12,668 (Sep 2024) to $126,675 (Jul-Sep 2025)
- Total product cost: $988,069
- Relationships per node: 3 (COST_FOR_STRUCTURE, INCURRED_IN_PERIOD, COST_FOR_PRODUCT)
- Total relationships created: 39 (13 nodes × 3 relationships)

**Result**: All 13 Pitahaya nodes created successfully ✅

#### Step 3: Execute Goldenberries Procurement Costs (13 nodes) ✅
**Batch 2 - Goldenberries (Physalis)**:
- Executed 13 individual CREATE statements
- Amount range: $0 (Sep 2024) to $152,621 (Jun-Sep 2025)
- Total product cost: $912,092
- Relationships per node: 3 (COST_FOR_STRUCTURE, INCURRED_IN_PERIOD, COST_FOR_PRODUCT)
- Total relationships created: 39 (13 nodes × 3 relationships)

**Result**: All 13 Goldenberries nodes created successfully ✅

#### Step 4: Execute Exotic Fruits Procurement Costs (13 nodes) ✅
**Batch 3 - Exotic Fruits Mix**:
- Executed 13 individual CREATE statements
- Amount range: $0 (Sep-Oct 2024) to $13,500 (Sep 2025)
- Total product cost: $65,250
- Relationships per node: 3 (COST_FOR_STRUCTURE, INCURRED_IN_PERIOD, COST_FOR_PRODUCT)
- Total relationships created: 39 (13 nodes × 3 relationships)

**Result**: All 13 Exotic Fruits nodes created successfully ✅

#### Step 5: Inline Validation ✅
**Query**:
```cypher
MATCH (cd:CostData {costBehavior: 'variable'})
RETURN count(cd) as VariableNodes, SUM(cd.amount) as TotalAmount;
```
**Result**: 39 nodes, $1,965,411 ✅

#### Step 6: Query 31 Comprehensive Validation ✅
**Part A - Variable Costs by Product**: All 3 products validated ✅
- Pitahaya (Dragon Fruit): 13 nodes, $988,069 ✅
- Goldenberries (Physalis): 13 nodes, $912,092 ✅
- Exotic Fruits Mix: 13 nodes, $65,250 ✅

**Part D - Total Relationship Count**: 117 relationships validated ✅
- COST_FOR_STRUCTURE: 39 relationships ✅
- INCURRED_IN_PERIOD: 39 relationships ✅
- COST_FOR_PRODUCT: 39 relationships ✅

**Part E - Total Validation**: Phase 4 complete ✅
- Total variable nodes: 39
- Total amount: $1,965,411

#### Step 7: Query 28 Phase Progression Check ✅
**Result**: "Phase 4: Complete ✅" with 99 CostData nodes, $2,097,991 total, 100% complete

### Phase 4 Summary

**Total Execution Statistics**:
- Nodes Created: 39 CostData nodes (3 products × 13 months)
- Relationships Created: 117 total (39×3 relationships per node)
  - COST_FOR_STRUCTURE: 39 (all to cs_fruit_procurement)
  - INCURRED_IN_PERIOD: 39 (3 per TimePeriod × 13 periods)
  - COST_FOR_PRODUCT: 39 (NEW relationship type - product attribution)
- Total Amount: $1,965,411
- Database Operations: 39 individual write queries + 4 validation queries
- Execution Time: ~3 minutes
- Success Rate: 100% (all validation checks passed)

**Database State After Phase 4**:
- CostData nodes: 99 (was 60, +39)
- Total relationships: 237 (was 120, +117)
- Total amount loaded: $2,097,991 (was $132,580, +$1,965,411)
- Progress: 99/99 nodes (100% COMPLETE)

**Key Technical Notes**:
- Each variable cost node has 3 relationships vs 2 for fixed costs
- New COST_FOR_PRODUCT relationship type enables product-level profitability analysis
- Variable costs show increasing trend: $12,668 (Sep 2024) → $292,796 (Sep 2025)
- Pitahaya accounts for 50.3% of variable costs ($988K of $1.97M)

**Product-Level Breakdown**:
| Product | Nodes | Total Cost | % of Variable |
|---------|-------|------------|---------------|
| Pitahaya (Dragon Fruit) | 13 | $988,069 | 50.3% |
| Goldenberries (Physalis) | 13 | $912,092 | 46.4% |
| Exotic Fruits Mix | 13 | $65,250 | 3.3% |

**Next Phase Preview**:
- Phase 5: Data Validation & Reconciliation
- Comprehensive validation against Excel source
- Monthly variance checks
- Cost-revenue integration testing

---

**End of Integration Plan**

**Document Version**: 1.4
**Last Updated**: 2025-09-30
**Status**: Phase 4 Complete - Data Loading 100% Complete (99/99 nodes, $2.1M loaded)