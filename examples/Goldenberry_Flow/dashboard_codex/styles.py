"""
Styling toolkit for the Codex variant of the Goldenberry dashboard.
Tones down borders, embraces whitespace, and modernizes typography.
"""

from __future__ import annotations

from textwrap import dedent

COLORS = {
    "background": "#FFFFFF",
    "surface": "#F7F9FC",
    "surface_alt": "#FFFFFF",
    "border": "#D7E3F5",
    "border_strong": "#AAC4F6",
    "primary": "#1D4ED8",
    "primary_alt": "#1E40AF",
    "primary_tint": "#E4ECFF",
    "accent": "#90E0EF",
    "success": "#2E9C62",
    "warning": "#F97316",
    "text_primary": "#1F2937",
    "text_muted": "#6B7280",
}


def app_css() -> str:
    """Return the CSS stylesheet injected into the Streamlit app."""

    return dedent(
        f"""
        <style>
            :root {{
                --color-surface: {COLORS['surface']};
                --color-surface-alt: {COLORS['surface_alt']};
                --color-border: {COLORS['border']};
                --color-border-strong: {COLORS['border_strong']};
                --color-primary: {COLORS['primary']};
                --color-primary-alt: {COLORS['primary_alt']};
                --color-primary-tint: {COLORS['primary_tint']};
                --color-accent: {COLORS['accent']};
                --color-text: {COLORS['text_primary']};
                --color-text-muted: {COLORS['text_muted']};
                --color-success: {COLORS['success']};
            }}

            html, body, [class^="css"] {{
                font-family: "Inter", "Segoe UI", Roboto, sans-serif;
                color: var(--color-text);
                background-color: var(--color-surface-alt);
            }}

            .stApp {{
                background-color: var(--color-surface-alt);
            }}

            [data-testid="stSidebar"],
            [data-testid="stSidebarNav"],
            [data-testid="collapsedControl"],
            [data-testid="stToolbar"] > div:first-child {{
                display: none !important;
            }}

            .main .block-container {{
                padding: 1.5rem 4vw 3rem;
                max-width: 1200px;
            }}

            h1, h2, h3, h4 {{
                color: var(--color-text);
                letter-spacing: 0.01em;
            }}

            h1.page-title {{
                font-size: 2rem;
                font-weight: 600;
                margin-bottom: 0.25rem;
            }}

            .page-subtitle {{
                color: var(--color-text-muted);
                font-size: 0.95rem;
                margin-bottom: 1.5rem;
            }}

            .section-header {{
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin: 2.5rem 0 1.25rem;
            }}

            .section-title {{
                font-size: 1.35rem;
                font-weight: 600;
                margin: 0;
            }}

            .section-divider {{
                border: none;
                height: 1px;
                background: linear-gradient(90deg, rgba(29,78,216,0.25), rgba(29,78,216,0));
                margin: 0 0 1.25rem;
            }}

            /* Navigation */
            .stTabs [data-baseweb="tab-list"] {{
                gap: 0.5rem;
                padding: 0;
                border-bottom: 1px solid var(--color-border);
                background-color: transparent;
                justify-content: flex-start;
            }}

            .stTabs [data-baseweb="tab"] {{
                border-radius: 999px 999px 0 0;
                padding: 0.65rem 1.4rem;
                margin-bottom: -1px;
                font-weight: 600;
                color: var(--color-text-muted);
                transition: background-color 0.2s ease, color 0.2s ease;
            }}

            .stTabs [data-baseweb="tab"]:hover {{
                background-color: var(--color-primary-tint);
                color: var(--color-primary-alt);
            }}

            .stTabs [data-baseweb="tab"][aria-selected="true"] {{
                background-color: var(--color-primary);
                color: white !important;
                border-bottom: 1px solid transparent;
                box-shadow: 0 10px 30px rgba(29, 78, 216, 0.15);
            }}

            .stTabs [data-baseweb="tab-panel"] {{
                padding-top: 1.5rem;
            }}

            /* Metric grid */
            .metric-grid {{
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
                gap: 1rem;
            }}

            .metric-card {{
                background: var(--color-surface);
                border: 1px solid var(--color-border);
                border-radius: 16px;
                padding: 1.1rem 1.25rem;
                box-shadow: 0 10px 30px rgba(15, 23, 42, 0.05);
            }}

            .metric-card .label {{
                text-transform: uppercase;
                font-size: 0.7rem;
                letter-spacing: 0.08em;
                color: var(--color-text-muted);
                margin-bottom: 0.35rem;
            }}

            .metric-card .value {{
                font-size: 1.9rem;
                font-weight: 700;
            }}

            .metric-card small {{
                display: block;
                margin-top: 0.35rem;
                color: var(--color-text-muted);
                font-size: 0.75rem;
            }}

            .status-pill {{
                display: inline-flex;
                align-items: center;
                gap: 0.5rem;
                padding: 0.4rem 0.85rem;
                border-radius: 999px;
                font-size: 0.85rem;
                font-weight: 600;
                border: 1px solid var(--color-border);
                background-color: var(--color-primary-tint);
                color: var(--color-primary-alt);
            }}

            .status-pill[data-status="error"] {{
                background-color: rgba(239, 68, 68, 0.08);
                border-color: rgba(239, 68, 68, 0.35);
                color: #B91C1C;
            }}

            .product-grid {{
                display: grid;
                grid-template-columns: repeat(auto-fit, minmax(245px, 1fr));
                gap: 1.2rem;
            }}

            .product-card {{
                background: var(--color-surface);
                border-radius: 18px;
                border: 1px solid var(--color-border);
                padding: 1.25rem 1.35rem;
                box-shadow: 0 15px 35px rgba(15, 23, 42, 0.04);
                display: flex;
                flex-direction: column;
                gap: 0.9rem;
            }}

            .product-card h3 {{
                margin: 0;
                font-size: 1.2rem;
                color: var(--color-primary-alt);
            }}

            .product-stat {{
                display: flex;
                justify-content: space-between;
                align-items: center;
                padding: 0.55rem 0;
                border-bottom: 1px solid rgba(148, 163, 184, 0.2);
                font-size: 0.95rem;
                color: var(--color-text-muted);
            }}

            .product-stat:last-of-type {{
                border-bottom: none;
            }}

            .product-stat span.value {{
                font-weight: 600;
                color: var(--color-text);
            }}

            .empty-state {{
                background-color: var(--color-surface);
                border: 1px dashed var(--color-border);
                padding: 1.25rem;
                border-radius: 12px;
                text-align: center;
                color: var(--color-text-muted);
            }}
        </style>
        """
    )


def inject_app_css(st_module) -> None:
    """Write the CSS to the page once."""

    st_module.markdown(app_css(), unsafe_allow_html=True)


