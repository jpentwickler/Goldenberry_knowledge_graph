"""
Revenue Overview Page
Phase 1: Basic page structure with title placeholder
"""

import streamlit as st
import sys
from pathlib import Path

# Add parent directory to path for styles import
sys.path.append(str(Path(__file__).parent.parent))
from styles import COLORS

def render():
    """Render the Revenue Overview page"""

    # Page title with custom styling
    st.markdown(f"""
        <h2 style="color: {COLORS['text_primary']};
                  border-bottom: 2px solid {COLORS['borders']};
                  padding-bottom: 10px;
                  margin-bottom: 30px;">
            Revenue Overview
        </h2>
    """, unsafe_allow_html=True)

    # Placeholder content for Phase 1
    st.markdown(f"""
        <p style="color: {COLORS['text_secondary']};
                 font-size: 16px;">
            Revenue timeline and quarterly performance sections will be added in subsequent phases.
        </p>
    """, unsafe_allow_html=True)

    # Note about future sections
    st.markdown(f"""
        <div style="margin-top: 40px;
                   padding: 15px;
                   background-color: {COLORS['card_bg']};
                   border-left: 3px solid {COLORS['borders']};">
            <p style="color: {COLORS['text_primary']};
                     margin: 0;
                     font-weight: 500;">
                Planned Sections:
            </p>
            <ul style="color: {COLORS['text_secondary']}; margin-top: 10px;">
                <li>Timeline Chart with filters</li>
                <li>Quarterly Performance with independent filters</li>
            </ul>
        </div>
    """, unsafe_allow_html=True)