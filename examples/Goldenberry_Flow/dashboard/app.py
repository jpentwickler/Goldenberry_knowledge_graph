"""
Goldenberry Flow Revenue Dashboard
Main application with navigation
"""

import streamlit as st
import sys
from pathlib import Path

# Add pages directory to path
sys.path.append(str(Path(__file__).parent))

# Import styling
from styles import apply_custom_styling, COLORS

# Import pages
from pages import executive_dashboard, revenue_overview, product_performance

# Page configuration - must be first Streamlit command
st.set_page_config(
    page_title="Goldenberry Flow Revenue Dashboard",
    page_icon=None,  # No icons as per requirements
    layout="wide",
    initial_sidebar_state="collapsed"
)

# Apply custom styling
apply_custom_styling()

# Hide sidebar completely and aggressively reduce top page spacing
st.markdown("""
    <style>
        [data-testid="stSidebar"] {
            display: none;
        }

        /* Aggressively reduce top page spacing */
        .main .block-container {
            padding-top: 0.5rem !important;
            margin-top: 0 !important;
        }

        .stApp {
            margin-top: 0 !important;
            padding-top: 0 !important;
        }

        .stApp > header {
            height: 0 !important;
            display: none !important;
        }

        /* Remove any default top margins/padding */
        .element-container:first-child {
            margin-top: 0 !important;
            padding-top: 0 !important;
        }
    </style>
""", unsafe_allow_html=True)

def main():
    """Main application function with navigation"""

    # Create horizontal navigation with custom styling
    st.markdown(f"""
        <div style="background-color: {COLORS['background']};
                    padding: 5px 0;
                    border-bottom: 3px solid {COLORS['borders']};
                    margin-bottom: 30px;
                    margin-top: 0;">
            <h1 style="color: {COLORS['text_primary']};
                      text-align: center;
                      margin: 0;
                      font-size: 28px;
                      font-weight: 600;">
                Goldenberry Flow Revenue Dashboard
            </h1>
        </div>
    """, unsafe_allow_html=True)

    # Navigation using tabs - simpler approach
    tab1, tab2, tab3 = st.tabs(["Executive Dashboard", "Revenue Overview", "Product Performance"])

    # Style the tabs to match our design
    st.markdown("""
        <style>
            /* Full width tab container with responsive padding */
            .stTabs {
                width: 100%;
                margin: 0 auto;
                padding: 0 5%;
            }

            /* Tab container */
            .stTabs [data-baseweb="tab-list"] {
                gap: 0;
                background-color: #FFFFFF;
                border-bottom: 2px solid #0077B6;
                display: flex;
                justify-content: center;
            }

            /* Individual tabs */
            .stTabs [data-baseweb="tab"] {
                height: 50px;
                width: 300px;
                padding-left: 30px;
                padding-right: 30px;
                background-color: #FFFFFF;
                color: #0077B6;
                font-weight: 500;
                text-transform: uppercase;
                letter-spacing: 0.5px;
                font-size: 14px;
                border-radius: 0;
                border: none;
                border-bottom: 3px solid transparent;
                flex: 0 0 auto;
            }

            /* Active tab */
            .stTabs [data-baseweb="tab"][aria-selected="true"] {
                background-color: #023E8A;
                color: #FFFFFF !important;
                border-bottom: 3px solid #0077B6;
                font-weight: 600;
                text-shadow: 0 1px 2px rgba(0, 0, 0, 0.2);
            }

            /* Ensure text stays white in active tab */
            .stTabs [data-baseweb="tab"][aria-selected="true"] p {
                color: #FFFFFF !important;
            }

            /* Hover effect on non-active tabs */
            .stTabs [data-baseweb="tab"]:hover:not([aria-selected="true"]) {
                background-color: #0077B6;
                color: #FFFFFF;
                border-bottom: 3px solid #023E8A;
                transition: all 0.2s ease;
            }

            /* Remove tab highlight border */
            .stTabs [data-baseweb="tab-highlight"] {
                display: none;
            }

            /* Tab panel padding */
            .stTabs [data-baseweb="tab-panel"] {
                padding-top: 30px;
            }
        </style>
    """, unsafe_allow_html=True)

    # Render content in tabs
    with tab1:
        executive_dashboard.render()

    with tab2:
        revenue_overview.render()

    with tab3:
        product_performance.render()

if __name__ == "__main__":
    main()