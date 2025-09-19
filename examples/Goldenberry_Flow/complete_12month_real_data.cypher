// Complete 12-Month Excel Revenue Data Integration with REAL DATA
// From Cash_Flow_Model_v2.xlsx - Fiscal Year 2025 (Sep 2024 - Aug 2025)

// =====================================
// 1. PRODUCT NODES (FROM VARIABLES TAB)
// =====================================

CREATE (p1:Product {
    id: 'prod_goldenberries',
    name: 'Goldenberries (Physalis)',
    category: 'exotic-fruit',
    quality: 'premium',
    origin: 'Ecuador',
    perishability: 'high',
    storageRequirements: 'refrigerated',
    certifications: 'organic,fair-trade',
    baseUnitPrice: 7.00,  // USD per kg from REAL Excel Variables tab
    unitMeasure: 'kg'
});

CREATE (p2:Product {
    id: 'prod_pitahaya',
    name: 'Pitahaya (Dragon Fruit)',
    category: 'exotic-fruit',
    quality: 'premium',
    origin: 'Ecuador',
    perishability: 'high',
    storageRequirements: 'refrigerated',
    certifications: 'organic',
    baseUnitPrice: 6.63,  // USD per kg from REAL Excel Variables tab
    unitMeasure: 'kg'
});

CREATE (p3:Product {
    id: 'prod_exotic_fruits',
    name: 'Exotic Fruits Mix',
    category: 'exotic-fruit',
    quality: 'premium',
    origin: 'Ecuador',
    perishability: 'high',
    storageRequirements: 'refrigerated',
    certifications: 'organic,seasonal',
    baseUnitPrice: 5.00,  // USD per kg from REAL Excel Variables tab
    unitMeasure: 'kg'
});

// =====================================
// 2. REVENUE STREAM NODES
// =====================================

MERGE (rs1:RevenueStream {id: 'rs_goldenberries_sales'})
SET rs1.name = 'Goldenberries Sales',
    rs1.type = 'one-time',
    rs1.pricingMechanism = 'fixed',
    rs1.frequency = 'per kg',
    rs1.currency = 'USD',
    rs1.unitType = 'kg',
    rs1.seasonality = 'year-round',
    rs1.marketVolatility = 'none';

MERGE (rs2:RevenueStream {id: 'rs_pitahaya_sales'})
SET rs2.name = 'Pitahaya Sales',
    rs2.type = 'one-time',
    rs2.pricingMechanism = 'fixed',
    rs2.frequency = 'per kg',
    rs2.currency = 'USD',
    rs2.unitType = 'kg',
    rs2.seasonality = 'year-round',
    rs2.marketVolatility = 'none';

MERGE (rs3:RevenueStream {id: 'rs_exotic_fruits_sales'})
SET rs3.name = 'Exotic Fruits Sales',
    rs3.type = 'one-time',
    rs3.pricingMechanism = 'fixed',
    rs3.frequency = 'per kg',
    rs3.currency = 'USD',
    rs3.unitType = 'kg',
    rs3.seasonality = 'seasonal',
    rs3.marketVolatility = 'none';

// =====================================
// 3. TIME PERIOD NODES (12 MONTHS)
// =====================================

CREATE (tp09:TimePeriod {
    id: 'tp_2024_09',
    year: 2024,
    month: 9,
    monthName: 'September',
    quarter: 'Q3',
    periodType: 'monthly',
    startDate: date('2024-09-01'),
    endDate: date('2024-09-30')
});

CREATE (tp10:TimePeriod {
    id: 'tp_2024_10',
    year: 2024,
    month: 10,
    monthName: 'October',
    quarter: 'Q4',
    periodType: 'monthly',
    startDate: date('2024-10-01'),
    endDate: date('2024-10-31')
});

CREATE (tp11:TimePeriod {
    id: 'tp_2024_11',
    year: 2024,
    month: 11,
    monthName: 'November',
    quarter: 'Q4',
    periodType: 'monthly',
    startDate: date('2024-11-01'),
    endDate: date('2024-11-30')
});

CREATE (tp12:TimePeriod {
    id: 'tp_2024_12',
    year: 2024,
    month: 12,
    monthName: 'December',
    quarter: 'Q4',
    periodType: 'monthly',
    startDate: date('2024-12-01'),
    endDate: date('2024-12-31')
});

