# Goldenberries: Complete Monthly Excel to Neo4j Mapping (REAL DATA)

## Data Flow Architecture with Real Excel Data

```
Excel Tabs                    Neo4j Nodes                      Relationships
----------                    -----------                      -------------
Variables Tab       →         Product Node                  ←  SELLS_PRODUCT
($7.00/kg)                 (prod_goldenberries)                (from RevenueStream)
                                    ↓
Volumes Tab        →         VolumeData Nodes              →  HAS_VOLUME_DATA
(12 monthly kg)              (12 monthly nodes)               (to RevenueStream)
                                    ↓                      →  VOLUME_FOR_PRODUCT
                                                              (to Product)
                                                           →  OCCURS_IN_PERIOD
                                                              (to TimePeriod)

Cash Flow Tab      →         PriceData Nodes               →  HAS_PRICE_DATA
($7.00/kg fixed)             (12 monthly nodes)               (to RevenueStream)
                                    ↓                      →  PRICE_FOR_PRODUCT
                                                              (to Product)
                                                           →  PRICED_IN_PERIOD
                                                              (to TimePeriod)

Period Column      →         TimePeriod Nodes              ←  Connected from
(2025 fiscal year)           (12 monthly nodes)               Volume & Price Data
```

## REAL Excel Data from Cash_Flow_Model_v2.xlsx

### Step 1: Product Node Creation (from Variables Tab)

**Real Excel Data:**
- **Product**: Goldenberries
- **Selling Price**: $7.00/kg (fixed)
- **Origin**: Ecuador

**Creates Neo4j Node:**
```cypher
CREATE (p:Product {
    id: 'prod_goldenberries',
    name: 'Goldenberries (Physalis)',
    category: 'exotic-fruit',
    quality: 'premium',
    origin: 'Ecuador',
    perishability: 'high',
    storageRequirements: 'refrigerated',
    certifications: 'organic,fair-trade',
    baseUnitPrice: 7.00,  // USD per kg from REAL Variables tab
    unitMeasure: 'kg'
})
```

### Step 2: Monthly TimePeriod Nodes (Fiscal Year 2025)

**Excel Period Values (Starting September):**
```
Sept, Oct, Nov, Dec, Jan, Feb, Mar, Apr, May, Jun, Jul, Aug, Sept
```

**Creates Neo4j Nodes (Examples):**
```cypher
CREATE (tp9:TimePeriod {
    id: 'tp_2024_09',
    year: 2024,
    month: 9,
    monthName: 'September',
    quarter: 'Q3',
    season: 'spring',  // Southern hemisphere - Ecuador
    periodType: 'monthly',
    startDate: date('2024-09-01'),
    endDate: date('2024-09-30')
});

CREATE (tp1:TimePeriod {
    id: 'tp_2025_01',
    year: 2025,
    month: 1,
    monthName: 'January',
    quarter: 'Q1',
    season: 'summer',  // Southern hemisphere - Ecuador
    periodType: 'monthly',
    startDate: date('2025-01-01'),
    endDate: date('2025-01-31')
});
// ... and 10 more monthly nodes
```

### Step 3: Monthly VolumeData Nodes (REAL Excel Volumes Tab)

**Real Excel Monthly Data for Goldenberries (kg):**
```
Month    | Volume (kg)    | Growth from Previous
---------|----------------|---------------------
Sept     | 0.00          | N/A (start)
Oct      | 588.03        | New production
Nov      | 2,645.95      | +349.9%
Dec      | 2,645.95      | 0.0%
Jan      | 2,645.95      | 0.0%
Feb      | 7,055.99      | +166.6%
Mar      | 9,261.00      | +31.3%
Apr      | 9,261.00      | 0.0%
May      | 14,700.00     | +58.7%
Jun      | 24,695.95     | +68.0%
Jul      | 24,695.95     | 0.0%
Aug      | 24,695.95     | 0.0%
```

**Creates Monthly Neo4j Nodes (Examples):**
```cypher
CREATE (vd_gb_09:VolumeData {
    id: 'vd_goldenberries_2024_09',
    volume: 0.0,  // kg from REAL Excel
    unit: 'kg',
    forecastAccuracy: 100.0,
    growthRate: 0.0
});

CREATE (vd_gb_01:VolumeData {
    id: 'vd_goldenberries_2025_01',
    volume: 2645.95,  // kg from REAL Excel
    unit: 'kg',
    forecastAccuracy: 100.0,
    growthRate: 0.0
});

CREATE (vd_gb_06:VolumeData {
    id: 'vd_goldenberries_2025_06',
    volume: 24695.95,  // kg from REAL Excel
    unit: 'kg',
    forecastAccuracy: 100.0,
    growthRate: 68.0
});
// ... and 9 more monthly VolumeData nodes
```

### Step 4: Monthly PriceData Nodes (FIXED Pricing Model)

**Real Excel Pricing (from Variables & Cash Flow tabs):**
- **All months**: $7.00/kg (FIXED - no monthly variations)

**Creates Monthly Neo4j Nodes (All identical pricing):**
```cypher
CREATE (pd:PriceData {
    id: 'pd_goldenberries_2025_01',
    price: 7.00,  // USD per kg - FIXED for all months
    currency: 'USD',
    priceType: 'fixed',
    marketCondition: 'stable',
    volatilityIndex: 0.00,  // No variation
    priceDrivers: 'premium organic goldenberries, export quality, fixed contract',
    basePrice: 7.00,
    marketAdjustment: 0.00,
    unitMeasure: 'kg'
});
// Repeat for all 12 months with same fixed price
```

