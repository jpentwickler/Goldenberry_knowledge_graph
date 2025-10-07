# Goldenberry Flow Dashboard - Cost Analysis Extension Specifications

## Project Context
- **Existing Dashboard**: Located at @examples\Goldenberry_Flow\dashboard_codex\
- **Database**: neo4j://127.0.0.1:7687 (same as original)
- **Credentials**: Username: neo4j | Password: 12345678 | Database: neo4j
- **Base Structure**: Three existing pages (Executive Dashboard, Revenue Overview, Product Performance)

## Extension Overview
This specification adds comprehensive cost analysis capabilities to the existing dashboard:
1. **New Page**: Cost Overview (mirrors Revenue Overview structure)
2. **Enhanced Page**: Product Performance (add 4 cost components)
3. **Enhanced Page**: Executive Dashboard (add 4 cost/profitability sections)

## Design Principles - MAINTAIN EXISTING STYLE
- **Reuse all existing visual components and patterns**
- Keep pure white background (#FFFFFF) throughout
- Maintain blue monochromatic scheme throughout entire dashboard
- **Use darker/different blue tones to distinguish cost from revenue visualizations**
- No icons, emojis, or decorative elements
- Match existing card styles, chart formats, and layouts
- Maintain professional minimalistic appearance

## Extended Color Palette
```
[EXISTING - Keep unchanged]
Background: #FFFFFF (white)
Card backgrounds: #F8F9FA (light grey)
Revenue visualizations: Blues (#0077B6, #00B4D8, #48CAE4)
Text: #212529 (primary), #6C757D (secondary)

[NEW - For cost extensions - Blue tones only]
Cost metrics/borders: #1E40AF (dark blue)
Cost chart primary: #1E3A8A (navy blue)
Cost chart secondary: #3730A3 (indigo)
Cost chart tertiary: #4338CA (violet-blue)
Profit metrics: #0EA5E9 (sky blue)
Profitability/Margin: #0284C7 (deeper sky blue)
Net profit: #0369A1 (dark cyan-blue)
Cost backgrounds: #DBEAFE (light blue)
Accent for trends: #60A5FA (bright blue)
```

---

## PHASE 1: Database Cost Query Methods

**Status:** Completed - cost query helpers added to `database/connection.py` and connection cleanup restored.

### Goal: Add cost data retrieval methods to Neo4jConnection class

### Modify file:
- database/connection.py

### Requirements:
1. Add method: `get_total_costs()` - returns sum of all costs
2. Add method: `get_variable_costs()` - returns sum of product-linked costs
3. Add method: `get_fixed_costs()` - returns sum of overhead costs
4. Add method: `get_cost_timeseries(product=None, category=None)` - monthly costs by category
5. Add method: `get_quarterly_costs(product=None, category=None)` - quarterly costs
6. Add method: `get_cost_categories()` - list of active cost structure names
7. Add method: `get_product_costs(product_name)` - costs for specific product
8. Add method: `get_average_cost_per_kg()` - weighted average across all products

### Cypher Query Patterns:
```cypher
// Total costs
MATCH (cd:CostData)
RETURN SUM(cd.amount) AS totalCosts

// Variable costs (product-linked)
MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->()
RETURN SUM(cd.amount) AS variableCosts

// Fixed costs (no product link)
MATCH (cd:CostData)
WHERE NOT (cd)-[:COST_FOR_PRODUCT]->()
RETURN SUM(cd.amount) AS fixedCosts

// Monthly cost timeseries
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
OPTIONAL MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
RETURN p.name AS product, cs.name AS category, 
       tp.year AS year, tp.month AS month, 
       SUM(cd.amount) AS cost
ORDER BY year, month
```

### Test before proceeding:
- All 8 methods return correct data types
- Queries execute without errors
- Product filtering works correctly
- Test with simple print statements in a test page
- Validated via `C:/Users/jprob/anaconda3/envs/base1/python.exe phase1_cost_methods_test.py` to exercise totals, filters, and `close_connection()`.

---

## PHASE 2: Cost Overview Page - Navigation Setup

**Status:** Completed - navigation updated with Cost Overview tab and placeholder page stub in `pages/cost_overview.py`.

### Goal: Add fourth navigation tab for Cost Overview page

### Modify files:
- app.py (add fourth tab)
- pages/__init__.py (if needed for imports)

### Create file:
- pages/cost_overview.py (empty placeholder)

### Requirements:
1. Add "Cost Overview" as fourth tab in app.py
2. Import cost_overview module
3. Create placeholder render() function in cost_overview.py
4. Use same page_header component pattern as existing pages

### Test before proceeding:
- Fourth tab appears in navigation
- Can switch to Cost Overview page
- Page shows header with title "Cost Overview"
- No errors when navigating between all four tabs
- Verified tab order now places Cost Overview between Revenue and Product pages

---

## PHASE 3: Cost Timeline Filters

**Status:** Completed - Variable cost filters implemented with product-only selection and live dataset wiring.

### Goal: Create filter controls for Cost Timeline section

### Add to: pages/cost_overview.py

### Requirements (Delivered):
1. Page header with Cost Overview subtitle
2. Horizontal filter layout with Start/End month selectors
3. Product multiselect limited to three fruit products (defaults to all)
4. Session-state persistence for selections
5. Responsive updates (no Apply button)

### Test coverage:
- Filters render correctly and persist state
- Month range selector restricts data window
- Product multiselect reflects database contents
- Empty-state messaging triggers when combination has no data

---

## PHASE 4: Cost Timeline Chart

**Status:** Completed - Product procurement timeline chart with per-product summary card.

### Goal: Add multi-line chart showing monthly variable costs by product

### Add to: pages/cost_overview.py

### Implementation Notes:
- New Neo4j helper `get_variable_cost_timeseries()` aggregates monthly variable costs
- Plotly line chart groups by product, styled with existing product palette
- Selection caption shows total spend across selected months
- Summary card lists per-product totals with overall total line

### Test coverage:
- Chart updates immediately when month or product filters change
- Hover tooltips show month and product cost
- Summary totals match filtered dataset
- Empty-state triggers when no products or months selected

---

## PHASE 5: Fixed Cost Timeline Filters

**Status:** Pending

### Goal: Prepare filters for fixed cost visualization

### Add to: pages/cost_overview.py

### Requirements:
1. Section header "Fixed Cost Timeline"
2. Month range selectors (reuse from variable timeline)
3. Category multiselect limited to: Personnel, Trade Shows, One-time Setup
4. Toggle (radio buttons) for Bar display mode: Stacked vs Grouped
5. Session-state persistence for selections
6. Empty-state messaging for missing data

### Test before proceeding:
- Filters render correctly with only three categories
- Toggle updates stored mode
- Month range selector clamps correctly
- Empty-state triggers when selection has no data

---

## PHASE 6: Fixed Cost Timeline Chart

**Status:** Pending

### Goal: Build bar chart visualizing monthly fixed costs

### Add to: pages/cost_overview.py

### Requirements:
1. Use Plotly bar chart with toggle-controlled stacking/grouping
2. X-axis: monthly periods (Sep 2024 - Sep 2025)
3. Series: Personnel, Trade Shows, One-time Setup
4. Align colors with fixed cost palette (blue variations + accent for one-time)
5. Include caption summarizing total fixed cost for selected range
6. Provide summary card showing totals per category
7. Handle empty selections with friendly message

### Test before proceeding:
- Chart reflects toggle state (stacked vs grouped)
- Bars update immediately when filters change
- Totals in summary card align with chart data
- Hover tooltips display month, category, and cost
- Handles empty dataset without errors

---

## PHASE 7: Product Performance - Cost Metrics Cards

### Goal: Add 5 cost/profitability metric cards to Product Performance page

### Modify: pages/product_performance.py

### Requirements:
1. Add new section after Market Share gauge
2. Section header: "Cost Structure Analysis"
3. Five metric cards in horizontal row:
   - **Variable Cost**: Total direct costs for selected product
   - **Cost per KG**: Variable cost / total volume
   - **Gross Profit**: Revenue - Variable Cost
   - **Gross Margin**: (Gross Profit / Revenue) × 100
   - **Profit per KG**: Gross Profit / total volume
4. Card styling:
   - Dark blue left border for cost metrics (#1E40AF)
   - Sky blue left border for profit metrics (#0EA5E9)
   - Medium blue left border for margin metrics (#0284C7)
5. Update when product selection changes
6. Match existing metric card design pattern

### Calculation Logic:
```python
# Get product-specific data
product_revenue = get_product_revenue(selected_product)
product_volume = get_product_volume(selected_product)
variable_cost = get_product_variable_costs(selected_product)

# Calculate metrics
cost_per_kg = variable_cost / product_volume
gross_profit = product_revenue - variable_cost
gross_margin = (gross_profit / product_revenue) * 100
profit_per_kg = gross_profit / product_volume
```

### Test before proceeding:
- All 5 cards display correctly
- Values update when product selection changes
- Calculations are accurate for all three products
- Styling matches existing metric cards
- Color coding is correct (all blue tones)

---

## PHASE 8: Product Performance - Profitability Waterfall Chart

### Goal: Add waterfall chart showing revenue to profit breakdown

### Add to: pages/product_performance.py (after cost metrics)

### Requirements:
1. Section header: "How Revenue Becomes Profit"
2. Waterfall chart with sequential steps:
   - **Start**: Total Revenue (light blue bar, full height)
   - **Step 1**: -Fruit Procurement (dark blue bar going down)
   - **Step 2**: -Container & Packaging (navy blue bar going down)
   - **Step 3**: -Allocated Fixed Costs* (indigo bar going down)
   - **End**: Net Profit (sky blue bar at final level)
3. Use Plotly waterfall chart type
4. Hover shows amounts and percentages
5. Caption: "*Fixed costs allocated proportionally by revenue"
6. Color scheme: Light blues for positive values, darker blues for costs

### Fixed Cost Allocation Formula:
```python
# Allocate fixed costs proportionally
product_revenue_share = product_revenue / total_revenue
allocated_fixed = total_fixed_costs * product_revenue_share
net_profit = gross_profit - allocated_fixed
```

### Test before proceeding:
- Waterfall displays correctly
- Shows correct sequential calculation
- Updates when product changes
- Hover tooltips work
- Colors distinguish revenue vs costs (all blue tones)

---

## PHASE 9: Product Performance - Cost Composition Donut

### Goal: Add donut chart showing cost breakdown for selected product

### Add to: pages/product_performance.py

### Requirements:
1. Section header: "Cost Breakdown by Category"
2. Donut chart (same style as Executive Dashboard revenue donut)
3. Shows cost composition for selected product:
   - Fruit Procurement (percentage and amount)
   - Container & Packaging (if applicable)
   - Allocated Fixed Costs (proportional)
4. Center displays: Total Cost amount
5. Color scheme: Navy/indigo blues for variable costs, lighter blues for fixed costs
6. Outside labels show percentages
7. Hover shows exact amounts
8. Layout: Side-by-side with next component (sparklines)

### Test before proceeding:
- Donut renders correctly
- Shows accurate percentages
- Updates with product selection
- Center value is correct
- Colors use blue palette consistently

---

## PHASE 10: Product Performance - Cost Trends Sparklines

### Goal: Add 4 mini trend charts showing cost/profit metrics over time

### Add to: pages/product_performance.py

### Requirements:
1. Section header: "Cost Trends Over Time"
2. 2x2 grid of sparkline cards:
   - **Variable Cost per KG**: Last 12 months trend
   - **Gross Margin %**: Last 12 months trend
   - **Total Monthly Cost**: Last 12 months trend
   - **Profit per KG**: Last 12 months trend
3. Each card shows:
   - Metric label (top)
   - Current value (large, center)
   - Sparkline chart (last 12 months)
   - Change indicator: "↑/↓ $X (X%) vs 3 months ago"
4. Color coding:
   - Bright blue (#60A5FA) for improving trends
   - Dark blue (#1E40AF) for worsening trends
5. Use Plotly or simple SVG for sparklines
6. Layout: Side-by-side with Cost Donut

### Test before proceeding:
- All 4 sparklines display
- Show last 12 months of data
- Update with product selection
- Change indicators correct
- Colors indicate trend direction properly (all blue tones)

---

## PHASE 11: Executive Dashboard - Cost Metrics Row

### Goal: Add 6 cost-related metric cards to Executive Dashboard

### Modify: pages/executive_dashboard.py

### Requirements:
1. Add new row of metric cards after existing revenue metrics
2. Section divider: Horizontal rule or spacing
3. Six metric cards:
   - **Total Costs**: Sum of all costs
   - **Variable Costs**: Direct product costs + footnote "XX% of total"
   - **Fixed Costs**: Overhead costs + footnote "XX% of total"
   - **Avg Cost per KG**: Weighted average across all products
   - **Gross Margin**: Overall gross margin % + footnote "Avg across all products"
   - **Avg Monthly Cost**: Total costs / number of months
4. Card styling: Dark blue left borders (#1E40AF) for cost metrics, medium blue (#0284C7) for margin
5. Same design pattern as existing revenue metrics

### Test before proceeding:
- All 6 cards display correctly
- Values are accurate
- Footnotes display where specified
- Styling matches existing cards
- Layout is clean and aligned

---

## PHASE 12: Executive Dashboard - Enhanced Product Cards

### Goal: Replace existing product cards with enhanced version including cost/profit

### Modify: pages/executive_dashboard.py

### Requirements:
1. **Replace** existing product highlight cards (keep same section)
2. Enhanced cards show for top 3 products:
   - Product Name (header)
   - **Revenue**: Total revenue
   - **Variable Cost**: Direct costs
   - **Gross Profit**: Revenue - Variable Cost (sky blue text #0EA5E9)
   - **Gross Margin**: Percentage (medium blue text #0284C7)
   - **Cost per KG**: Average cost per kilogram
3. Remove: Total Volume (less relevant for executives)
4. Add: Profit and margin metrics
5. Keep same 3-column grid layout
6. Color coding: Different blue tones for different metrics

### Test before proceeding:
- Cards show all new metrics
- Calculations are correct
- Top 3 products still displayed
- Color coding works (all blue tones)
- Layout unchanged from original

---

## PHASE 13: Executive Dashboard - Cost Distribution Donut

### Goal: Add cost breakdown donut chart next to revenue donut

### Add to: pages/executive_dashboard.py

### Requirements:
1. Place side-by-side with existing Revenue Distribution donut
2. Section header: "Cost Distribution by Category"
3. Donut chart showing all cost categories:
   - Fruit Procurement (largest segment)
   - Export Operations Personnel
   - Market Development
   - Container & Packaging
   - Certifications & Compliance
   - Setup Costs
   - (Any other active cost categories)
4. Color scheme: Navy/indigo blues for variable costs, lighter blues for fixed costs
5. Center displays: Total Costs amount
6. Outside labels show percentages
7. Hover shows exact amounts
8. Match existing donut chart style

### Layout:
```
[Revenue Distribution]  [Cost Distribution]
   (Existing donut)      (New donut)
```

### Test before proceeding:
- Donut renders correctly
- Shows all active cost categories
- Percentages accurate
- Colors distinguish variable vs fixed (all blue tones)
- Side-by-side layout works on all screen sizes

---

## PHASE 14: Executive Dashboard - Business Performance Section

### Goal: Add overall business performance metrics and consolidated table

### Add to: pages/executive_dashboard.py (at bottom)

### Requirements:
1. Section header: "Overall Business Performance"
2. **Part A**: Four metric cards:
   - **Total Net Profit**: Revenue - All Costs (sky blue border #0EA5E9)
   - **Overall Profit Margin**: (Net Profit / Revenue) × 100 (medium blue border #0284C7)
   - **Break-even Coverage**: Revenue / Total Costs (bright blue border #60A5FA)
   - **Contribution Margin**: Total Gross Profit (cyan-blue border #0369A1)
3. **Part B**: Consolidated Product Profitability Table:
   - Columns: Product | Revenue | Variable Cost | Gross Profit | Gross Margin % | Net Profit* | Net Margin %
   - Rows: One per product + TOTALS row
   - Color coding: Sky blue (#0EA5E9) for gross profit, darker blue (#0369A1) for net profit
   - Footer note: "*Net profit includes allocated fixed costs"
   - TOTALS row highlighted with light blue background (#DBEAFE)

### Fixed Cost Allocation for Table:
```python
# For each product
revenue_share = product_revenue / total_revenue
allocated_fixed = total_fixed_costs * revenue_share
net_profit = gross_profit - allocated_fixed
net_margin = (net_profit / product_revenue) * 100
```

### Test before proceeding:
- All 4 metric cards correct
- Table displays all products
- All calculations accurate
- TOTALS row highlighted
- Color coding works (all blue tones)
- Fixed costs allocated correctly

---

## PHASE 15: Polish and Documentation

### Goal: Final refinements, error handling, and documentation

### Tasks:
1. **Performance Optimization**:
   - Add @st.cache_data decorators to cost query methods
   - Optimize repeated calculations
   - Review data loading patterns

2. **Error Handling**:
   - Add try-except blocks for all cost queries
   - Graceful handling of missing cost data
   - Empty state messages for incomplete data

3. **Loading Indicators**:
   - Add "Loading cost data..." messages where appropriate
   - Use st.spinner for long-running queries

4. **Styling Consistency**:
   - Review all new components for consistent spacing
   - Ensure color palette adherence (all blue tones)
   - Check responsive behavior on different screen sizes
   - Verify all charts have white backgrounds

5. **Documentation**:
   - Update README.md with new features
   - Document new database methods in connection.py
   - Add docstrings to all new functions
   - Create inline comments for complex calculations

6. **Testing Checklist**:
   - [ ] All 4 pages load without errors
   - [ ] Navigation between pages works smoothly
   - [ ] All filters respond immediately
   - [ ] All calculations verified against source data
   - [ ] Charts render correctly in all scenarios
   - [ ] Color scheme consistent throughout (blue tones only)
   - [ ] No console errors
   - [ ] Performance acceptable (< 2s page loads)

### Documentation Updates:

**README.md additions:**
```markdown
## Extended Features (v2.0)

### Cost Overview Page
- Monthly cost timeline with category and product filtering
- Quarterly cost analysis with stacked/grouped views
- Cost distribution breakdowns

### Enhanced Product Performance
- Cost structure analysis with 5 key metrics
- Revenue-to-profit waterfall visualization
- Cost composition breakdown
- Cost trend sparklines

### Enhanced Executive Dashboard
- Complete cost metrics (6 cards)
- Product profitability analysis
- Cost distribution visualization
- Consolidated business performance table
```

### Test complete application:
- All phases integrated successfully
- No visual inconsistencies
- Performance is acceptable
- Documentation is complete

---

## Implementation Approach

Work through phases 1-15 sequentially. After completing each phase, test thoroughly before moving to the next. This ensures:
- Database layer is solid before building UI (Phase 1)
- New page works before enhancing existing pages (Phases 2-6)
- Product Performance extensions complete before Executive Dashboard (Phases 7-10)
- Executive Dashboard enhanced systematically (Phases 11-14)
- Final polish ensures production quality (Phase 15)

## Key Cypher Queries for Cost Data

### Monthly Cost Timeseries
```cypher
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
OPTIONAL MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
WITH p.name AS product, cs.name AS category, 
     tp.year AS year, tp.month AS month,
     SUM(cd.amount) AS monthlyCost
RETURN product, category, year, month, monthlyCost
ORDER BY year, month, category
```

### Quarterly Cost Data
```cypher
MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
OPTIONAL MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
WITH p.name AS product, cs.name AS category,
     tp.year AS year, tp.quarter AS quarter,
     SUM(cd.amount) AS quarterlyCost
RETURN product, category, year, quarter, quarterlyCost
ORDER BY year, quarter, category
```

### Product Cost Breakdown
```cypher
MATCH (p:Product {name: $productName})
OPTIONAL MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(p)
OPTIONAL MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
WITH cs.name AS category, SUM(cd.amount) AS cost
RETURN category, cost
ORDER BY cost DESC
```

## Technical Notes

### Blue Monochromatic Color Scheme
- **Critical**: Use ONLY blue color palette throughout entire dashboard
- Revenue visualizations: Light/medium blues (#0077B6, #00B4D8, #48CAE4)
- Cost visualizations: Dark/navy blues (#1E3A8A, #3730A3, #4338CA, #1E40AF)
- Profit metrics: Sky/cyan blues (#0EA5E9, #0284C7, #0369A1)
- Trend indicators: Bright blue (#60A5FA) for positive, dark blue (#1E40AF) for negative
- Background accents: Light blue (#DBEAFE) for highlighted sections

### Visual Distinction Strategy
- Use **saturation and brightness** to distinguish cost from revenue
- Darker, more saturated blues = costs
- Lighter, brighter blues = revenue
- Mid-tone blues = profitability metrics
- Maintain clear visual hierarchy through blue tones only

### Fixed Cost Allocation
- Allocate proportionally by revenue across all products
- Formula: `allocated_fixed = (product_revenue / total_revenue) * total_fixed_costs`
- Show allocation method in footnotes/captions
- Consistent across all pages

### Existing Component Reuse
- **Metric Cards**: Reuse exact pattern from executive_dashboard.py
- **Filters**: Reuse patterns from revenue_overview.py
- **Charts**: Match Plotly configuration from existing charts
- **Page Headers**: Use components.py render_page_header()
- **Empty States**: Use components.py render_empty_state()

### Known Issues to Avoid
- No HTML comments in st.markdown() blocks (Streamlit parser bug)
- Test with all three products to ensure calculations work
- Handle division by zero for products with no costs
- Ensure multiselect filters handle state correctly

## Data Validation

Before deploying, verify:
1. **Total Revenue** - **Total Costs** = **Net Profit** (should match across all pages)
2. Variable Costs + Fixed Costs = Total Costs
3. Gross Profit = Revenue - Variable Costs (per product)
4. Net Profit = Gross Profit - Allocated Fixed Costs (per product)
5. All percentages between 0-100%
6. No negative values where impossible
7. Costs allocated to products sum to variable costs
8. Sum of allocated fixed costs equals total fixed costs