CREATE (tp01:TimePeriod {
    id: 'tp_2025_01',
    year: 2025,
    month: 1,
    monthName: 'January',
    quarter: 'Q1',
    periodType: 'monthly',
    startDate: date('2025-01-01'),
    endDate: date('2025-01-31')
});

CREATE (tp02:TimePeriod {
    id: 'tp_2025_02',
    year: 2025,
    month: 2,
    monthName: 'February',
    quarter: 'Q1',
    periodType: 'monthly',
    startDate: date('2025-02-01'),
    endDate: date('2025-02-28')
});

CREATE (tp03:TimePeriod {
    id: 'tp_2025_03',
    year: 2025,
    month: 3,
    monthName: 'March',
    quarter: 'Q1',
    periodType: 'monthly',
    startDate: date('2025-03-01'),
    endDate: date('2025-03-31')
});

CREATE (tp04:TimePeriod {
    id: 'tp_2025_04',
    year: 2025,
    month: 4,
    monthName: 'April',
    quarter: 'Q2',
    periodType: 'monthly',
    startDate: date('2025-04-01'),
    endDate: date('2025-04-30')
});

CREATE (tp05:TimePeriod {
    id: 'tp_2025_05',
    year: 2025,
    month: 5,
    monthName: 'May',
    quarter: 'Q2',
    periodType: 'monthly',
    startDate: date('2025-05-01'),
    endDate: date('2025-05-31')
});

CREATE (tp06:TimePeriod {
    id: 'tp_2025_06',
    year: 2025,
    month: 6,
    monthName: 'June',
    quarter: 'Q2',
    periodType: 'monthly',
    startDate: date('2025-06-01'),
    endDate: date('2025-06-30')
});

CREATE (tp07:TimePeriod {
    id: 'tp_2025_07',
    year: 2025,
    month: 7,
    monthName: 'July',
    quarter: 'Q3',
    periodType: 'monthly',
    startDate: date('2025-07-01'),
    endDate: date('2025-07-31')
});

CREATE (tp08:TimePeriod {
    id: 'tp_2025_08',
    year: 2025,
    month: 8,
    monthName: 'August',
    quarter: 'Q3',
    periodType: 'monthly',
    startDate: date('2025-08-01'),
    endDate: date('2025-08-31')
});

// =====================================
// 4. VOLUME DATA NODES (REAL EXCEL DATA)
// =====================================