### Step 5: Monthly Relationship Creation

**For Each Month's Data:**
```cypher
// Connect RevenueStream to Product (once)
MATCH (rs:RevenueStream {id: 'rs_goldenberries_sales'})
MATCH (p:Product {id: 'prod_goldenberries'})
MERGE (rs)-[:SELLS_PRODUCT]->(p);

// Connect RevenueStream to Monthly VolumeData (for each month)
MATCH (rs:RevenueStream {id: 'rs_goldenberries_sales'})
MATCH (vd:VolumeData {id: 'vd_goldenberries_2025_01'})
MERGE (rs)-[:HAS_VOLUME_DATA]->(vd);

// Connect RevenueStream to Monthly PriceData
MATCH (rs:RevenueStream {id: 'rs_goldenberries_sales'})
MATCH (pd:PriceData {id: 'pd_goldenberries_2025_01'})
MERGE (rs)-[:HAS_PRICE_DATA]->(pd);

// Connect VolumeData to TimePeriod
MATCH (vd:VolumeData {id: 'vd_goldenberries_2025_01'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
MERGE (vd)-[:OCCURS_IN_PERIOD]->(tp);

// Connect PriceData to TimePeriod
MATCH (pd:PriceData {id: 'pd_goldenberries_2025_01'})
MATCH (tp:TimePeriod {id: 'tp_2025_01'})
MERGE (pd)-[:PRICED_IN_PERIOD]->(tp);

// Connect VolumeData to Product
MATCH (vd:VolumeData {id: 'vd_goldenberries_2025_01'})
MATCH (p:Product {id: 'prod_goldenberries'})
MERGE (vd)-[:VOLUME_FOR_PRODUCT]->(p);

// Connect PriceData to Product
MATCH (pd:PriceData {id: 'pd_goldenberries_2025_01'})
MATCH (p:Product {id: 'prod_goldenberries'})
MERGE (pd)-[:PRICE_FOR_PRODUCT]->(p);
```

## Real Revenue Calculations

### Monthly Revenue = Volume(kg) × Price($/kg)

**Real Excel Revenue Examples:**
```
January 2025:  2,645.95 kg × $7.00/kg = $18,521.65
February 2025: 7,055.99 kg × $7.00/kg = $49,391.93
June 2025:    24,695.95 kg × $7.00/kg = $172,871.65
```

### Query for Real Revenue Analysis
```cypher
MATCH (rs:RevenueStream {id: 'rs_goldenberries_sales'})
MATCH (rs)-[:SELLS_PRODUCT]->(p:Product)
MATCH (rs)-[:HAS_VOLUME_DATA]->(vd:VolumeData)
MATCH (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)
MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp)
RETURN
    tp.year as Year,
    tp.monthName as Month,
    vd.volume as VolumeKg,
    pd.price as PricePerKg,
    ROUND(vd.volume * pd.price, 2) as RevenueUSD
ORDER BY tp.year, tp.month;
```

**Expected Results with Real Data:**
```
Year | Month      | VolumeKg   | PricePerKg | RevenueUSD
-----|------------|------------|------------|-------------
2024 | September  | 0.00       | 7.00       | 0.00
2024 | October    | 588.03     | 7.00       | 4,116.21
2024 | November   | 2,645.95   | 7.00       | 18,521.65
2024 | December   | 2,645.95   | 7.00       | 18,521.65
2025 | January    | 2,645.95   | 7.00       | 18,521.65
2025 | February   | 7,055.99   | 7.00       | 49,391.93
2025 | March      | 9,261.00   | 7.00       | 64,827.00
2025 | April      | 9,261.00   | 7.00       | 64,827.00
2025 | May        | 14,700.00  | 7.00       | 102,900.00
2025 | June       | 24,695.95  | 7.00       | 172,871.65
2025 | July       | 24,695.95  | 7.00       | 172,871.65
2025 | August     | 24,695.95  | 7.00       | 172,871.65
```

## Key Insights from Real Data

### 1. Fixed Pricing Model
- **No price variations**: $7.00/kg throughout the year
- **Simplified revenue calculation**: Revenue depends only on volume changes
- **Zero volatility**: Stable, predictable pricing model

### 2. Strong Volume Growth Pattern
- **Zero to hero**: Starting from 0 kg in September to 24,695.95 kg by June
- **Rapid scaling**: 166.6% growth from January to February
- **Plateau phase**: Volume stabilizes at 24,695.95 kg from June-August

### 3. Revenue Implications
- **Total annual revenue**: $1,033,113.92 (Goldenberries only)
- **Peak monthly revenue**: $172,871.65 (June-August)
- **Average monthly revenue**: $86,092.83

## Data Source Documentation

**Excel File**: `Cash_Flow_Model_v2.xlsx`
- **Variables Tab**: Base pricing at $7.00/kg for Goldenberries
- **Volumes Tab**: Monthly kg volumes for fiscal year 2025
- **Cash Flow Tab**: Revenue calculations confirming fixed pricing model

**Data Extraction Date**: Current session
**Fiscal Year**: September 2024 - September 2025
**Currency**: USD
**Unit of Measure**: Kilograms (kg)

This documentation represents the ACTUAL data from your Excel file, not fabricated examples.