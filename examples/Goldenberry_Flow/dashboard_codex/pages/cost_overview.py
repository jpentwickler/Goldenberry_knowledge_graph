from __future__ import annotations

from typing import Dict, List, Tuple

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

FIXED_STRUCTURE_TO_CATEGORY = {
    "Export Operations Personnel": "Personnel",
    "Market Development": "Trade Shows",
    "Setup Costs": "One-time Setup",
}

FIXED_CATEGORY_ORDER = [
    "Personnel",
    "Trade Shows",
    "One-time Setup",
]

FIXED_CATEGORY_COLORS = {
    "Personnel": "#1E3A8A",
    "Trade Shows": "#6C63FF",
    "One-time Setup": "#FF6B6B",
}

STRUCTURE_COLORS = {
    "variable": "#6EA8FE",
    "fixed": "#7C6FCA",
}


def render() -> None:
    """Render the Cost Overview page."""

    connection = get_connection()
    variable_df = _load_variable_costs(connection)
    fixed_df = _load_fixed_costs(connection)
    totals = _load_cost_totals(connection)

    render_page_header(
        title="Cost Overview",
        description="Track spending patterns and identify cost optimization opportunities.",
    )

    _render_variable_timeline_section(variable_df)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)

    _render_fixed_cost_section(fixed_df)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)

    _render_cost_structure_section(totals)


def _load_variable_costs(connection: Neo4jConnection) -> pd.DataFrame:
    records = connection.get_variable_cost_timeseries()
    if not records:
        return pd.DataFrame(columns=["product", "display_name", "date", "cost"])

    df = pd.DataFrame(records)
    df["display_name"] = df["product"].map(PRODUCT_DISPLAY_NAMES).fillna(df["product"])
    df["date"] = pd.to_datetime(dict(year=df["year"].astype(int), month=df["month"].astype(int), day=1))
    df = df.sort_values("date").reset_index(drop=True)
    return df[["product", "display_name", "date", "cost"]]


def _load_fixed_costs(connection: Neo4jConnection) -> pd.DataFrame:
    records = connection.get_fixed_cost_timeseries()
    if not records:
        return pd.DataFrame(columns=["category", "display_name", "date", "cost"])

    df = pd.DataFrame(records)
    df["display_name"] = df["category"].map(FIXED_STRUCTURE_TO_CATEGORY)
    df = df.dropna(subset=["display_name"])
    df["date"] = pd.to_datetime(dict(year=df["year"].astype(int), month=df["month"].astype(int), day=1))
    df = df.sort_values("date").reset_index(drop=True)
    df["category"] = df["display_name"]
    return df[["category", "display_name", "date", "cost"]]


def _load_cost_totals(connection: Neo4jConnection) -> Dict[str, float]:
    totals = connection.get_cost_totals_by_behavior()
    return {
        "variable": float(totals.get("variable", 0.0)),
        "fixed": float(totals.get("fixed", 0.0)),
    }


def _build_month_options(df: pd.DataFrame) -> List[Tuple[int, int, str]]:
    unique = df[["date"]].drop_duplicates().sort_values("date")
    return [(row.date.year, row.date.month, row.date.strftime("%b %Y")) for row in unique.itertuples()]


