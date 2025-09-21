"""Revenue overview placeholder page."""

from __future__ import annotations

import sys
from pathlib import Path

import streamlit as st

if __package__ in (None, ""):
    package_root = Path(__file__).resolve().parents[1]
    sys.path.insert(0, str(package_root.parent))
    from dashboard_codex.pages.components import render_page_header
else:  # pragma: no cover - executed in package context
    from .components import render_page_header


def render() -> None:
    """Render the revenue overview page placeholder."""

    render_page_header(
        "Revenue Overview",
        "Timeline, cohorts, and quarterly comparisons will live here.",
    )

    st.markdown(
        """
        <div class='empty-state'>
            <strong>Coming soon:</strong> interactive revenue timelines, filters, and comparative breakdowns.
        </div>
        """,
        unsafe_allow_html=True,
    )

    st.write("\n")
    col1, col2 = st.columns(2)
    with col1:
        st.metric("Latest Quarter", "$0.00", delta="Awaiting data")
    with col2:
        st.metric("Quarter-over-Quarter", "0%", delta=None)

    st.caption("Phase 6 will introduce the first revenue visualization.")


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()
