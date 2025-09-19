# Excel to Neo4j Knowledge Graph Integration Mapping

## Overview
This document outlines the mapping strategy for integrating Excel revenue data from `Cash_Flow_Model_v2.xlsx` into the Goldenberry Flow Neo4j Knowledge Graph.

## Excel File Structure Analysis

### Expected Excel Tabs and Data

#### 1. Variables Tab
**Expected Content:** Product definitions, pricing parameters per kg, quality specifications
**Mapping Target:** Product nodes with kg-based pricing properties

```
Excel Column → Graph Property
-----------------------------
Product Name → Product.name
Category → Product.category
Base Price (per kg) → Product.baseUnitPrice
Quality Grade → Product.quality
Origin Country → Product.origin
Storage Type → Product.storageRequirements
Certifications → Product.certifications
Unit Measure → Product.unitMeasure = 'kg'
Avg Kg per Container → Product.avgKgPerContainer
```

#### 2. Volumes Tab
**Expected Content:** Monthly volumes in kg, seasonal patterns, capacity utilization
**Mapping Target:** VolumeData nodes with kg-based measurements and monthly TimePeriod relationships

```
Excel Column → Graph Property
-----------------------------
Period (YYYY-MM) → TimePeriod.year, TimePeriod.month, TimePeriod.monthName
Product Type → Product.name (relationship link)
Volume (kg) → VolumeData.volume
Max Capacity (kg) → VolumeData.capacity
Unit → VolumeData.unit = 'kg'
Utilization % → VolumeData.utilizationRate
Growth Rate → VolumeData.growthRate
Container Equivalent → VolumeData.containerEquivalent (calculated)
Season → TimePeriod.season (derived from month)
Quarter → TimePeriod.quarter (derived from month)
```

#### 3. Cash Flow Tab
**Expected Content:** Monthly pricing per kg, revenue projections, market conditions
**Mapping Target:** PriceData nodes with kg-based pricing and monthly financial analysis

```
Excel Column → Graph Property
-----------------------------
Period (YYYY-MM) → TimePeriod (relationship link)
Product → Product.name (relationship link)
Price per kg → PriceData.price
Currency → PriceData.currency
Unit Measure → PriceData.unitMeasure = 'kg'
Market Condition → PriceData.marketCondition
Volatility Index → PriceData.volatilityIndex
Price Type → PriceData.priceType
Base Price → PriceData.basePrice (from Variables tab)
Market Adjustment → PriceData.marketAdjustment (calculated)
Revenue Total → Calculated from Volume(kg) × Price(per kg) (monthly)
```

## Data Transformation Rules

### 1. RevenueStream Enhancement (Kg-based Model)
**Existing Properties:** Preserved (id, name, type, pricingMechanism, frequency)
**New Properties:**
- `currency`: Standardized to "USD"
- `unitType`: Set to "kg"
- `pricingMechanism`: Changed to "market-based"
- `frequency`: Changed to "per kg"
- `seasonality`: Derived from seasonal patterns in Volumes tab
- `marketVolatility`: Calculated from price variance in Cash Flow tab

### 2. Product Node Creation (Enhanced with Kg-based Pricing)
**Creation Logic:** One Product node per unique fruit type with kg-based pricing
**Properties Mapping:**
```
Physalis → Product {
  id: "prod_physalis",
  name: "Premium Physalis",
  category: "exotic-fruit",
  quality: "premium",
  origin: "Colombia",
  perishability: "high",
  storageRequirements: "refrigerated",
  baseUnitPrice: 8.50,  // USD per kg from Variables tab
  unitMeasure: "kg",
  avgKgPerContainer: 4117.65  // Calculated conversion factor
}
```

### 3. TimePeriod Node Creation
**Creation Logic:** One TimePeriod node per month in data
**Properties Mapping:**
```
2024-01 → TimePeriod {
  id: "tp_2024_01",
  year: 2024,
  month: 1,
  monthName: "January",
  quarter: "Q1",
  season: "winter",
  periodType: "monthly",
  startDate: "2024-01-01",
  endDate: "2024-01-31"
}
```

### 4. VolumeData Node Creation (Kg-based)
**Creation Logic:** One VolumeData node per Product-Month combination with kg measurements
**Properties Mapping:**
```
Physalis Jan 2024 → VolumeData {
  id: "vd_physalis_2024_01",
  volume: [kg from Excel Volumes tab],
  unit: "kg",
  capacity: [maximum kg capacity],
  utilizationRate: volume/capacity * 100,
  forecastAccuracy: [calculated],
  growthRate: [month-over-month calculation],
  containerEquivalent: volume / avgKgPerContainer  // For reference
}
```

### 5. PriceData Node Creation (Kg-based Pricing)
**Creation Logic:** One PriceData node per Product-Month combination with kg-based pricing
**Properties Mapping:**
```
Physalis Jan 2024 → PriceData {
  id: "pd_physalis_2024_01",
  price: [USD per kg from Excel Cash Flow tab],
  currency: "USD",
  unitMeasure: "kg",
  priceType: "market-based",
  marketCondition: [derived from trends],
  volatilityIndex: [calculated from monthly price variance],
  basePrice: [USD per kg from Variables tab],
  marketAdjustment: price - basePrice,
  priceDrivers: [business context]
}
```

