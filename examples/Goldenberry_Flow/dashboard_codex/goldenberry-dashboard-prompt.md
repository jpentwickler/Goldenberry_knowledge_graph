# Goldenberry Flow Revenue Dashboard - Incremental Build Specifications

## Project Setup
- Create project directory at: @examples\Goldenberry_Flow\
- Database connection: neo4j://127.0.0.1:7687
- Username: neo4j
- Password: 12345678
- Database name: neo4j (default)

## Design Requirements
- Pure white background (#FFFFFF) throughout entire application
- Blue monochromatic color scheme for all data visualizations and UI elements
- All charts must have white backgrounds with blue visualizations
- No icons, emojis, or decorative elements
- Professional minimalistic appearance
- Clear contrast with blue elements on white background

## Dashboard Structure
Three pages with horizontal navigation:
1. Executive Dashboard
2. Revenue Overview (with two independent sections: Timeline and Quarterly Performance)
3. Product Performance

## Color Palette
```
Background: #FFFFFF (white)
Card backgrounds: #F8F9FA (light grey)
Grid lines: #E0E0E0 (light grey)
Borders: #0077B6 (blue)
Goldenberries: #0077B6 (deep blue)
Pitahaya: #00B4D8 (bright blue)
Exotic Fruits: #48CAE4 (medium blue)
Text primary: #212529 (dark grey/black)
Text secondary: #6C757D (medium grey)
Highlights: #023E8A (dark blue)
Accent: #90E0EF (light blue for hover/selection)
```

---

## PHASE 1: Basic Navigation Structure

### Goal: Create app skeleton with navigation only

### Create files:
- app.py with top navigation bar
- Three empty page files
- Basic project structure

### Requirements:
1. Streamlit app with wide layout, NO sidebar
2. Top navigation bar with three options (Executive Dashboard, Revenue Overview, Product Performance)
3. Each page shows only page title as placeholder
4. White background throughout

### Test before proceeding:
- Navigation bar visible at top
- Can switch between three pages
- No sidebar appears

---

## PHASE 2: Database Connection

### Goal: Add Neo4j connection and verify it works

### Add to existing structure:
- database/connection.py
- config.py with credentials
- Simple test query display on Executive Dashboard

### Requirements:
1. Create connection handler
2. Add connection status indicator (text only)
3. Display count of products as test

### Test before proceeding:
- Connection successful message appears
- Product count displays correctly

---

## PHASE 3: First Metric Card

### Goal: Add ONE metric card to Executive Dashboard

### Add component:
- Single card showing Total Revenue
- Position: Top left of Executive Dashboard
- Style: Light grey background, blue border
- Format: $XXX,XXX.XX

### Test before proceeding:
- Card displays correctly
- Number is formatted properly
- Styling matches requirements

---

## PHASE 4: Complete Metric Row

### Goal: Add remaining three metric cards

### Add components (one at a time):
1. Total Volume card (next to Total Revenue)
2. Average Monthly Revenue card
3. Average Price per KG card

### Layout:
- Four cards in single horizontal row
- Equal spacing
- Consistent styling

### Test before proceeding:
- All four cards aligned properly
- Each calculation is correct

---

## PHASE 5: Product Highlights Table

### Goal: Add product summary section

### Add component:
- Three-column layout below metrics
- One column per product
- Show: Product name, Revenue, Volume, Avg Price
- Blue headers, white background

### Test before proceeding:
- Table displays all three products
- Values are accurate
- Layout is clean

---

## PHASE 6: First Chart - Donut Chart

**Status:** Completed - donut chart renders on the Executive Dashboard.


### Goal: Add revenue distribution visualization

### Add component:
- Donut chart on Executive Dashboard
- Below product highlights
- Three segments (one per product)
- Blue color variations
- White background

### Test before proceeding:
- Chart renders correctly
- Percentages are accurate
- Legend is readable

---

## PHASE 7: Revenue Timeline Filters

**Status:** Completed - timeline filters implemented with responsive layout on Revenue Overview.


### Goal: Create Revenue Overview page with timeline section

### Add components:
- Page title "Revenue Overview"
- Section header "Timeline Chart"
- Filter controls for timeline (not in sidebar):
  - Date range selector (Start Month, End Month dropdowns)
  - Product checkboxes (Goldenberries, Pitahaya, Exotic Fruits)
- Space reserved for chart below filters

### Layout:
- Filters at top of timeline section
- Horizontal layout for filters
- Clear section separation
- Filters update chart immediately on change (responsive)

### Test before proceeding:
- Filters appear on page (not sidebar)
- All controls are functional
- Changes update immediately (no Apply button needed)
- Layout is clean

---

## PHASE 8: Timeline Chart\n\n**Status:** Completed - multi-product revenue timeline chart updates instantly with filters.

### Goal: Add revenue trend line chart

### Add component:
- Line chart showing monthly revenue
- Always displays monthly data (no quarterly option)
- One line per product
- Interactive hover
- Updates immediately when filters change (responsive)

### Test before proceeding:
- Chart displays all products
- Date range filter instantly adjusts X-axis
- Product filter immediately shows/hides lines
- Hover shows values
- No lag in filter response

---

## PHASE 9: Quarterly Performance Filters

**Status:** Completed - polished quarterly filter stack with mode toggle ready for visualization.


### Goal: Add quarterly section with its own filters

### Add components:
- Section header "Quarterly Performance"
- Filter controls for quarterly chart:
  - Quarter checkboxes (Q3 2024, Q4 2024, Q1 2025, Q2 2025, Q3 2025)
  - Product checkboxes (Goldenberries, Pitahaya, Exotic Fruits)
  - Bar display toggle: "Stacked" or "Grouped" (radio buttons)
  - Optional: "Select All" / "Clear All" links for quarters
- Space reserved for chart below filters

### Layout:
- Separate section below timeline chart
- Independent filters from timeline section
- Visual separation between sections
- Responsive updates (no Apply/Reset buttons)

### Test before proceeding:
- Second filter set appears correctly
- Can select/deselect individual quarters
- Product filters work independently
- Toggle between Stacked/Grouped works
- Changes apply instantly

---

## PHASE 10: Quarterly Bar Chart

**Status:** Completed - stacked/grouped quarterly bar chart with persistent toggle and filter summaries.

### Goal: Add quarterly performance bar chart

### Add component:
- Bar chart below quarterly filters
- Shows only selected quarters
- Two display modes based on toggle:
  - Stacked: Products stacked in single bar per quarter (shows total and composition)
  - Grouped: Products side by side for each quarter (shows individual comparison)
- Updates instantly when filters or display mode change

### Test before proceeding:
- Bars display correctly in both modes
- Stacked view shows total quarterly revenue with product segments
- Grouped view shows products side by side for comparison
- Shows only selected quarters (responsive to checkbox changes)
- Shows only selected products (responsive to checkbox changes)
- Can compare non-consecutive quarters
- Toggle between views works smoothly
- No delay in updates

---

## PHASE 11: Product Selector

**Status:** Completed - product selectbox defaults to Goldenberries and persists user choice.

### Goal: Start Product Performance page

### Add component:
- Dropdown selector at top of page
- Lists three products
- Default: Goldenberries

### Test before proceeding:
- Dropdown works
- Selection persists

---

## PHASE 12: Product Metrics

**Status:** Completed - three product metric cards render with live revenue, volume, and price values.

### Goal: Add product-specific metric cards

### Add components:
- Three cards for selected product
- Total Revenue, Total Volume, Average Price
- Updates when product selection changes

### Test before proceeding:
- Cards update with selection
- Values are correct for each product

---

## PHASE 13: Combination Chart

**Status:** Completed - dual-axis revenue & volume chart tied to the product selector.

### Goal: Add volume and revenue chart

### Add component:
- Dual-axis chart
- Bars for volume (light blue)
- Line for revenue (bright blue)
- Monthly data for selected product

### Test before proceeding:
- Both axes display correctly
- Chart updates with product selection

---

## PHASE 14: Market Share Gauge

**Status:** Completed - gauge shows each product's share of total portfolio revenue.

### Goal: Add final visualization

### Add component:
- Gauge showing product's share of total
- 0-100% range
- Blue color zones
- Updates with product selection

### Test before proceeding:
- Gauge displays correctly
- Percentage is accurate
- Responds to selection

---

## PHASE 15: Polish and Optimization

### Goal: Final refinements

### Add:
1. Data caching
2. Loading indicators (text-based)
3. Error handling
4. Consistent styling check
5. Performance optimization

### Test complete application:
- All features work together
- Performance is acceptable
- No visual inconsistencies

---

## Main Query for Revenue Data
```
MATCH (p:Product)
MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
MATCH (pd)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp2:TimePeriod)
WHERE tp.id = tp2.id
RETURN 
  p.name as Product,
  tp.year as Year,
  tp.month as Month,
  tp.quarter as Quarter,
  pd.price as PricePerUnit,
  vd.volume as UnitsSold,
  pd.price * vd.volume as Revenue
ORDER BY Year, Month, Product
```

## Implementation Approach

Work through each phase sequentially. After completing each phase, test and approve before moving to the next. This ensures full control over every visual component added to the application.

## Technical Notes and Known Issues

### Streamlit HTML Parser Bug with Comments

**Issue**: When using `st.markdown()` with `unsafe_allow_html=True`, HTML content that contains:
- Indented HTML comments (e.g., `    <!-- Section Comment -->`)
- Followed by HTML tags on subsequent lines

Will be treated as fenced code blocks by Streamlit's Markdown parser, causing raw HTML to display instead of rendered content.

**Example of Problematic Code**:
```python
st.markdown(f"""
    <div style="...">
        <!-- Revenue Section -->
        <div style="...">
            <h3>Total Revenue</h3>
            <p>{value}</p>
        </div>
    </div>
""", unsafe_allow_html=True)
```

**Root Cause**: Streamlit's Markdown parser interprets the combination of indentation + HTML comments as the start of a fenced code block, escaping all subsequent HTML content.

**Solution**: Remove all HTML comments from `st.markdown()` content:
```python
st.markdown(f"""
    <div style="...">
        <div style="...">
            <h3>Total Revenue</h3>
            <p>{value}</p>
        </div>
    </div>
""", unsafe_allow_html=True)
```

**Best Practices for Complex HTML in Streamlit**:
1. Avoid HTML comments inside `st.markdown()` blocks
2. Use Python comments above the `st.markdown()` call for documentation
3. Keep HTML structure simple and avoid deep nesting when possible
4. Test HTML rendering frequently during development
5. Consider using Streamlit native components for complex layouts when HTML fails


### Phase 9 Notes (2025-09-23)
- Quarterly filters now use Streamlit `st.multiselect` components with shared session-state keys (see `pages/revenue_overview.py`).
- Timeline month selects remain on BaseWeb defaults; custom CSS overrides for select inputs were removed to restore correct rendering.
- Form control styling falls back to the previous palette; multiselect tag styling retained in styles.py.
- Timeline product filters now use a consolidated multiselect control on the Revenue Overview timeline page.
- Form control styling falls back to the previous palette; multiselect tag styling retained in styles.py.





