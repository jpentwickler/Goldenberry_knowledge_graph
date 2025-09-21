"""Reusable page-level components for the Codex dashboard."""

from __future__ import annotations

import sys
from pathlib import Path
from typing import Optional

import streamlit as st

if __package__ in (None, ""):
    package_root = Path(__file__).resolve().parents[1]
    sys.path.insert(0, str(package_root.parent))
    from dashboard_codex.database import render_status_pill
else:  # pragma: no cover - executed in package context
    from ..database import render_status_pill


def render_page_header(title: str, description: Optional[str] = None, *, show_status: bool = True) -> None:
    """Render a consistent page header block."""

    status_html = render_status_pill() if show_status else ""
    description_html = f"<p class='page-subtitle'>{description}</p>" if description else ""

    st.markdown(
        f"""
        <div style="display:flex; justify-content:space-between; align-items:flex-start; gap:1rem;">
            <div>
                <h1 class='page-title'>{title}</h1>
                {description_html}
            </div>
            <div style="flex-shrink:0;">{status_html}</div>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )
