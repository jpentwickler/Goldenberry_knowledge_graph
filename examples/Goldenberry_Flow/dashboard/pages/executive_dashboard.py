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
from database import get_connection, render_compact_status_indicator

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
                Executive Dashboard
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

def _display_database_status():
    """Display database connection status and test query results in horizontal layout"""

    try:
        # Get database connection
        db = get_connection()
        status = db.get_connection_status()

        if status["connected"]:
            # Create horizontal layout for status information
            col1, col2 = st.columns(2)

            with col1:
                # Connection status
                st.markdown(f"""
                    <div style="padding: 15px;
                               background-color: {COLORS['card_bg']};
                               border-left: 3px solid {COLORS['borders']};
                               margin-bottom: 20px;
                               height: 80px;
                               display: flex;
                               flex-direction: column;
                               justify-content: center;">
                        <p style="color: {COLORS['text_primary']};
                                 margin: 0;
                                 font-weight: 500;
                                 font-size: 16px;">
                            Database Status: Connected to Neo4j
                        </p>
                        <p style="color: {COLORS['text_secondary']};
                                 margin: 5px 0 0 0;
                                 font-size: 14px;">
                            URI: {status["database_uri"]} | Database: {status["database_name"]}
                        </p>
                    </div>
                """, unsafe_allow_html=True)

            with col2:
                # Execute test query - get product count
                try:
                    product_count = db.get_product_count()
                    st.markdown(f"""
                        <div style="padding: 15px;
                                   background-color: {COLORS['card_bg']};
                                   border-left: 3px solid {COLORS['borders']};
                                   margin-bottom: 20px;
                                   height: 80px;
                                   display: flex;
                                   flex-direction: column;
                                   justify-content: center;">
                            <p style="color: {COLORS['text_primary']};
                                     margin: 0;
                                     font-weight: 500;
                                     font-size: 16px;">
                                Products in Database: {product_count}
                            </p>
                            <p style="color: {COLORS['text_secondary']};
                                     margin: 5px 0 0 0;
                                     font-size: 14px;">
                                Test query executed successfully
                            </p>
                        </div>
                    """, unsafe_allow_html=True)

                except Exception as query_error:
                    st.markdown(f"""
                        <div style="padding: 15px;
                                   background-color: #FFF5F5;
                                   border-left: 3px solid #E53E3E;
                                   margin-bottom: 20px;
                                   height: 80px;
                                   display: flex;
                                   flex-direction: column;
                                   justify-content: center;">
                            <p style="color: #E53E3E;
                                     margin: 0;
                                     font-weight: 500;">
                                Query Error: Failed to retrieve product count
                            </p>
                            <p style="color: #A0AEC0;
                                     margin: 5px 0 0 0;
                                     font-size: 14px;">
                                {str(query_error)}
                            </p>
                        </div>
                    """, unsafe_allow_html=True)

        else:
            # Connection failed - display error in full width
            st.markdown(f"""
                <div style="padding: 15px;
                           background-color: #FFF5F5;
                           border-left: 3px solid #E53E3E;
                           margin-bottom: 20px;">
                    <p style="color: #E53E3E;
                             margin: 0;
                             font-weight: 500;">
                        Database Status: Connection Failed
                    </p>
                    <p style="color: #A0AEC0;
                             margin: 5px 0 0 0;
                             font-size: 14px;">
                        {status["error_message"]}
                    </p>
                </div>
            """, unsafe_allow_html=True)

    except Exception as e:
        # General error handling
        st.markdown(f"""
            <div style="padding: 15px;
                       background-color: #FFF5F5;
                       border-left: 3px solid #E53E3E;
                       margin-bottom: 20px;">
                <p style="color: #E53E3E;
                         margin: 0;
                         font-weight: 500;">
                    Database Error: Unable to initialize connection
                </p>
                <p style="color: #A0AEC0;
                         margin: 5px 0 0 0;
                         font-size: 14px;">
                    {str(e)}
                </p>
            </div>
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