def _render_variable_timeline_section(df: pd.DataFrame) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Variable Cost Timeline</h2>
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
        key="variable-start-month",
    )
    end_option = col_end.selectbox(
        "End month",
        month_options,
        index=len(month_options) - 1,
        format_func=lambda opt: opt[2],
        key="variable-end-month",
    )

    product_key = "cost-timeline-products"

    if product_key not in st.session_state:
        st.session_state[product_key] = all_products
    else:
        cleaned = [prod for prod in st.session_state[product_key] if prod in all_products]
        st.session_state[product_key] = cleaned or all_products

    selected_products = st.multiselect(
        "Products",
        options=all_products,
        default=None,
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

    summary_total = filtered_df["cost"].sum()
    month_count = filtered_df["date"].dt.to_period("M").nunique()
    selection_caption = (
        f"{month_count} month{'s' if month_count != 1 else ''} selected &middot; "
        f"Total cost <strong>${summary_total:,.0f}</strong>"
    )
    st.markdown(
        "<p style='color:{color}; margin-bottom:0.75rem;'>{caption}</p>".format(
            color=COLORS["text_muted"], caption=selection_caption
        ),
        unsafe_allow_html=True,
    )

    chart_df = (
        filtered_df.groupby(["date", "display_name"], as_index=False)["cost"].sum().sort_values("date")
    )

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

    summary_series = filtered_df.groupby("display_name")["cost"].sum().sort_values(ascending=False)
    if summary_series.empty:
        st.info("No cost values available.")
    else:
        columns = st.columns(len(summary_series) + 1)
        for col, (name, value) in zip(columns, summary_series.items()):
            col.metric(label=name, value="${:,.0f}".format(value))
        columns[-1].metric(label="Total Variable Cost", value="${:,.0f}".format(summary_total))


def _render_fixed_cost_section(df: pd.DataFrame) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Fixed Cost Timeline</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    if df.empty:
        render_empty_state("Fixed cost timeline data is not available yet.")
        return

    month_options = _build_month_options(df)
    if not month_options:
        render_empty_state("No monthly fixed cost records found.")
        return

    available_categories = [cat for cat in FIXED_CATEGORY_ORDER if cat in df["category"].unique()]
    available_categories = available_categories or list(FIXED_CATEGORY_ORDER)

    col_start, col_end = st.columns(2)
    start_option = col_start.selectbox(
        "Start month",
        month_options,
        index=0,
        format_func=lambda opt: opt[2],
        key="fixed-start-month",
    )
    end_option = col_end.selectbox(
        "End month",
        month_options,
        index=len(month_options) - 1,
        format_func=lambda opt: opt[2],
        key="fixed-end-month",
    )

    category_key = "fixed-timeline-categories"
    mode_key = "fixed-timeline-mode"

    if category_key not in st.session_state:
        st.session_state[category_key] = available_categories
    else:
        cleaned = [cat for cat in st.session_state[category_key] if cat in available_categories]
        st.session_state[category_key] = cleaned or available_categories

    selected_categories = st.multiselect(
        "Fixed cost categories",
        options=available_categories,
        default=None,
        key=category_key,
    )

    display_mode = st.radio(
        "Display mode",
        options=["Stacked", "Grouped"],
        horizontal=True,
        key=mode_key,
    )

    start_year, start_month = start_option[:2]
    end_year, end_month = end_option[:2]

    start_date = pd.Timestamp(year=start_year, month=start_month, day=1)
    end_date = pd.Timestamp(year=end_year, month=end_month, day=1)

    if start_date > end_date:
        start_date, end_date = end_date, start_date

    filtered_df = df[(df["date"] >= start_date) & (df["date"] <= end_date)]

    if selected_categories:
        filtered_df = filtered_df[filtered_df["category"].isin(selected_categories)]

    if filtered_df.empty:
        render_empty_state("No fixed cost data matches the selected filters yet.")
        return

    summary_total = filtered_df["cost"].sum()
    month_count = filtered_df["date"].dt.to_period("M").nunique()
    selection_caption = (
        f"{month_count} month{'s' if month_count != 1 else ''} selected &middot; "
        f"Total fixed cost <strong>${summary_total:,.0f}</strong>"
    )
    st.markdown(
        "<p style='color:{color}; margin-bottom:0.75rem;'>{caption}</p>".format(
            color=COLORS["text_muted"], caption=selection_caption
        ),
        unsafe_allow_html=True,
    )

    chart_df = (
        filtered_df.groupby(["date", "category"], as_index=False)["cost"].sum().sort_values("date")
    )

    palette = {
        name: FIXED_CATEGORY_COLORS.get(name, "#1E3A8A")
        for name in chart_df["category"].unique()
    }

    fig = px.bar(
        chart_df,
        x="date",
        y="cost",
        color="category",
        color_discrete_map=palette,
    )
    fig.update_traces(marker=dict(line=dict(width=0)))
    fig.update_layout(
        barmode="stack" if display_mode == "Stacked" else "group",
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

    summary_series = filtered_df.groupby("category")["cost"].sum().sort_values(ascending=False)
    if summary_series.empty:
        st.info("No fixed cost values available.")
    else:
        columns = st.columns(len(summary_series) + 1)
        for col, (name, value) in zip(columns, summary_series.items()):
            col.metric(label=name, value="${:,.0f}".format(value))
        columns[-1].metric(label="Total Fixed Cost", value="${:,.0f}".format(summary_total))


def _render_cost_structure_section(totals: Dict[str, float]) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Cost Structure</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    total_value = totals["variable"] + totals["fixed"]
    if total_value <= 0:
        render_empty_state("Cost totals are not available yet.")
        return

    chart_df = pd.DataFrame(
        [
            {"category": "Variable Costs", "value": totals["variable"]},
            {"category": "Fixed Costs", "value": totals["fixed"]},
        ]
    )

    fig = px.pie(
        chart_df,
        names="category",
        values="value",
        color="category",
        color_discrete_map={
            "Variable Costs": STRUCTURE_COLORS["variable"],
            "Fixed Costs": STRUCTURE_COLORS["fixed"],
        },
        hole=0.65,
    )
    fig.update_traces(textinfo="percent", hovertemplate="%{label}: $%{value:,.0f}<extra></extra>")
    fig.update_layout(
        margin=dict(t=10, b=10, l=10, r=10),
        showlegend=True,
        legend=dict(orientation="h", yanchor="bottom", y=-0.2, x=0.5, xanchor="center"),
        paper_bgcolor="#FFFFFF",
    )

    col_chart, col_summary = st.columns([2, 1])

    with col_chart:
        st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})

    summary_html = (
        "<div style='background-color:{surface}; border:1px solid {border}; border-radius:12px; padding:18px;'>"
        "<h3 style='margin:0 0 4px 0; color:{primary}; font-size:1.4rem;'>Total Costs</h3>"
        "<p style='margin:0 0 16px 0; color:{muted}; font-size:0.85rem;'>13-Month Period</p>"
        "<div style='font-size:2rem; font-weight:600; color:{primary}; margin-bottom:16px;'>${total:,.0f}</div>"
        "<div style='display:flex; gap:12px;'>"
        "<div style='flex:1; background-color:{surface_alt}; padding:12px; border-radius:10px; text-align:center;'>"
        "<div style='font-size:1.1rem; font-weight:600; color:{primary};'>${variable:,.0f}</div>"
        "<div style='font-size:0.85rem; color:{muted};'>Variable</div>"
        "</div>"
        "<div style='flex:1; background-color:{surface_alt}; padding:12px; border-radius:10px; text-align:center;'>"
        "<div style='font-size:1.1rem; font-weight:600; color:{primary};'>${fixed:,.0f}</div>"
        "<div style='font-size:0.85rem; color:{muted};'>Fixed</div>"
        "</div>"
        "</div>"
        "</div>"
    ).format(
        surface=COLORS["surface"],
        border=COLORS["border"],
        surface_alt="#F8FBFF",
        primary=COLORS["text_primary"],
        muted=COLORS["text_muted"],
        total=total_value,
        variable=totals["variable"],
        fixed=totals["fixed"],
    )

    with col_summary:
        st.markdown(summary_html, unsafe_allow_html=True)
