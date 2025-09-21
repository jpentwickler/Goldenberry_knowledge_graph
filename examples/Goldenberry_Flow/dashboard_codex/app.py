"""Codex-crafted Goldenberry Flow dashboard."""

from __future__ import annotations

import sys
from pathlib import Path

import streamlit as st

# Support running via "streamlit run app.py" (no package context) and
# "python -m dashboard_codex.app" (package context).
if __package__ in (None, ""):
    package_root = Path(__file__).resolve().parent
    sys.path.insert(0, str(package_root.parent))
    from dashboard_codex.styles import COLORS, inject_app_css
    from dashboard_codex.pages import (
        executive_dashboard,
        product_performance,
        revenue_overview,
    )
else:  # pragma: no cover - handled when executed as a module
    from .styles import COLORS, inject_app_css
    from .pages import executive_dashboard, product_performance, revenue_overview

st.set_page_config(
    page_title="Goldenberry Flow Revenue Dashboard - Codex Edition",
    page_icon=None,
    layout="wide",
    initial_sidebar_state="collapsed",
)

inject_app_css(st)


def render_app_title() -> None:
    st.markdown(
        f"""
        <section style="background: linear-gradient(90deg, {COLORS['primary']}0F, {COLORS['primary_alt']}0A); padding: 1.5rem 4vw; margin: -1rem -4vw 1rem;">
            <div style="max-width: 1200px; margin: 0 auto;">
                <div style="display:flex; justify-content:space-between; align-items:center; flex-wrap:wrap; gap:1rem;">
                    <div>
                        <h1 style="margin:0; font-size:2.1rem; font-weight:600; color:{COLORS['text_primary']};">Goldenberry Flow Revenue Dashboard</h1>
                        <p style="margin:0.35rem 0 0; color:{COLORS['text_muted']}; font-size:0.98rem;">
                            Real-time visibility into revenue performance, product contribution, and data health.
                        </p>
                    </div>
                    <span style="font-size:0.85rem; color:{COLORS['text_muted']};">Codex Edition</span>
                </div>
            </div>
        </section>
        """,
        unsafe_allow_html=True,
    )


def main() -> None:
    render_app_title()

    tabs = st.tabs(
        [
            "Executive Dashboard",
            "Revenue Overview",
            "Product Performance",
        ]
    )

    with tabs[0]:
        executive_dashboard.render()
    with tabs[1]:
        revenue_overview.render()
    with tabs[2]:
        product_performance.render()


if __name__ == "__main__":
    main()
