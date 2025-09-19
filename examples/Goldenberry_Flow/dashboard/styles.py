"""
Goldenberry Flow Revenue Dashboard - Style Configuration
Centralized styling constants for consistent design across the application
"""

# Color Palette
COLORS = {
    # Backgrounds
    'background': '#FFFFFF',        # Pure white background
    'card_bg': '#F8F9FA',          # Light grey for cards

    # Lines and Borders
    'grid_lines': '#E0E0E0',       # Light grey grid lines
    'borders': '#0077B6',          # Blue borders

    # Product Colors (Blue Monochromatic)
    'goldenberries': '#0077B6',    # Deep blue
    'pitahaya': '#00B4D8',         # Bright blue
    'exotic_fruits': '#48CAE4',    # Medium blue

    # Text Colors
    'text_primary': '#212529',     # Dark grey/black
    'text_secondary': '#6C757D',   # Medium grey

    # Accent Colors
    'highlight': '#023E8A',        # Dark blue
    'accent': '#90E0EF',          # Light blue for hover/selection
}

# Custom CSS for Streamlit App
CUSTOM_CSS = """
<style>
    /* Main app background */
    .stApp {
        background-color: #FFFFFF;
    }

    /* Remove default Streamlit sidebar */
    section[data-testid="stSidebar"] {
        display: none;
    }

    /* Navigation button styling */
    .stButton > button {
        background-color: #FFFFFF;
        color: #0077B6;
        border: 2px solid #0077B6;
        border-radius: 0px;
        padding: 10px 24px;
        font-weight: 500;
        font-size: 14px;
        transition: all 0.2s ease;
        text-transform: uppercase;
        letter-spacing: 0.5px;
    }

    /* Primary (selected) navigation button */
    .stButton > button[kind="primary"] {
        background-color: #0077B6;
        color: #FFFFFF;
        border: 2px solid #0077B6;
    }

    /* Navigation button hover */
    .stButton > button:hover {
        background-color: #023E8A;
        color: #FFFFFF;
        border-color: #023E8A;
        transform: translateY(-1px);
        box-shadow: 0 4px 8px rgba(0, 119, 182, 0.2);
    }

    /* Navigation button active/focus */
    .stButton > button:active,
    .stButton > button:focus {
        background-color: #023E8A;
        color: #FFFFFF;
        border-color: #023E8A;
        box-shadow: none;
    }

    /* Remove Streamlit branding */
    .stDeployButton {
        display: none;
    }

    #MainMenu {
        visibility: hidden;
    }

    footer {
        visibility: hidden;
    }

    /* Card styling (for future use) */
    .metric-card {
        background-color: #F8F9FA;
        border: 1px solid #0077B6;
        border-radius: 8px;
        padding: 20px;
        margin: 10px;
    }

    /* Headers */
    h1, h2, h3 {
        color: #212529;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    }

    /* Paragraphs and body text */
    p, div, span {
        color: #212529;
    }

    /* Secondary text */
    .text-secondary {
        color: #6C757D;
    }
</style>
"""

def apply_custom_styling():
    """Apply custom CSS to the Streamlit app"""
    import streamlit as st
    st.markdown(CUSTOM_CSS, unsafe_allow_html=True)