"""
Compact Database Status Indicator
Provides a unified status indicator for database connection and query testing
"""

import streamlit as st
from .connection import get_connection

def get_compact_database_status():
    """
    Get compact database status with unified connection and query testing

    Returns:
        dict: Contains status, icon, text, color, and tooltip information
    """
    try:
        # Get database connection
        db = get_connection()

        if not db.connected:
            return {
                "status": "error",
                "icon": "✗",
                "text": "Database Error",
                "color": "#E53E3E",
                "tooltip": f"Connection failed: {db.error_message}"
            }

        # Test query execution
        try:
            product_count = db.get_product_count()
            # If we get here, both connection and query work
            return {
                "status": "ready",
                "icon": "✓",
                "text": "Database Ready",
                "color": "#0077B6",
                "tooltip": f"Connected to Neo4j | {product_count} products found"
            }

        except Exception as query_error:
            return {
                "status": "error",
                "icon": "✗",
                "text": "Database Error",
                "color": "#E53E3E",
                "tooltip": f"Query failed: {str(query_error)}"
            }

    except Exception as e:
        return {
            "status": "error",
            "icon": "✗",
            "text": "Database Error",
            "color": "#E53E3E",
            "tooltip": f"Initialization error: {str(e)}"
        }

def render_compact_status_indicator():
    """
    Render the compact database status indicator as HTML

    Returns:
        str: HTML string for the status indicator
    """
    status_info = get_compact_database_status()
    rgb_color = _hex_to_rgb(status_info['color'])

    html = f"""<div class="compact-status-indicator" title="{status_info['tooltip']}" style="display: flex; align-items: center; gap: 8px; padding: 6px 12px; border-radius: 16px; background-color: rgba({rgb_color}, 0.1); border: 1px solid {status_info['color']}; font-size: 14px; font-weight: 500; white-space: nowrap;"><span style="color: {status_info['color']}; font-size: 16px; font-weight: bold; line-height: 1;">{status_info['icon']}</span><span style="color: {status_info['color']};">{status_info['text']}</span></div>"""

    return html

def _hex_to_rgb(hex_color):
    """Convert hex color to RGB values for rgba usage"""
    hex_color = hex_color.lstrip('#')
    return ','.join(str(int(hex_color[i:i+2], 16)) for i in (0, 2, 4))