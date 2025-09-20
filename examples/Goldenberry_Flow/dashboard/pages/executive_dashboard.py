"""
Executive Dashboard Page
Phase 2: Added database connection and test query
"""

import streamlit as st
import sys
from pathlib import Path

# Add parent directory to path for styles import
sys.path.append(str(Path(__file__).parent.parent))
from styles import COLORS
from database import get_connection, render_header_status_indicator

def render():
    """Render the Executive Dashboard page"""

    # Add responsive container with proper padding
    st.markdown("""
        <style>
            .main .block-container {
                padding-left: 5%;
                padding-right: 5%;
                max-width: none;
            }
        </style>
    """, unsafe_allow_html=True)

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
                Executive Dashboard
            </h2>
            {status_indicator_html}
        </div>
    """

    st.markdown(header_html, unsafe_allow_html=True)

    # Phase 3: Display metric cards
    _display_metric_cards()

    # Placeholder content for future phases
    st.markdown(f"""
        <p style="color: {COLORS['text_secondary']};
                 font-size: 16px;
                 margin-top: 40px;">
            Additional dashboard content will be added in subsequent phases.
        </p>
    """, unsafe_allow_html=True)


def _display_metric_cards():
    """Display metric cards in grid layout utilizing full width"""

    # Use 6-column layout for better width utilization
    col1, col2, col3, col4, col5, col6 = st.columns(6)

    with col1:
        _display_total_revenue_card()

    # Placeholder columns for future metric cards
    with col2:
        _display_placeholder_card("Revenue Growth", "Coming Soon")

    with col3:
        _display_placeholder_card("Top Product", "Coming Soon")

    with col4:
        _display_placeholder_card("Monthly Sales", "Coming Soon")

    with col5:
        _display_placeholder_card("Profit Margin", "Coming Soon")

    with col6:
        _display_placeholder_card("Customer Count", "Coming Soon")

def _display_total_revenue_card():
    """Display Total Revenue metric card"""

    try:
        # Get database connection and retrieve total revenue
        db = get_connection()
        total_revenue = db.get_total_revenue()

        # Format revenue as currency
        formatted_revenue = f"${total_revenue:,.2f}"

        # Display metric card
        st.markdown(f"""
            <div style="padding: 20px;
                       background-color: #F8F9FA;
                       border: 1px solid {COLORS['borders']};
                       border-radius: 8px;
                       margin-bottom: 20px;
                       text-align: center;">
                <h3 style="color: {COLORS['text_secondary']};
                         font-size: 14px;
                         font-weight: 500;
                         margin: 0 0 10px 0;
                         text-transform: uppercase;
                         letter-spacing: 0.5px;">
                    Total Revenue
                </h3>
                <p style="color: {COLORS['text_primary']};
                         font-size: 32px;
                         font-weight: 700;
                         margin: 0;
                         line-height: 1;">
                    {formatted_revenue}
                </p>
            </div>
        """, unsafe_allow_html=True)

    except Exception as e:
        # Error handling for metric card
        st.markdown(f"""
            <div style="padding: 20px;
                       background-color: #FFF5F5;
                       border: 1px solid #E53E3E;
                       border-radius: 8px;
                       margin-bottom: 20px;
                       text-align: center;">
                <h3 style="color: #E53E3E;
                         font-size: 14px;
                         font-weight: 500;
                         margin: 0 0 10px 0;
                         text-transform: uppercase;
                         letter-spacing: 0.5px;">
                    Total Revenue
                </h3>
                <p style="color: #E53E3E;
                         font-size: 16px;
                         font-weight: 500;
                         margin: 0;">
                    Error: {str(e)}
                </p>
            </div>
        """, unsafe_allow_html=True)

def _display_placeholder_card(title: str, value: str):
    """Display placeholder metric card for future implementation"""

    st.markdown(f"""
        <div style="padding: 20px;
                   background-color: #F8F9FA;
                   border: 1px solid {COLORS['borders']};
                   border-radius: 8px;
                   margin-bottom: 20px;
                   text-align: center;
                   opacity: 0.6;">
            <h3 style="color: {COLORS['text_secondary']};
                     font-size: 14px;
                     font-weight: 500;
                     margin: 0 0 10px 0;
                     text-transform: uppercase;
                     letter-spacing: 0.5px;">
                {title}
            </h3>
            <p style="color: {COLORS['text_secondary']};
                     font-size: 16px;
                     font-weight: 500;
                     margin: 0;
                     line-height: 1;">
                {value}
            </p>
        </div>
    """, unsafe_allow_html=True)