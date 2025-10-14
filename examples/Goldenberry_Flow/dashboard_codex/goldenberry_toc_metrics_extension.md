# Goldenberry Flow Dashboard - Theory of Constraints (TOC) Metrics Extension

## Project Context
- **Existing Dashboard**: Located at `@examples\Goldenberry_Flow\dashboard_codex\`
- **Database**: neo4j://127.0.0.1:7687 (same as original)
- **Credentials**: Username: neo4j | Password: 12345678 | Database: neo4j
- **Target Page**: Executive Dashboard (add new TOC Metrics section)
- **Completed Phases**: 1-15 (Revenue + Cost Analytics complete)

## Extension Overview
This specification adds Theory of Constraints (TOC) performance metrics to the Executive Dashboard based on business KPIs defined in Notion workspace. The TOC framework focuses on maximizing Throughput while minimizing Inventory and Operating Expenses.

### New Components:
1. **TOC Core Metrics Row** - 6 foundational TOC cards (T, I, OE, ROI, Productivity, Investment Turn)
2. **TOC Product Performance Table** - Per-product TOC analysis with strategic priority classification
3. **Inventory Turnover Gauge** - Visual indicator with target range highlighting
4. **Daily Throughput Rate Card** - Flow velocity metric for operational management

## Design Principles - MAINTAIN EXISTING STYLE
- **Reuse all existing visual components and patterns from Phases 1-15**
- Keep pure white background (#FFFFFF) throughout
- Maintain blue monochromatic scheme
- **Use distinctive blue tones for TOC metrics (different from revenue/cost)**
- No icons, emojis, or decorative elements
- Match existing card styles, chart formats, and layouts
- Professional minimalistic appearance

## Extended Color Palette for TOC Metrics
```
[EXISTING - Already in use]
Background: #FFFFFF (white)
Revenue blues: #0077B6, #00B4D8, #48CAE4
Cost blues: #1E3A8A, #3730A3, #4338CA, #1E40AF
Profit blues: #0EA5E9, #0284C7, #0369A1

[NEW - For TOC metrics]
TOC Throughput: #0891B2 (cyan blue)
TOC Inventory: #0369A1 (dark cyan)
TOC Operating Expense: #1E40AF (dark blue - reuse from cost)
TOC ROI/Productivity: #06B6D4 (bright cyan)
TOC positive indicators: #14B8A6 (teal-blue)
TOC warning indicators: #F59E0B (amber - only for targets/thresholds)
TOC danger indicators: #1E40AF (dark blue)
Strategic Priority - Champion: #0891B2 (cyan)
Strategic Priority - Contributor: #0284C7 (sky blue)
Strategic Priority - Diversifier: #60A5FA (light blue)
```

---

## TOC Metrics Definitions & Formulas

### Core TOC Metrics (T, I, OE)
```python
# Throughput (T)
T = Revenue - TVC (Totally Variable Costs)

# Inventory/Investment (I)
I = Working Capital Required (cash tied in inventory, receivables, buffers)

# Operating Expense (OE)
OE = Total Fixed Costs
```

### Derived TOC Metrics
```python
# ROI (TOC)
ROI_TOC = (T - OE) / I

# Productivity (T/OE)
Productivity = T / OE

# Investment Turn (T/I)
Investment_Turn = T / I

# Inventory Turnover
Inventory_Turnover = TVC / I

# Daily Throughput Rate
Daily_T = T / days_in_period
```

### Product-Level TOC Metrics
```python
# Product Throughput
Product_T = Product_Revenue - Product_TVC

# T Share
T_Share = Product_T / Total_T

# Allocated OE (by SKU)
Allocated_OE = OE * (Product_Revenue / Total_Revenue)

# T/OE Ratio (by SKU)
Product_T_OE_Ratio = Product_T / Allocated_OE

# Strategic Priority Classification
if T_Share >= 0.30 and Product_T_OE_Ratio >= 2.5:
    Priority = "Champion"  # Invest & Protect