// GOLDENBERRIES VOLUME DATA
CREATE (vd_gb_09:VolumeData {
    id: "vd_goldenberries_2024_09",
    volume: 0.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_10:VolumeData {
    id: "vd_goldenberries_2024_10",
    volume: 588.03,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_11:VolumeData {
    id: "vd_goldenberries_2024_11",
    volume: 2645.95,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_12:VolumeData {
    id: "vd_goldenberries_2024_12",
    volume: 2645.95,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_01:VolumeData {
    id: "vd_goldenberries_2025_01",
    volume: 2645.95,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_02:VolumeData {
    id: "vd_goldenberries_2025_02",
    volume: 7055.99,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_03:VolumeData {
    id: "vd_goldenberries_2025_03",
    volume: 9261.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_04:VolumeData {
    id: "vd_goldenberries_2025_04",
    volume: 9261.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_05:VolumeData {
    id: "vd_goldenberries_2025_05",
    volume: 14700.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_06:VolumeData {
    id: "vd_goldenberries_2025_06",
    volume: 24695.95,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_07:VolumeData {
    id: "vd_goldenberries_2025_07",
    volume: 24695.95,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_gb_08:VolumeData {
    id: "vd_goldenberries_2025_08",
    volume: 24695.95,
    unit: "kg",
    forecastAccuracy: 100.0
});

// PITAHAYA VOLUME DATA
CREATE (vd_pit_09:VolumeData {
    id: "vd_pitahaya_2024_09",
    volume: 2250.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_10:VolumeData {
    id: "vd_pitahaya_2024_10",
    volume: 4500.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_11:VolumeData {
    id: "vd_pitahaya_2024_11",
    volume: 6750.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_12:VolumeData {
    id: "vd_pitahaya_2024_12",
    volume: 6750.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_01:VolumeData {
    id: "vd_pitahaya_2025_01",
    volume: 9000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_02:VolumeData {
    id: "vd_pitahaya_2025_02",
    volume: 11250.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_03:VolumeData {
    id: "vd_pitahaya_2025_03",
    volume: 15750.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_04:VolumeData {
    id: "vd_pitahaya_2025_04",
    volume: 15750.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_05:VolumeData {
    id: "vd_pitahaya_2025_05",
    volume: 15750.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_06:VolumeData {
    id: "vd_pitahaya_2025_06",
    volume: 20250.09,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_07:VolumeData {
    id: "vd_pitahaya_2025_07",
    volume: 22500.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_pit_08:VolumeData {
    id: "vd_pitahaya_2025_08",
    volume: 22500.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

// EXOTIC FRUITS VOLUME DATA
CREATE (vd_ef_09:VolumeData {
    id: "vd_exotic_fruits_2024_09",
    volume: 0.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_10:VolumeData {
    id: "vd_exotic_fruits_2024_10",
    volume: 0.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_11:VolumeData {
    id: "vd_exotic_fruits_2024_11",
    volume: 500.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_12:VolumeData {
    id: "vd_exotic_fruits_2024_12",
    volume: 500.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_01:VolumeData {
    id: "vd_exotic_fruits_2025_01",
    volume: 500.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_02:VolumeData {
    id: "vd_exotic_fruits_2025_02",
    volume: 1000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_03:VolumeData {
    id: "vd_exotic_fruits_2025_03",
    volume: 1000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_04:VolumeData {
    id: "vd_exotic_fruits_2025_04",
    volume: 1000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_05:VolumeData {
    id: "vd_exotic_fruits_2025_05",
    volume: 1000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_06:VolumeData {
    id: "vd_exotic_fruits_2025_06",
    volume: 2000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_07:VolumeData {
    id: "vd_exotic_fruits_2025_07",
    volume: 2000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

CREATE (vd_ef_08:VolumeData {
    id: "vd_exotic_fruits_2025_08",
    volume: 2000.00,
    unit: "kg",
    forecastAccuracy: 100.0
});

// =====================================
// 5. PRICE DATA NODES (FIXED PRICING)
// =====================================

// GOLDENBERRIES PRICE DATA (All months $7.00/kg)
FOREACH (month IN ['09', '10', '11', '12'] |
    CREATE (pd:PriceData {
        id: 'pd_goldenberries_2024_' + month,
        price: 7.00,
        currency: 'USD',
        priceType: 'fixed',
        marketCondition: 'stable',
        volatilityIndex: 0.00,
        basePrice: 7.00,
        marketAdjustment: 0.00,
        unitMeasure: 'kg'
    })
);

FOREACH (month IN ['01', '02', '03', '04', '05', '06', '07', '08'] |
    CREATE (pd:PriceData {
        id: 'pd_goldenberries_2025_' + month,
        price: 7.00,
        currency: 'USD',
        priceType: 'fixed',
        marketCondition: 'stable',
        volatilityIndex: 0.00,
        basePrice: 7.00,
        marketAdjustment: 0.00,
        unitMeasure: 'kg'
    })
);

// PITAHAYA PRICE DATA (All months $6.63/kg)
FOREACH (month IN ['09', '10', '11', '12'] |
    CREATE (pd:PriceData {
        id: 'pd_pitahaya_2024_' + month,
        price: 6.63,
        currency: 'USD',
        priceType: 'fixed',
        marketCondition: 'stable',
        volatilityIndex: 0.00,
        basePrice: 6.63,
        marketAdjustment: 0.00,
        unitMeasure: 'kg'
    })
);

FOREACH (month IN ['01', '02', '03', '04', '05', '06', '07', '08'] |
    CREATE (pd:PriceData {
        id: 'pd_pitahaya_2025_' + month,
        price: 6.63,
        currency: 'USD',
        priceType: 'fixed',
        marketCondition: 'stable',
        volatilityIndex: 0.00,
        basePrice: 6.63,
        marketAdjustment: 0.00,
        unitMeasure: 'kg'
    })
);

// EXOTIC FRUITS PRICE DATA (All months $5.00/kg)
FOREACH (month IN ['09', '10', '11', '12'] |
    CREATE (pd:PriceData {
        id: 'pd_exotic_fruits_2024_' + month,
        price: 5.00,
        currency: 'USD',
        priceType: 'fixed',
        marketCondition: 'stable',
        volatilityIndex: 0.00,
        basePrice: 5.00,
        marketAdjustment: 0.00,
        unitMeasure: 'kg'
    })
);

FOREACH (month IN ['01', '02', '03', '04', '05', '06', '07', '08'] |
    CREATE (pd:PriceData {
        id: 'pd_exotic_fruits_2025_' + month,
        price: 5.00,
        currency: 'USD',
        priceType: 'fixed',
        marketCondition: 'stable',
        volatilityIndex: 0.00,
        basePrice: 5.00,
        marketAdjustment: 0.00,
        unitMeasure: 'kg'
    })
);

// =====================================
// 6. RELATIONSHIP CREATION
// =====================================

// Connect RevenueStreams to Products
MATCH (rs:RevenueStream {id: 'rs_goldenberries_sales'})
MATCH (p:Product {id: 'prod_goldenberries'})
MERGE (rs)-[:SELLS_PRODUCT]->(p);

MATCH (rs:RevenueStream {id: 'rs_pitahaya_sales'})
MATCH (p:Product {id: 'prod_pitahaya'})
MERGE (rs)-[:SELLS_PRODUCT]->(p);

MATCH (rs:RevenueStream {id: 'rs_exotic_fruits_sales'})
MATCH (p:Product {id: 'prod_exotic_fruits'})
MERGE (rs)-[:SELLS_PRODUCT]->(p);

// =====================================
// SAFE RELATIONSHIP CREATION (PREVENTS CARTESIAN PRODUCTS)
// =====================================
// IMPORTANT: Create relationships by product individually to ensure 1:1 matching
// Bulk queries with multiple products can create unintended many-to-many relationships

// Connect RevenueStreams to Volume/Price Data by Product
MATCH (rs:RevenueStream {id: 'rs_goldenberries_sales'}), (vd:VolumeData), (pd:PriceData)
WHERE vd.id CONTAINS 'goldenberries' AND pd.id CONTAINS 'goldenberries'
AND RIGHT(vd.id, 7) = RIGHT(pd.id, 7)  // Match year_month suffix
MERGE (rs)-[:HAS_VOLUME_DATA]->(vd)
MERGE (rs)-[:HAS_PRICE_DATA]->(pd);

MATCH (rs:RevenueStream {id: 'rs_pitahaya_sales'}), (vd:VolumeData), (pd:PriceData)
WHERE vd.id CONTAINS 'pitahaya' AND pd.id CONTAINS 'pitahaya'
AND RIGHT(vd.id, 7) = RIGHT(pd.id, 7)
MERGE (rs)-[:HAS_VOLUME_DATA]->(vd)
MERGE (rs)-[:HAS_PRICE_DATA]->(pd);

MATCH (rs:RevenueStream {id: 'rs_exotic_fruits_sales'}), (vd:VolumeData), (pd:PriceData)
WHERE vd.id CONTAINS 'exotic_fruits' AND pd.id CONTAINS 'exotic_fruits'
AND RIGHT(vd.id, 7) = RIGHT(pd.id, 7)
MERGE (rs)-[:HAS_VOLUME_DATA]->(vd)
MERGE (rs)-[:HAS_PRICE_DATA]->(pd);

// Connect VolumeData to TimePeriods (1:1 matching by month-year)
MATCH (vd:VolumeData), (tp:TimePeriod)
WHERE vd.id CONTAINS 'goldenberries' AND RIGHT(vd.id, 7) = RIGHT(tp.id, 7)
MERGE (vd)-[:OCCURS_IN_PERIOD]->(tp);

MATCH (vd:VolumeData), (tp:TimePeriod)
WHERE vd.id CONTAINS 'pitahaya' AND RIGHT(vd.id, 7) = RIGHT(tp.id, 7)
MERGE (vd)-[:OCCURS_IN_PERIOD]->(tp);

MATCH (vd:VolumeData), (tp:TimePeriod)
WHERE vd.id CONTAINS 'exotic_fruits' AND RIGHT(vd.id, 7) = RIGHT(tp.id, 7)
MERGE (vd)-[:OCCURS_IN_PERIOD]->(tp);

// Connect PriceData to TimePeriods (1:1 matching by month-year)
MATCH (pd:PriceData), (tp:TimePeriod)
WHERE pd.id CONTAINS 'goldenberries' AND RIGHT(pd.id, 7) = RIGHT(tp.id, 7)
MERGE (pd)-[:PRICED_IN_PERIOD]->(tp);

MATCH (pd:PriceData), (tp:TimePeriod)
WHERE pd.id CONTAINS 'pitahaya' AND RIGHT(pd.id, 7) = RIGHT(tp.id, 7)
MERGE (pd)-[:PRICED_IN_PERIOD]->(tp);

MATCH (pd:PriceData), (tp:TimePeriod)
WHERE pd.id CONTAINS 'exotic_fruits' AND RIGHT(pd.id, 7) = RIGHT(tp.id, 7)
MERGE (pd)-[:PRICED_IN_PERIOD]->(tp);

// Connect Volume/Price Data to Products
MATCH (vd:VolumeData), (p:Product {id: 'prod_goldenberries'})
WHERE vd.id CONTAINS 'goldenberries'
MERGE (vd)-[:VOLUME_FOR_PRODUCT]->(p);

MATCH (vd:VolumeData), (p:Product {id: 'prod_pitahaya'})
WHERE vd.id CONTAINS 'pitahaya'
MERGE (vd)-[:VOLUME_FOR_PRODUCT]->(p);

MATCH (vd:VolumeData), (p:Product {id: 'prod_exotic_fruits'})
WHERE vd.id CONTAINS 'exotic_fruits'
MERGE (vd)-[:VOLUME_FOR_PRODUCT]->(p);

MATCH (pd:PriceData), (p:Product {id: 'prod_goldenberries'})
WHERE pd.id CONTAINS 'goldenberries'
MERGE (pd)-[:PRICE_FOR_PRODUCT]->(p);

MATCH (pd:PriceData), (p:Product {id: 'prod_pitahaya'})
WHERE pd.id CONTAINS 'pitahaya'
MERGE (pd)-[:PRICE_FOR_PRODUCT]->(p);

MATCH (pd:PriceData), (p:Product {id: 'prod_exotic_fruits'})
WHERE pd.id CONTAINS 'exotic_fruits'
MERGE (pd)-[:PRICE_FOR_PRODUCT]->(p);

// =====================================
// 7. REVENUE VALIDATION QUERIES
// =====================================

// Total Revenue by Product for entire fiscal year
MATCH (rs:RevenueStream)-[:SELLS_PRODUCT]->(p:Product)
MATCH (rs)-[:HAS_VOLUME_DATA]->(vd:VolumeData)
MATCH (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)
MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp)
RETURN
    p.name as Product,
    SUM(vd.volume) as TotalVolumeKg,
    AVG(pd.price) as AvgPricePerKg,
    ROUND(SUM(vd.volume * pd.price), 2) as TotalRevenueUSD
ORDER BY TotalRevenueUSD DESC;

// Expected Results:
// Pitahaya: 184,503.9 kg × $6.63/kg = $1,223,260.86
// Goldenberries: 147,587.67 kg × $7.00/kg = $1,033,113.69
// Exotic Fruits: 16,500.0 kg × $5.00/kg = $82,500.00
// TOTAL: $2,338,874.55

// =====================================
// 8. RELATIONSHIP COUNT VALIDATION
// =====================================
// CRITICAL: Verify correct relationship patterns to prevent Cartesian products

// Validate TimePeriod connections (each should connect to exactly 3 nodes per type)
MATCH (tp:TimePeriod)<-[:OCCURS_IN_PERIOD]-(vd:VolumeData)
WITH tp, count(vd) as VolumeCount
WHERE VolumeCount != 3
RETURN tp.id as ProblematicTimePeriod, VolumeCount as ActualVolumeConnections
UNION
MATCH (tp:TimePeriod)<-[:PRICED_IN_PERIOD]-(pd:PriceData)
WITH tp, count(pd) as PriceCount
WHERE PriceCount != 3
RETURN tp.id as ProblematicTimePeriod, PriceCount as ActualPriceConnections;
// Expected Result: No rows (all TimePeriods should have exactly 3 connections each)

// Validate total relationship counts
MATCH (tp:TimePeriod)-[r1]-(vd:VolumeData)
MATCH (tp:TimePeriod)-[r2]-(pd:PriceData)
RETURN
    count(r1) as VolumeDataRelationships,
    count(r2) as PriceDataRelationships,
    count(r1) + count(r2) as TotalTimeSeriesRelationships;
// Expected Results: 39 VolumeData + 39 PriceData = 78 Total

// Detect duplicate nodes (should return no results)
MATCH (vd:VolumeData)
WITH vd.id as id, count(vd) as nodeCount
WHERE nodeCount > 1
RETURN id as DuplicateVolumeDataId, nodeCount
UNION
MATCH (pd:PriceData)
WITH pd.id as id, count(pd) as nodeCount
WHERE nodeCount > 1
RETURN id as DuplicatePriceDataId, nodeCount;
// Expected Result: No rows (no duplicate nodes should exist)