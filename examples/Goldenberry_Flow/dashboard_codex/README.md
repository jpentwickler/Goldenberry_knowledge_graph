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

Next up: revenue timelines, deeper product analytics, and interactive
filters as outlined in the remaining project phases.