elif T_Share >= 0.15 or Product_T_OE_Ratio >= 2.0:
    Priority = "Contributor"  # Improve cost/price
else:
    Priority = "Diversifier"  # Keep optional, don't clog constraint
```

---

## PHASE 1: Database TOC Query Methods

**Status:** Completed

### Goal: Add TOC calculation methods to Neo4jConnection class

### Modify file:
- `database/connection.py`

### Requirements:
1. Add method: `get_throughput()` - Returns T (Revenue - TVC)
2. Add method: `get_inventory_investment()` - Returns working capital required
3. Add method: `get_operating_expense()` - Returns OE (same as get_fixed_costs())
4. Add method: `get_toc_roi()` - Returns (T - OE) / I
5. Add method: `get_toc_productivity()` - Returns T / OE
6. Add method: `get_investment_turn()` - Returns T / I
7. Add method: `get_inventory_turnover()` - Returns TVC / I
8. Add method: `get_daily_throughput_rate(days=365)` - Returns T / days
9. Add method: `get_product_throughput(product_name)` - Returns product T
10. Add method: `get_product_toc_metrics(product_name)` - Returns comprehensive TOC dict

### Cypher Query Patterns:
```cypher
// Throughput (T = Revenue - TVC)
MATCH (p:Product)
MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp2:TimePeriod)
WHERE tp.id = tp2.id
WITH SUM(pd.price * vd.volume) AS totalRevenue

MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(:Product)
WITH totalRevenue, SUM(cd.amount) AS tvc
RETURN totalRevenue - tvc AS throughput

// Inventory/Investment (I) - Proxy via working capital
MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(:Product)
WITH SUM(cd.amount) AS tvc
MATCH (p:Product)
MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
WITH tvc, SUM(vd.volume) AS totalVolume
RETURN (tvc / totalVolume) * (totalVolume / 12.0) AS inventoryInvestment
// Note: Assumes 1-month inventory buffer; adjust multiplier based on actual cycle time

// Product Throughput
MATCH (p:Product {name: $productName})
MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp2:TimePeriod)
WHERE tp.id = tp2.id
WITH SUM(pd.price * vd.volume) AS productRevenue

MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(:Product {name: $productName})
WITH productRevenue, SUM(cd.amount) AS productTVC
RETURN productRevenue - productTVC AS productThroughput
```

### Data Assumptions:
- **Inventory/Investment (I)**: Since actual working capital data may not be in Neo4j, calculate as `Average Monthly TVC * 1.5` (assuming 1.5 months of inventory buffer). Document this clearly in tooltips.
- **Days in Period**: Default to 365 for annual metrics; make configurable for custom periods.

### Test before proceeding:
- All 10 methods return correct data types
- Queries execute without errors
- TOC ratios calculate correctly (no division by zero)
- Product filtering works correctly
- Test with Python script: `python -c "from database.connection import Neo4jConnection; conn = Neo4jConnection(); print(conn.get_throughput())"`

### Delivered:
- Implemented throughput, inventory proxy, operating expense alias, ROI, productivity, investment turn, inventory turnover, daily throughput rate, product throughput, and product TOC metrics with priority classification.
- Working capital proxy uses average monthly variable cost multiplied by a 1.5 buffer.
- Product-level OE allocation reconciles to total fixed costs; throughput shares sum to ~100%.

### Tests executed:
- `python -m compileall examples/Goldenberry_Flow/dashboard_codex/database/connection.py`
- Temporary smoke script (removed) printing all TOC totals, confirming OE allocation and throughput share sums.

---

## PHASE 2: TOC Core Metrics Row

**Status:** Not Started

### Goal: Add 6 TOC metric cards to Executive Dashboard

### Modify file:
- `pages/executive_dashboard.py`

### Add components after "Overall Business Performance" section:
1. Section header: "Theory of Constraints (TOC) Metrics"
2. Six metric cards in 2x3 grid:
   - **Throughput (T)**: Revenue - TVC | Format: `$XXX,XXX` | Footnote: "Money generated after variable costs"
   - **Operating Expense (OE)**: Total fixed costs | Format: `$XXX,XXX` | Footnote: "Keeping the lights on"
   - **Inventory (I)**: Working capital | Format: `$XXX,XXX` | Footnote: "*Estimated: 1.5 months of variable costs"
   - **ROI (TOC)**: (T - OE) / I | Format: `XXX.X%` | Target: **>100%** good, **>150%** stretch
   - **Productivity (T/OE)**: T / OE ratio | Format: `X.XX×` | Target: **>2.5** now, **3.0+** stretch
   - **Investment Turn (T/I)**: T / I ratio | Format: `X.XX×` | Target: **≥3.5** medium term

### Card Styling:
- Reuse existing `metric-card` CSS class
- Use TOC cyan/teal blue palette for borders/accents
- Show targets as footnotes (e.g., "Target: >2.5")
- Add color coding: Teal (#14B8A6) if meeting target, Amber (#F59E0B) if below

### Test before proceeding:
- All 6 cards display correctly
- Values calculate accurately
- Targets display in footnotes
- Color coding works (teal for good, amber for warning)
- Layout matches existing metric rows

### Delivered:
- Added _calculate_toc_metrics() and _render_toc_core_metrics() to compute throughput, inventory proxy, operating expense, ROI, productivity, and investment turn, rendering a six-card TOC grid.
- Inserted the TOC metrics section after business performance with matching header/divider styling and target-driven color cues.
- Cards reuse shared formatting, displaying teal when targets are met and amber when below threshold.

### Tests executed:
- python -m compileall examples/Goldenberry_Flow/dashboard_codex/pages/executive_dashboard.py
- Temporary smoke script (removed) printing _calculate_toc_metrics outputs before manual UI verification.


- All 6 cards display correctly
- Values calculate accurately
- Targets display in footnotes
- Color coding works (teal for good, amber for warning)
- Layout matches existing metric rows

---

## PHASE 3: Inventory Turnover Gauge

**Status:** Not Started

### Goal: Add visual gauge for Inventory Turnover metric

### Add to: `pages/executive_dashboard.py` (after TOC metrics row)

### Requirements:
1. Section header: "Inventory Turnover Analysis"
2. Plotly gauge chart showing Inventory Turnover ratio
3. Target zones:
   - **<12×**: Red zone (slow flow)
   - **12-15×**: Yellow zone (acceptable)
   - **15-22×**: Green zone (sweet spot)
   - **>22×**: Yellow zone (risk of stockouts)
4. Needle points to current value
5. Caption: "Times inventory cycles per year (TVC / I)"
6. Side-by-side layout: Gauge (left) + Explanation card (right)

### Gauge Configuration:
```python
def _render_inventory_turnover_gauge(connection: "Neo4jConnection") -> None:
    """Render inventory turnover gauge."""
    turnover = float(connection.get_inventory_turnover() or 0.0)

    fig = go.Figure(go.Indicator(
        mode="gauge+number",
        value=turnover,
        domain={'x': [0, 1], 'y': [0, 1]},
        title={'text': "Inventory Turnover", 'font': {'size': 18}},
        number={'suffix': "×", 'font': {'size': 32}},
        gauge={
            'axis': {'range': [0, 30], 'tickwidth': 1, 'tickcolor': "#E0E0E0"},
            'bar': {'color': "#0891B2"},  # TOC cyan
            'bgcolor': "white",
            'borderwidth': 2,
            'bordercolor': "#E0E0E0",
            'steps': [
                {'range': [0, 12], 'color': '#FEE2E2'},    # Red zone
                {'range': [12, 15], 'color': '#FEF3C7'},   # Yellow zone
                {'range': [15, 22], 'color': '#D1FAE5'},   # Green zone
                {'range': [22, 30], 'color': '#FEF3C7'},   # Yellow zone
            ],
            'threshold': {
                'line': {'color': "#0891B2", 'width': 4},
                'thickness': 0.75,
                'value': turnover
            }
        }
    ))

    fig.update_layout(
        paper_bgcolor="#FFFFFF",
        font={'color': COLORS["text_primary"], 'family': "Inter, 'Segoe UI', sans-serif"},
        height=300,
        margin=dict(t=40, b=20, l=20, r=20),
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})
```

### Explanation Card Content:
```
**Sweet Spot: 15-22× turns per year**

- <12×: Slow flow, excess inventory
- 12-15×: Acceptable, monitor closely
- 15-22×: Optimal balance
- >22×: Risk stockouts, add safety stock

Current: [XX.X×]
```

### Test before proceeding:
- Gauge renders correctly
- Zones display with correct colors (using blue-compatible shades)
- Needle points to correct value
- Explanation card appears beside gauge
- Responsive layout works on different screens

---

## PHASE 4: Product TOC Performance Table

**Status:** Not Started

### Goal: Add comprehensive per-product TOC analysis table

### Add to: `pages/executive_dashboard.py` (after Inventory Turnover gauge)

### Requirements:
1. Section header: "Product-Level TOC Performance"
2. Table with columns:
   - **Product**: Product name
   - **Throughput (T)**: Product revenue - Product TVC
   - **T Share**: Product T / Total T (percentage)
   - **Allocated OE**: Proportional fixed cost allocation
   - **T/OE Ratio**: Product T / Allocated OE
   - **Strategic Priority**: Champion | Contributor | Diversifier
3. Rows: One per product + TOTALS row
4. Strategic Priority color coding:
   - **Champion**: Cyan (#0891B2) - High T Share & High T/OE
   - **Contributor**: Sky blue (#0284C7) - Medium metrics
   - **Diversifier**: Light blue (#60A5FA) - Low share or low efficiency
5. TOTALS row: Light blue background (#DBEAFE)
6. Footnote: "*OE allocated proportionally by revenue share"

### Strategic Priority Rules:
```python
def _classify_strategic_priority(t_share: float, t_oe_ratio: float) -> tuple[str, str]:
    """
    Returns (priority_label, color_code)

    Champion: T Share ≥30% AND T/OE ≥2.5
    Contributor: T Share ≥15% OR T/OE ≥2.0
    Diversifier: Everything else
    """
    if t_share >= 30.0 and t_oe_ratio >= 2.5:
        return ("Champion", "#0891B2")
    elif t_share >= 15.0 or t_oe_ratio >= 2.0:
        return ("Contributor", "#0284C7")
    else:
        return ("Diversifier", "#60A5FA")