## Relationship Creation Rules

### 1. Product Relationships
```cypher
// Connect RevenueStream to Product
(rs:RevenueStream)-[:SELLS_PRODUCT]->(p:Product)

// Connect Volume/Price data to Product
(vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p:Product)
(pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p:Product)
```

### 2. Temporal Relationships
```cypher
// Connect data to time periods
(vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
(pd:PriceData)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
```

### 3. Data Relationships
```cypher
// Connect RevenueStream to analytical data
(rs:RevenueStream)-[:HAS_VOLUME_DATA]->(vd:VolumeData)
(rs:RevenueStream)-[:HAS_PRICE_DATA]->(pd:PriceData)
```

## Data Validation Rules

### 1. Consistency Checks
- Every VolumeData must have corresponding Product and TimePeriod
- Every PriceData must have corresponding Product and TimePeriod
- Volume and Price data for same Product-TimePeriod must be consistent
- Currency standardization (all prices in USD)

### 2. Business Logic Validation
- Utilization rate must be ≤ 100%
- Growth rates must be realistic (-50% to +200%)
- Prices must be positive values
- Seasonal patterns must align with business knowledge

### 3. Data Completeness
- No null values for key properties (volume, price, period)
- All relationships must have valid start and end nodes
- Time periods must be sequential and non-overlapping

## Sample Integration Workflow

### Phase 1: Data Extraction
1. Read Excel file tabs (Variables, Volumes, Cash Flow)
2. Validate data completeness and format
3. Standardize column names and data types

### Phase 2: Node Creation
1. Create Product nodes from Variables tab
2. Create TimePeriod nodes from date ranges
3. Create VolumeData nodes from Volumes tab
4. Create PriceData nodes from Cash Flow tab
5. Enhance existing RevenueStream nodes

### Phase 3: Relationship Creation
1. Link RevenueStreams to Products
2. Link Volume/Price data to Products and TimePeriods
3. Link RevenueStreams to Volume/Price data
4. Validate all relationship integrity

### Phase 4: Validation
1. Run completeness checks
2. Validate business logic constraints
3. Test query performance
4. Generate validation report

## Expected Outcomes

### 1. Enhanced Knowledge Graph (Kg-based Model)
- 3 enhanced RevenueStream nodes with kg-based pricing properties
- 3 Product nodes with detailed specifications and kg-based pricing (Physalis, Pitahaya, Seasonal Exotic Mix)
- 12 TimePeriod nodes (monthly coverage for 2024: Jan-Dec)
- 36 VolumeData nodes with kg measurements (3 Products × 12 Months)
- 36 PriceData nodes with kg-based pricing (3 Products × 12 Months)

### 2. Analytical Capabilities (Enhanced with Kg-based Calculations)
- Time-series revenue analysis using Volume(kg) × Price(per kg) = Revenue
- Seasonal pattern recognition with kg-based measurements
- Volume vs price correlation analysis per kg
- Market volatility assessment with base price vs market price analysis
- Capacity utilization optimization with kg-based capacity planning
- Container equivalency analysis for logistics planning

### 3. Query Examples (Kg-based Revenue Calculations)
```cypher
// Find highest revenue products by month using kg-based pricing
MATCH (rs:RevenueStream)-[:HAS_VOLUME_DATA]->(vd:VolumeData)
MATCH (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)
MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp)
RETURN tp.year, tp.monthName, rs.name,
       vd.volume as volumeKg, pd.price as pricePerKg,
       ROUND(vd.volume * pd.price, 2) as revenueUSD
ORDER BY revenueUSD DESC

// Analyze monthly volume patterns with seasonal grouping (kg-based)
MATCH (vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
MATCH (vd)-[:VOLUME_FOR_PRODUCT]->(p:Product)
RETURN p.name, tp.season, tp.monthName,
       ROUND(AVG(vd.volume), 2) as avgVolumeKg,
       ROUND(AVG(vd.containerEquivalent), 2) as avgContainerEquivalent
ORDER BY p.name, tp.month

// Monthly growth trend analysis with revenue impact
MATCH (vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
MATCH (vd)-[:VOLUME_FOR_PRODUCT]->(p:Product)
MATCH (p)<-[:SELLS_PRODUCT]-(rs:RevenueStream)-[:HAS_PRICE_DATA]->(pd:PriceData)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp)
RETURN p.name, tp.year, tp.month, tp.monthName, vd.growthRate,
       vd.volume as volumeKg, pd.price as pricePerKg,
       ROUND(vd.volume * pd.price, 2) as monthlyRevenueUSD
ORDER BY p.name, tp.year, tp.month
```

This mapping strategy ensures seamless integration of Excel data while preserving the existing knowledge graph structure and enabling rich analytical capabilities.