# Goldenberry Flow Revenue Dashboard

## Current Status: Phase 4 - COMPLETED ✓

### Installation

1. Navigate to the dashboard directory:
```bash
cd examples/Goldenberry_Flow/dashboard
```

2. Install required dependencies:
```bash
pip install -r requirements.txt
```

### Running the Dashboard

Start the application using Anaconda Python:
```bash
"C:\Users\jprob\anaconda3\envs\base1\python.exe" -m streamlit run app.py
```

The dashboard will open in your default browser at `http://localhost:8501`

## Completed Phases

### Phase 1: Basic Navigation Structure - COMPLETED ✓
- Streamlit app with wide layout, NO sidebar
- Top navigation bar with three pages
- White background throughout
- Professional minimalistic appearance

### Phase 2: Database Connection - COMPLETED ✓
- Neo4j connection established (localhost:7687)
- Connection handler with error management
- Status indicator in header
- Test query showing product count

### Phase 3: First Metric Card - COMPLETED ✓
- Total Revenue card added to Executive Dashboard
- Light grey background (#F8F9FA) with blue border
- Currency formatting ($XXX,XXX.XX)
- Error handling implemented

### Phase 4: Complete Metric Row - COMPLETED ✓
✓ **Database Query Methods Added:**
- `get_total_revenue()` - Calculates total revenue: $2,338,874.55
- `get_total_volume()` - Sums all volume data: 348,591.57 kg
- `get_average_monthly_revenue()` - Average per month: $179,913.43
- `get_average_price_per_kg()` - Weighted average: $6.71/kg

✓ **Executive Dashboard Updates:**
- 4-column layout implemented (reduced from 6)
- Four metric cards in single horizontal row
- Equal spacing between cards
- Consistent styling across all cards

✓ **Metric Cards Implemented:**
1. **Total Revenue**: $2,338,874.55 (formatted as currency)
2. **Total Volume**: 348,591.57 kg (formatted with commas and kg suffix)
3. **Average Monthly Revenue**: $179,913.43 (formatted as currency)
4. **Average Price per KG**: $6.71/kg (formatted with /kg suffix)

## Next Phase: Phase 5 - Product Highlights Table

### Goal
Add product summary section below metric cards on Executive Dashboard

### Requirements
- Three-column layout below metrics
- One column per product (Goldenberries, Pitahaya, Exotic Fruits Mix)
- Display for each product:
  - Product name
  - Total Revenue
  - Total Volume
  - Average Price
- Blue headers with white background
- Clean table layout

### Implementation Plan
1. Add new database query method to get product-specific metrics
2. Create product highlights section below metric cards
3. Format values appropriately for each product
4. Ensure responsive layout

## Testing Checklist for Phase 4

✅ All four metric cards display in single row
✅ Equal spacing between cards
✅ Values are correctly calculated and verified against database
✅ Formatting matches requirements:
- Total Revenue: $2,338,874.55
- Total Volume: 348,591.57 kg
- Average Monthly Revenue: $179,913.43
- Average Price per KG: $6.71/kg
✅ Error handling works for each metric

## File Structure

```
dashboard/
├── app.py                    # Main application with navigation
├── styles.py                 # Centralized styling configuration
├── requirements.txt          # Python dependencies
├── README.md                # This file
└── pages/
    ├── executive_dashboard.py    # Executive Dashboard page
    ├── revenue_overview.py       # Revenue Overview page
    └── product_performance.py    # Product Performance page
```

## Color Palette Reference

- Background: `#FFFFFF` (pure white)
- Card backgrounds: `#F8F9FA` (light grey)
- Borders: `#0077B6` (blue)
- Text primary: `#212529` (dark grey/black)
- Text secondary: `#6C757D` (medium grey)
- Accent: `#90E0EF` (light blue for hover)