```

### Test before proceeding:
- All 6 cards display correctly
- Values calculate accurately
- Targets display in footnotes
- Color coding works (teal for good, amber for warning)
- Layout matches existing metric rows

### Delivered:
- Added _calculate_toc_metrics() and _render_toc_core_metrics() to compute throughput, inventory proxy, operating expense, ROI, productivity, and investment turn, rendering a six-card TOC grid.
- Inserted the TOC metrics section after business performance with matching header/divider styling and target-driven color cues.
- Cards reuse shared formatting, displaying teal when targets are met and amber when below threshold.

### Tests executed:
- python -m compileall examples/Goldenberry_Flow/dashboard_codex/pages/executive_dashboard.py
- Temporary smoke script (removed) printing _calculate_toc_metrics outputs before manual UI verification.


- Table displays all products
- TOC calculations are accurate
- Strategic priority classification works
- Color coding displays correctly
- TOTALS row highlighted
- Footnote appears below table
- Responsive on mobile/tablet

---

## PHASE 5: Daily Throughput Rate Card

**Status:** Not Started

### Goal: Add operational flow velocity metric

### Add to: `pages/executive_dashboard.py` (after Product TOC table)

### Requirements:
1. Single large metric card showing Daily Throughput Rate
2. Format: `$X,XXX/day`
3. Subtitle: "Pace of value creation per day"
4. Additional metrics in smaller text:
   - Weekly rate: `$XX,XXX/week`
   - Monthly rate: `$XXX,XXX/month`
5. Footnote: "Based on [XXX] days in period"
6. Use for operational decisions: buffer sizing, cash ramps

### Implementation:
```python
def _render_daily_throughput_card(connection: "Neo4jConnection") -> None:
    """Render daily throughput rate card."""
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Flow Velocity</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    # Calculate rates
    cost_records = connection.get_cost_timeseries()
    month_keys = {
        (row.get("year"), row.get("month"))
        for row in cost_records
        if row.get("year") and row.get("month")
    }
    days_in_period = len(month_keys) * 30  # Approximate

    daily_rate = float(connection.get_daily_throughput_rate(days_in_period) or 0.0)
    weekly_rate = daily_rate * 7
    monthly_rate = daily_rate * 30

    # Render card
    card_html = f"""
    <div class='metric-card' style='max-width:600px; margin:0 auto; padding:1.5rem;'>
        <div class='label'>Daily Throughput Rate</div>
        <div class='value' style='font-size:2.5rem; color:#0891B2;'>{_format_currency(daily_rate)}/day</div>
        <p style='margin-top:0.75rem; color:{COLORS['text_secondary']}; font-size:0.95rem;'>
            Pace of value creation per day
        </p>
        <div style='margin-top:1rem; display:flex; gap:2rem; justify-content:center;'>
            <div style='text-align:center;'>
                <small style='color:{COLORS['text_muted']}; display:block;'>Weekly</small>
                <span style='font-size:1.1rem; font-weight:600;'>{_format_currency(weekly_rate)}</span>
            </div>
            <div style='text-align:center;'>
                <small style='color:{COLORS['text_muted']}; display:block;'>Monthly</small>
                <span style='font-size:1.1rem; font-weight:600;'>{_format_currency(monthly_rate)}</span>
            </div>
        </div>
        <small style='display:block; margin-top:1rem; color:{COLORS['text_muted']};'>
            Based on {days_in_period} days in period
        </small>
    </div>
    """
    st.markdown(card_html, unsafe_allow_html=True)
