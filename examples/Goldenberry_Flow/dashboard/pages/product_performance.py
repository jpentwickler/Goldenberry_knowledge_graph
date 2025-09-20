"""
Product Performance Page
Phase 1: Basic page structure with title placeholder
"""

import streamlit as st
import sys
from pathlib import Path

# Add parent directory to path for styles import
sys.path.append(str(Path(__file__).parent.parent))
from styles import COLORS
from database import render_header_status_indicator

def render():
    """Render the Product Performance page"""

    # Page header with compact status indicator using flexbox layout
    status_indicator_html = render_header_status_indicator()

    # Full-width header with flexbox layout
    header_html = f"""
        <div style="display: flex;
                   justify-content: space-between;
                   align-items: center;
                   border-bottom: 2px solid {COLORS['borders']};
                   padding-bottom: 10px;
                   margin-bottom: 30px;
                   width: 100%;">
            <h2 style="margin: 0;
                      color: {COLORS['text_primary']};
                      font-size: 24px;
                      font-weight: 600;">
                Product Performance
            </h2>
            {status_indicator_html}
        </div>
    """

    st.markdown(header_html, unsafe_allow_html=True)

    # Placeholder content for Phase 1
    st.markdown(f"""
        <p style="color: {COLORS['text_secondary']};
                 font-size: 16px;">
            Product-specific analytics will be added in subsequent phases.
        </p>
    """, unsafe_allow_html=True)