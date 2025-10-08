# Goldenberry Flow Dashboard - Codex Edition

A refreshed implementation of the Goldenberry revenue dashboard featuring
improved visual polish, reusable components, and the same data
functionality as the original project.

## Getting Started

1. Navigate to this directory:
   ```bash
   cd examples/Goldenberry_Flow/dashboard_codex
   ```
2. Install dependencies (shared with the original dashboard):
   ```bash
   pip install -r ../dashboard/requirements.txt
   ```
3. Run the app:
   ```bash
   streamlit run app.py
   ```

By default the app connects to `neo4j://127.0.0.1:7687` using the
credentials provided via environment variables:

- `NEO4J_URI`
- `NEO4J_USERNAME`
- `NEO4J_PASSWORD`
- `NEO4J_DATABASE`

If the variables are not set the dashboard falls back to the same sample
configuration as the reference implementation.

## Highlights

- Cleaner tab navigation and hero header
- Reusable page header component with status indicator
- Consolidated metric card renderer with graceful error states
- Product performance grid and revenue-share donut chart driven by live Neo4j metrics
- Revenue overview timeline with interactive date and product filters
- Quarterly performance section with independent filters and summary preview
- Sanitised HTML output to prevent raw markup from leaking onto the page
- Modern colour palette and spacing for a calmer, more professional look

## Cost Extension Progress

- Phase 8 (Product Performance Cost Metrics) completed: cost structure cards with variable cost, gross profit, margin, and per-kg metrics.
- Phase 7 (Cost Structure Overview) completed: donut split and summary card for variable vs fixed totals on the Cost Overview page.
- Phase 5 (Fixed Cost Timeline Filters) completed: fixed-cost month range selector, three-category filter, and display-mode toggle.
- Phase 6 (Fixed Cost Timeline Chart) completed: monthly fixed-cost bar chart with stacked/grouped toggle and per-category metrics.
- Phase 3 (Cost Timeline Filters) completed: Cost Overview filters now constrain to month range and fruit selection only.
- Phase 4 (Cost Timeline Chart) completed: product procurement timeline with per-fruit lines and summary card based on `get_variable_cost_timeseries()`.
- Phase 2 (Cost Overview Page - Navigation Setup) live: added a fourth tab in `app.py`, wired `pages/cost_overview.py`, and reordered tabs so Cost Overview sits between Revenue and Product views.
- Phase 1 (Database Cost Query Methods) completed with new cost aggregation and timeseries helpers in `database/connection.py`.
- Restored the class-level `close()` housekeeping method so cached connections shut down cleanly.
- Validated the new methods against Neo4j using `C:/Users/jprob/anaconda3/envs/base1/python.exe phase1_cost_methods_test.py`.

Next up: revenue timelines, deeper product analytics, and interactive
filters as outlined in the remaining project phases.


