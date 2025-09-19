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
from database import get_connection

def render():
    """Render the Executive Dashboard page"""

    # Page title with custom styling
    st.markdown(f"""
        <h2 style="color: {COLORS['text_primary']};
                  border-bottom: 2px solid {COLORS['borders']};
                  padding-bottom: 10px;
                  margin-bottom: 30px;">
            Executive Dashboard
        </h2>
    """, unsafe_allow_html=True)

    # Database connection status and test query
    _display_database_status()

    # Placeholder content for future phases
    st.markdown(f"""
        <p style="color: {COLORS['text_secondary']};
                 font-size: 16px;
                 margin-top: 40px;">
            Dashboard content will be added in subsequent phases.
        </p>
    """, unsafe_allow_html=True)

def _display_database_status():
    """Display database connection status and test query results"""

    try:
        # Get database connection
        db = get_connection()
        status = db.get_connection_status()

        if status["connected"]:
            # Connection successful - display status
            st.markdown(f"""
                <div style="padding: 15px;
                           background-color: {COLORS['card_bg']};
                           border-left: 3px solid {COLORS['borders']};
                           margin-bottom: 20px;">
                    <p style="color: {COLORS['text_primary']};
                             margin: 0;
                             font-weight: 500;">
                        Database Status: Connected to Neo4j
                    </p>
                    <p style="color: {COLORS['text_secondary']};
                             margin: 5px 0 0 0;
                             font-size: 14px;">
                        URI: {status["database_uri"]} | Database: {status["database_name"]}
                    </p>
                </div>
            """, unsafe_allow_html=True)

            # Execute test query - get product count
            try:
                product_count = db.get_product_count()
                st.markdown(f"""
                    <div style="padding: 15px;
                               background-color: {COLORS['card_bg']};
                               border-left: 3px solid {COLORS['borders']};
                               margin-bottom: 20px;">
                        <p style="color: {COLORS['text_primary']};
                                 margin: 0;
                                 font-weight: 500;">
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
                               margin-bottom: 20px;">
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
            # Connection failed - display error
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