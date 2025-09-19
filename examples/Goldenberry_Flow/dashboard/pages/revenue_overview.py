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
from database import render_compact_status_indicator

def render():
    """Render the Revenue Overview page"""

    # Page header with compact status indicator using flexbox layout
    from database.status_indicator import get_compact_database_status
    status_info = get_compact_database_status()

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
                Revenue Overview
            </h2>
            <div style="display: inline-flex;
                       align-items: center;
                       gap: 6px;
                       padding: 4px 8px;
                       border-radius: 12px;
                       background-color: rgba(0,119,182,0.1);
                       border: 1px solid {status_info["color"]};
                       font-size: 13px;
                       font-weight: 500;
                       white-space: nowrap;
                       margin-right: 40px;"
                 title="{status_info["tooltip"]}">
                <span style="color: {status_info["color"]};
                           font-size: 14px;
                           font-weight: bold;">
                    {status_info["icon"]}
                </span>
                <span style="color: {status_info["color"]};">
                    {status_info["text"]}
                </span>
            </div>
        </div>
    """

    st.markdown(header_html, unsafe_allow_html=True)

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