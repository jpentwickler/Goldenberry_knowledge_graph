"""Product performance placeholder page."""

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
    """Render the product performance page placeholder."""

    render_page_header(
        "Product Performance",
        "Detailed product analytics, price ladders, and portfolio breakdowns will surface here.",
    )

    st.markdown(
        """
        <div class='empty-state'>
            Granular product insights, margin analysis, and benchmarking tools are in development.
        </div>
        """,
        unsafe_allow_html=True,
    )

    st.write("\n")
    st.caption("Stay tuned for the dedicated product analytics module.")


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()