```

### Test before proceeding:
- Card displays correctly
- Daily rate calculates accurately
- Weekly/monthly projections are correct
- Footnote shows correct day count
- Styling matches existing cards

---

## PHASE 6: TOC Insights & Recommendations

**Status:** Not Started

### Goal: Add actionable insights based on TOC metrics

### Add to: `pages/executive_dashboard.py` (at bottom, before final caption)

### Requirements:
1. Section header: "TOC Action Items"
2. Dynamic recommendation cards based on metric analysis
3. Show 2-4 highest priority actions
4. Each card shows:
   - Metric trigger (e.g., "Inventory Turnover: 8.2×")
   - Recommendation (e.g., "Slow flow detected")
   - Action (e.g., "Shorten cash-to-cash cycle, reduce batch sizes")
   - Priority level (High | Medium | Low)

### Recommendation Rules:
```python
def _generate_toc_recommendations(metrics: dict, product_toc: dict) -> List[dict]:
    """Generate actionable recommendations based on TOC analysis."""
    recommendations = []

    # Rule 1: Low Productivity
    if metrics.get("productivity", 0) < 2.5:
        recommendations.append({
            "metric": "Productivity (T/OE)",
            "value": f"{metrics['productivity']:.2f}×",
            "issue": "Below target threshold",
            "action": "Redirect operating expenses to constraint activities. Target: >2.5×",
            "priority": "High",
            "color": "#F59E0B",  # Amber
        })

    # Rule 2: Low Inventory Turnover
    turnover = metrics.get("inventory_turnover", 0)
    if turnover < 12:
        recommendations.append({
            "metric": "Inventory Turnover",
            "value": f"{turnover:.1f}×",
            "issue": "Slow flow detected",
            "action": "Shorten cash-to-cash cycle, reduce batch sizes, improve supplier terms",
            "priority": "High",
            "color": "#F59E0B",
        })

    # Rule 3: High Inventory Turnover
    if turnover > 25:
        recommendations.append({
            "metric": "Inventory Turnover",
            "value": f"{turnover:.1f}×",
            "issue": "Stockout risk",
            "action": "Add safety stock on volatile product lanes",
            "priority": "Medium",
            "color": "#0891B2",
        })

    # Rule 4: Low ROI
    if metrics.get("toc_roi", 0) < 100:
        recommendations.append({
            "metric": "ROI (TOC)",
            "value": f"{metrics['toc_roi']:.1f}%",
            "issue": "Below good threshold",
            "action": "Raise Throughput via price/mix or cut Inventory via cycle time improvements",
            "priority": "High",
            "color": "#F59E0B",
        })

    # Rule 5: Diversifier products clogging constraint
    for product in product_toc.get("products", []):
        if product["priority"] == "Diversifier" and product["t_share"] > 20:
            recommendations.append({
                "metric": f"{_clean_product_name(product['product'])} (Diversifier)",
                "value": f"{product['t_share']:.1f}% T Share",
                "issue": "High share for low-efficiency product",
                "action": "Review if product is clogging the constraint. Consider price increase or capacity reallocation.",
                "priority": "Medium",
                "color": "#0891B2",
            })

    # Rule 6: Champion products under-leveraged
    for product in product_toc.get("products", []):
        if product["priority"] == "Champion" and product["t_share"] < 40:
            recommendations.append({
                "metric": f"{_clean_product_name(product['product'])} (Champion)",
                "value": f"{product['t_share']:.1f}% T Share",
                "issue": "Growth opportunity",
                "action": "Invest and protect. Allocate scarce capacity to maximize throughput.",
                "priority": "Medium",
                "color": "#14B8A6",  # Teal (positive)
            })

    # Return top 4 by priority
    priority_order = {"High": 1, "Medium": 2, "Low": 3}
    recommendations.sort(key=lambda x: priority_order[x["priority"]])
    return recommendations[:4]
```

### Rendering:
```python
def _render_toc_recommendations(recommendations: List[dict]) -> None:
    """Render TOC action items."""
    if not recommendations:
        return

    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">TOC Action Items</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    # Render 2x2 grid of recommendation cards
    cols = st.columns(2)
    for idx, rec in enumerate(recommendations):
        with cols[idx % 2]:
            priority_badge_color = "#F59E0B" if rec["priority"] == "High" else "#0891B2"
            card_html = f"""
            <div class='metric-card' style='margin-bottom:1rem; border-left:4px solid {rec["color"]};'>
                <div style='display:flex; justify-content:space-between; align-items:center; margin-bottom:0.5rem;'>
                    <span style='font-weight:600; color:{COLORS["text_primary"]};'>{html.escape(rec["metric"])}</span>
                    <span style='padding:0.25rem 0.75rem; background:{priority_badge_color}; color:white; border-radius:12px; font-size:0.75rem; font-weight:600;'>
                        {rec["priority"]}
                    </span>
                </div>
                <div style='font-size:1.5rem; font-weight:700; color:{rec["color"]}; margin-bottom:0.25rem;'>
                    {html.escape(rec["value"])}
                </div>
                <div style='color:{COLORS["text_secondary"]}; font-size:0.9rem; margin-bottom:0.5rem;'>
                    {html.escape(rec["issue"])}
                </div>
                <div style='color:{COLORS["text_primary"]}; font-size:0.85rem; line-height:1.4;'>
                    <strong>Action:</strong> {html.escape(rec["action"])}
                </div>
            </div>
            """
            st.markdown(card_html, unsafe_allow_html=True)
