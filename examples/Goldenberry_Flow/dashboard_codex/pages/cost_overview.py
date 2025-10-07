from __future__ import annotations

from typing import Dict, List, Optional, Tuple

import pandas as pd
import plotly.express as px
import streamlit as st

from ..database import get_connection
from ..database.connection import Neo4jConnection
from ..styles import COLORS
from .components import render_empty_state, render_page_header


PRODUCT_DISPLAY_NAMES = {
    "Goldenberries (Physalis)": "Goldenberries",
    "Pitahaya (Dragon Fruit)": "Pitahaya",
    "Exotic Fruits Mix": "Exotic Fruits Mix",
}

PRODUCT_ORDER = [
    "Goldenberries (Physalis)",
    "Pitahaya (Dragon Fruit)",
    "Exotic Fruits Mix",
]

PRODUCT_COLORS = {
    "Goldenberries": COLORS["primary"],
    "Pitahaya": COLORS["primary_alt"],
    "Exotic Fruits Mix": COLORS["accent"],
}

def render() -> None:
    """Render the Cost Overview page."""

    connection = get_connection()
    cost_df = _load_variable_costs(connection)

    render_page_header(
        title="Cost Overview",
        description="Track spending patterns and identify cost optimization opportunities.",
    )

    _render_timeline_section(cost_df)


def _load_variable_costs(connection: Neo4jConnection) -> pd.DataFrame:
    records = connection.get_variable_cost_timeseries()
    if not records:
        return pd.DataFrame(columns=["product", "category", "year", "month", "cost"])

    df = pd.DataFrame(records)
    df["display_name"] = df["product"].map(PRODUCT_DISPLAY_NAMES).fillna(df["product"])
    df["date"] = pd.to_datetime(dict(year=df["year"].astype(int), month=df["month"].astype(int), day=1))
    df = df.sort_values("date").reset_index(drop=True)
    return df


def _build_month_options(df: pd.DataFrame) -> List[Tuple[int, int, str]]:
    unique = df[["date"]].drop_duplicates().sort_values("date")
    return [(row.date.year, row.date.month, row.date.strftime("%b %Y")) for row in unique.itertuples()]


def _render_timeline_section(df: pd.DataFrame) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Cost Timeline</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    if df.empty:
        render_empty_state("Cost timeline data is not available yet.")
        return

    month_options = _build_month_options(df)
    if not month_options:
        render_empty_state("No monthly cost records found.")
        return

    all_products = [name for name in PRODUCT_ORDER if name in df["product"].unique()]
    all_products = all_products or list(PRODUCT_ORDER)

    col_start, col_end = st.columns(2)
    start_option = col_start.selectbox(
        "Start month",
        month_options,
        index=0,
        format_func=lambda opt: opt[2],
    )
    end_option = col_end.selectbox(
        "End month",
        month_options,
        index=len(month_options) - 1,
        format_func=lambda opt: opt[2],
    )

    product_key = "cost-timeline-products"

    if product_key not in st.session_state:
        st.session_state[product_key] = all_products
    else:
        existing_products = [prod for prod in st.session_state[product_key] if prod in all_products]
        st.session_state[product_key] = existing_products or all_products

    selected_products = st.multiselect(
        "Products",
        options=all_products,
        default=st.session_state.get(product_key, all_products),
        key=product_key,
        format_func=lambda raw: PRODUCT_DISPLAY_NAMES.get(raw, raw),
    )

    start_year, start_month = start_option[:2]
    end_year, end_month = end_option[:2]

    start_date = pd.Timestamp(year=start_year, month=start_month, day=1)
    end_date = pd.Timestamp(year=end_year, month=end_month, day=1)

    if start_date > end_date:
        start_date, end_date = end_date, start_date

    filtered_df = df[(df["date"] >= start_date) & (df["date"] <= end_date)]

    if selected_products:
        filtered_df = filtered_df[filtered_df["product"].isin(selected_products)]

    if filtered_df.empty:
        render_empty_state("No cost data matches the selected filters yet.")
        return

    filtered_df["display_name"] = filtered_df["product"].map(PRODUCT_DISPLAY_NAMES).fillna(filtered_df["product"])
    filtered_df["label"] = filtered_df["date"].dt.strftime("%b %Y")

    summary_total = filtered_df["cost"].sum()
    month_count = filtered_df["date"].dt.to_period("M").nunique()
    selection_caption = (
        f"{month_count} month{'s' if month_count != 1 else ''} selected &middot; "
        f"Total cost <strong>${summary_total:,.0f}</strong>"
    )
    st.markdown(
        f"<p style='color:{COLORS['text_muted']}; margin-bottom:0.75rem;'>{selection_caption}</p>",
        unsafe_allow_html=True,
    )

    chart_df = (
        filtered_df.groupby(["date", "display_name"], as_index=False)["cost"].sum().sort_values("date")
    )

    if chart_df.empty:
        render_empty_state("No cost data available for charting.")
        return

    palette = {
        name: PRODUCT_COLORS.get(name, COLORS["primary"])
        for name in chart_df["display_name"].unique()
    }

    fig = px.line(
        chart_df,
        x="date",
        y="cost",
        color="display_name",
        color_discrete_map=palette,
        markers=True,
    )
    fig.update_traces(mode="lines+markers", line=dict(width=3), marker=dict(size=7))
    fig.update_layout(
        margin=dict(t=20, b=25, l=10, r=10),
        paper_bgcolor="#FFFFFF",
        plot_bgcolor="#FFFFFF",
        legend=dict(orientation="h", yanchor="bottom", y=-0.2, x=0.5, xanchor="center"),
        font=dict(color=COLORS["text_primary"], family="Inter, 'Segoe UI', sans-serif"),
        hovermode="x unified",
    )
    fig.update_xaxes(
        title="",
        tickformat="%b %Y",
        showgrid=True,
        gridcolor=COLORS["border"],
    )
    fig.update_yaxes(
        title="Cost (USD)",
        showgrid=True,
        gridcolor=COLORS["border"],
        zeroline=False,
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})

    summary = (
        filtered_df.groupby("display_name")["cost"].sum().sort_values(ascending=False)
    )
    summary_rows = "".join(
        f"<div style='display:flex; justify-content:space-between; color:{COLORS['text_primary']};'>"
        f"<span>{name}</span><span>${value:,.0f}</span></div>"
        for name, value in summary.items()
    )
    if summary_rows:
        summary_rows += (
            f"<div style='margin-top:8px; border-top:1px solid {COLORS['border']}; padding-top:8px; display:flex; justify-content:space-between; color:{COLORS['text_primary']};'>"
            f"<strong>Total</strong><strong>${summary_total:,.0f}</strong></div>"
        )
    empty_summary_html = summary_rows or (
        f"<span style=\"color:{COLORS['text_muted']};\">No cost values available.</span>"
    )
    container_html = (
        f"<div style=\"background-color:{COLORS['surface']}; border:1px solid {COLORS['border']}; "
        f"border-radius:12px; padding:16px; margin-top:12px;\">"
        f"<p style=\"margin:0 0 8px 0; color:{COLORS['text_muted']}; font-size:0.85rem;\">Variable cost by product</p>"
        f"{empty_summary_html}"
        "</div>"
    )
    st.markdown(container_html, unsafe_allow_html=True)

