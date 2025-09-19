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

def render():
    """Render the Product Performance page"""

    # Page title with custom styling
    st.markdown(f"""
        <h2 style="color: {COLORS['text_primary']};
                  border-bottom: 2px solid {COLORS['borders']};
                  padding-bottom: 10px;
                  margin-bottom: 30px;">
            Product Performance
        </h2>
    """, unsafe_allow_html=True)

    # Placeholder content for Phase 1
    st.markdown(f"""
        <p style="color: {COLORS['text_secondary']};
                 font-size: 16px;">
            Product-specific analytics will be added in subsequent phases.
        </p>
    """, unsafe_allow_html=True)