```

### Test before proceeding:
- Recommendations generate correctly
- Priority sorting works
- Color coding matches priority
- No more than 4 cards display
- Layout is clean and readable
- Cards update when metrics change

---

## PHASE 7: Integration & Polish

**Status:** Not Started

### Goal: Integrate all TOC components and finalize presentation

### Tasks:
1. **Performance Optimization**:
   - Add `@st.cache_data` decorators to TOC query methods
   - Optimize repeated calculations (cache TOC metrics dict)
   - Review data loading patterns

2. **Error Handling**:
   - Add try-except blocks for all TOC queries
   - Graceful handling of missing data (display "N/A" with explanations)
   - Empty state messages for incomplete data

3. **Loading Indicators**:
   - Add "Loading TOC metrics..." messages where appropriate
   - Use `st.spinner` for long-running queries

4. **Page Flow**:
   - Ensure logical section ordering:
     1. Revenue Overview (existing)
     2. Cost Overview (existing)
     3. Product Performance Highlights (existing)
     4. Distribution Overview (existing)
     5. Overall Business Performance (existing)
     6. **TOC Core Metrics (NEW - Phase 2)**
     7. **Inventory Turnover Gauge (NEW - Phase 3)**
     8. **Product TOC Performance Table (NEW - Phase 4)**
     9. **Daily Throughput Rate (NEW - Phase 5)**
     10. **TOC Action Items (NEW - Phase 6)**

5. **Responsive Design**:
   - Test all components on desktop, tablet, mobile
   - Ensure tables scroll horizontally on small screens
   - Verify gauge renders correctly at all sizes

6. **Documentation**:
   - Update README.md with TOC metrics features
   - Document TOC calculation methods in connection.py
   - Add docstrings to all new functions
   - Create inline comments for complex formulas

7. **Footnotes & Explanations**:
   - Add tooltips/footnotes explaining TOC concepts
   - Clarify Inventory calculation methodology (estimated vs actual)
   - Link to TOC resources for user education

### Testing Checklist:
- [ ] All TOC metrics calculate correctly
- [ ] Database queries execute without errors
- [ ] Page loads in < 3 seconds
- [ ] All visualizations render correctly
- [ ] Strategic priority classification works
- [ ] Recommendations generate appropriately
- [ ] Color scheme consistent (blue monochromatic)
- [ ] No console errors
- [ ] Responsive on all screen sizes
- [ ] Tooltips/footnotes display correctly
- [ ] Empty states handled gracefully

### Documentation Updates:

**README.md additions:**
```markdown
## TOC Metrics Extension (v3.0)

### Executive Dashboard - TOC Analysis
- **Core TOC Metrics**: Throughput (T), Inventory (I), Operating Expense (OE)
- **Derived Metrics**: ROI (TOC), Productivity (T/OE), Investment Turn (T/I)
- **Inventory Turnover Gauge**: Visual indicator with target zones (15-22× sweet spot)
- **Product TOC Performance**: Per-product throughput analysis with strategic priority classification
  - Champion products: High T Share & High T/OE (Invest & Protect)
  - Contributor products: Medium metrics (Improve cost/price)
  - Diversifier products: Low share or efficiency (Keep optional, don't clog constraint)
- **Daily Throughput Rate**: Flow velocity for operational management
- **TOC Action Items**: Automated recommendations based on metric thresholds

### Strategic Priority Classification
- **Champion**: T Share ≥30% AND T/OE Ratio ≥2.5 → Invest & Protect
- **Contributor**: T Share ≥15% OR T/OE Ratio ≥2.0 → Improve cost/price
- **Diversifier**: Below thresholds → Keep optional, don't clog constraint
```

---

## Implementation Approach

Work through phases 1-7 sequentially. After completing each phase, test thoroughly before moving to the next. This ensures:
- Database layer is solid before building UI (Phase 1)
- Core TOC metrics foundation established (Phase 2)
- Visual indicators enhance understanding (Phase 3)
- Product-level analysis provides actionable insights (Phase 4)
- Operational metrics support daily decisions (Phase 5)
- Recommendations drive continuous improvement (Phase 6)
- Final polish ensures production quality (Phase 7)

## Technical Notes

### TOC Metric Targets (from Notion)
- **Inventory Turnover**: 15-22× (sweet spot)
- **Productivity (T/OE)**: >2.5 (now), push 3.0+
- **ROI (TOC)**: >100% (good), >150% (stretch)
- **Investment Turn (T/I)**: ≥3.5 (medium term)
- **Product T/OE Ratio**: >2.5 (prioritize for capacity & marketing)

### Working Capital Estimation
Since actual working capital data may not exist in Neo4j:
- **Proxy Formula**: `I = Average Monthly TVC × Buffer Factor`
- **Buffer Factor**: Start with 1.5 (1.5 months inventory)
- **Adjustable**: Add configuration option to tune buffer factor
- **Document Clearly**: Add footnote explaining estimation method

### Strategic Priority Thresholds
- **Champion**: T Share ≥30% AND T/OE ≥2.5
- **Contributor**: T Share ≥15% OR T/OE ≥2.0
- **Diversifier**: Everything else

### Color Consistency
- Use ONLY blue/cyan/teal tones for all TOC visualizations
- Amber (#F59E0B) ONLY for warning indicators in thresholds/gauges
- Maintain visual distinction via saturation and brightness
- Teal (#14B8A6) for positive/meeting targets
- Amber (#F59E0B) for warnings/below targets
- Dark blue (#1E40AF) for danger/critical thresholds

### Component Reuse
- **Metric Cards**: Reuse pattern from existing cost/revenue cards
- **Tables**: Match styling from business performance table
- **Gauges**: Use Plotly indicator charts (similar to product performance gauge)
- **Page Headers**: Use `render_page_header()` from components.py
- **Empty States**: Use `render_empty_state()` from components.py

## Data Validation

Before deploying, verify:
1. **Throughput = Revenue - TVC** (matches across all calculations)
2. **OE = Fixed Costs** (should be identical)
3. **ROI (TOC) = (T - OE) / I** (formula correct)
4. **Productivity = T / OE** (formula correct)
5. **Investment Turn = T / I** (formula correct)
6. **Inventory Turnover = TVC / I** (formula correct)
7. **Product T Share** sums to 100% across all products
8. **Allocated OE** sums to total OE across all products
9. **Strategic Priority** classification rules apply correctly
10. No negative values where impossible

---

## Expected Deliverables

After completing all 7 phases:

### Database Layer (`database/connection.py`):
- 10 new TOC query methods
- Comprehensive docstrings
- Error handling for all queries

### Executive Dashboard (`pages/executive_dashboard.py`):
- TOC Core Metrics section (6 cards)
- Inventory Turnover Gauge
- Product TOC Performance Table
- Daily Throughput Rate card
- TOC Action Items section
- All integrated into existing page flow

### Documentation:
- Updated README.md with TOC features
- Inline comments explaining TOC formulas
- Footnotes/tooltips for user education

### User Experience:
- Clean, professional blue monochromatic design
- Actionable insights via recommendations
- Strategic priority classification for portfolio decisions
- Operational metrics for daily management
- Educational tooltips explaining TOC concepts

---

## References

- **Notion TOC Metrics Guide**: `Goldenberry Flow: Business Metrics` → `Theory of Constraints (TOC) Metrics — KPI Guide`
- **TOC Literature**: Goldratt's "The Goal" and "Theory of Constraints"
- **Existing Dashboard**: Phases 1-15 (Revenue + Cost Analytics)


