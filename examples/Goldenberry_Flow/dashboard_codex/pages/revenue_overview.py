"""Revenue Overview page with timeline and quarterly filters."""

from __future__ import annotations

import calendar
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, List, Tuple

import pandas as pd
import plotly.express as px
import streamlit as st

if __package__ in (None, ""):
    package_root = Path(__file__).resolve().parents[1]
    sys.path.insert(0, str(package_root.parent))
    from dashboard_codex.database import get_connection
    from dashboard_codex.pages.components import render_page_header
    from dashboard_codex.styles import COLORS
else:  # pragma: no cover - executed in package context
    from ..database import get_connection
    from ..styles import COLORS
    from .components import render_page_header

PRODUCT_LABELS: Dict[str, str] = {
    "Goldenberries (Physalis)": "Goldenberries",
    "Pitahaya (Dragon Fruit)": "Pitahaya",
    "Exotic Fruits Mix": "Exotic Fruits Mix",
}

PRODUCT_PALETTE: Dict[str, str] = {
    "Goldenberries": COLORS["primary"],
    "Pitahaya": COLORS["primary_alt"],
    "Exotic Fruits Mix": COLORS["accent"],
}


@dataclass(frozen=True)
class MonthOption:
    year: int
    month: int

    @property
    def label(self) -> str:
        return f"{calendar.month_name[self.month]} {self.year}"

    @property
    def sort_key(self) -> Tuple[int, int]:
        return self.year, self.month


@dataclass(frozen=True)
class QuarterOption:
    year: int
    quarter: int

    @property
    def label(self) -> str:
        return f"Q{self.quarter} {self.year}"

    @property
    def sort_key(self) -> Tuple[int, int]:
        return self.year, self.quarter



def render() -> None:
    """Render the Revenue Overview page."""

    connection = get_connection()
    timeline_df = _load_timeline_dataframe(connection)
    quarter_df = _load_quarterly_dataframe(connection)

    render_page_header(
        "Revenue Overview",
        "Interactive filters highlight how revenue evolves across months and products.",
    )
    _render_timeline_section(timeline_df)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    _render_quarterly_section(quarter_df)


def _load_timeline_dataframe(connection) -> pd.DataFrame:
    records = connection.get_revenue_timeseries()
    if not records:
        return pd.DataFrame(columns=["product", "display_name", "date", "revenue"])

    df = pd.DataFrame(records)
    df["date"] = pd.to_datetime(dict(year=df["year"].astype(int), month=df["month"].astype(int), day=1))
    df["display_name"] = df["product"].map(PRODUCT_LABELS).fillna(df["product"])
    df = df.sort_values("date").reset_index(drop=True)
    return df[["product", "display_name", "date", "revenue"]]


def _load_quarterly_dataframe(connection) -> pd.DataFrame:
    records = connection.get_quarterly_revenue()
    if not records:
        return pd.DataFrame(columns=["product", "display_name", "year", "quarter", "revenue"])

    df = pd.DataFrame(records)
    df["display_name"] = df["product"].map(PRODUCT_LABELS).fillna(df["product"])
    df = df.sort_values(["year", "quarter"]).reset_index(drop=True)
    return df[["product", "display_name", "year", "quarter", "revenue"]]


def _build_month_options(df: pd.DataFrame) -> List[MonthOption]:
    unique = df[["date"]].drop_duplicates().sort_values("date")
    return [MonthOption(row.date.year, row.date.month) for row in unique.itertuples()]  # type: ignore[attr-defined]


def _build_quarter_options(df: pd.DataFrame) -> List[QuarterOption]:
    unique = df[["year", "quarter"]].drop_duplicates().sort_values(["year", "quarter"])
    return [QuarterOption(int(row.year), int(row.quarter)) for row in unique.itertuples()]  # type: ignore[attr-defined]




def _render_timeline_section(df: pd.DataFrame) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Timeline Chart</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    if df.empty:
        st.markdown(
            "<div class='empty-state'>Revenue timeline data is not available yet.</div>",
            unsafe_allow_html=True,
        )
        return

    month_options = _build_month_options(df)
    if not month_options:
        st.markdown(
            "<div class='empty-state'>No monthly revenue records found.</div>",
            unsafe_allow_html=True,
        )
        return

    option_to_order = {option: idx for idx, option in enumerate(month_options)}

    col_start, col_end = st.columns(2)
    start_option = col_start.selectbox(
        "Start month",
        month_options,
        index=0,
        format_func=lambda opt: opt.label,
    )
    end_option = col_end.selectbox(
        "End month",
        month_options,
        index=len(month_options) - 1,
        format_func=lambda opt: opt.label,
    )

    product_filter_key = "timeline-product-filter"
    all_products = list(PRODUCT_LABELS.keys())
    current_selection = st.session_state.get(product_filter_key)
    if current_selection is None:
        st.session_state[product_filter_key] = all_products
    else:
        filtered_selection = [
            product for product in current_selection if product in PRODUCT_LABELS
        ]
        if filtered_selection:
            st.session_state[product_filter_key] = filtered_selection
        elif current_selection:
            st.session_state[product_filter_key] = all_products
        else:
            st.session_state[product_filter_key] = []

    selected_product_options = st.multiselect(
        "Products",
        options=all_products,
        format_func=lambda raw: PRODUCT_LABELS.get(raw, raw),
        key=product_filter_key,
    )
    selected_products = list(selected_product_options)

    if not selected_products:
        st.warning("Select at least one product to view the revenue timeline.")
        return

    if option_to_order[end_option] < option_to_order[start_option]:
        st.warning("The end month must be later than or equal to the start month.")
        return

    start_date = pd.Timestamp(start_option.year, start_option.month, 1)
    end_date = pd.Timestamp(end_option.year, end_option.month, 1)

    filtered = df[
        (df["date"] >= start_date)
        & (df["date"] <= end_date)
        & (df["product"].isin(selected_products))
    ].copy()

    if filtered.empty:
        st.markdown(
            "<div class='empty-state'>No revenue recorded for the selected combination.</div>",
            unsafe_allow_html=True,
        )
        return

    filtered["label"] = filtered["date"].dt.strftime("%b %Y")
    filtered["display_name"] = filtered["product"].map(PRODUCT_LABELS).fillna(filtered["product"])

    summary_total = filtered["revenue"].sum()
    month_count = filtered["date"].dt.to_period("M").nunique()
    selection_caption = (
        f"{month_count} month{'s' if month_count != 1 else ''} selected &middot; "
        f"Total revenue <strong>${summary_total:,.0f}</strong>"
    )
    st.markdown(
        f"<p style='color:{COLORS['text_muted']}; margin-bottom:0.75rem;'>{selection_caption}</p>",
        unsafe_allow_html=True,
    )

    chart_df = (
        filtered.groupby(["date", "display_name"], as_index=False)["revenue"].sum().sort_values("date")
    )

    fig = px.line(
        chart_df,
        x="date",
        y="revenue",
        color="display_name",
        color_discrete_map=PRODUCT_PALETTE,
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
        title="Revenue (USD)",
        showgrid=True,
        gridcolor=COLORS["border"],
        zeroline=False,
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})

    summary = (
        filtered.groupby("display_name")["revenue"].sum().sort_values(ascending=False)
    )
    summary_rows = "".join(
        f"<div style='display:flex; justify-content:space-between; color:{COLORS['text_primary']};'>"
        f"<span>{name}</span><span>${value:,.0f}</span></div>"
        for name, value in summary.items()
    )
    empty_summary_html = summary_rows or (
        f"<span style=\"color:{COLORS['text_muted']};\">No revenue values available.</span>"
    )
    container_html = (
        f"<div style=\"background-color:{COLORS['surface']}; border:1px solid {COLORS['border']}; "
        f"border-radius:12px; padding:16px; margin-top:12px;\">"
        f"<p style=\"margin:0 0 8px 0; color:{COLORS['text_muted']}; font-size:0.85rem;\">Revenue by product</p>"
        f"{empty_summary_html}"
        "</div>"
    )
    st.markdown(container_html, unsafe_allow_html=True)


def _render_quarterly_section(df: pd.DataFrame) -> None:
    st.markdown(
        """
        <div class="section-header" style="margin-top: 3rem;">
            <h2 class="section-title">Quarterly Performance</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    if df.empty:
        st.markdown(
            "<div class='empty-state'>Quarterly revenue data is not available yet.</div>",
            unsafe_allow_html=True,
        )
        return

    quarter_options = _build_quarter_options(df)
    if not quarter_options:
        st.markdown(
            "<div class='empty-state'>No quarterly revenue records found.</div>",
            unsafe_allow_html=True,
        )
        return

    quarter_filter_key = "quarter-filter-selection"
    known_quarters_key = "quarter-filter-known"
    current_quarter_selection = st.session_state.get(quarter_filter_key)
    known_quarter_ids = set(st.session_state.get(known_quarters_key, []))
    if current_quarter_selection is None:
        st.session_state[quarter_filter_key] = quarter_options
        current_quarter_selection = quarter_options
    else:
        valid_quarters = [
            option for option in current_quarter_selection if option in quarter_options
        ]
        auto_selected = [
            option
            for option in quarter_options
            if (option.year, option.quarter) not in known_quarter_ids
        ]
        combined_quarters = valid_quarters + [
            option for option in auto_selected if option not in valid_quarters
        ]
        if combined_quarters != current_quarter_selection:
            st.session_state[quarter_filter_key] = combined_quarters
            current_quarter_selection = combined_quarters
    st.session_state[known_quarters_key] = [
        (option.year, option.quarter) for option in quarter_options
    ]

    product_filter_key = "quarter-product-filter"
    product_known_key = "quarter-product-known"
    all_products = list(PRODUCT_LABELS.keys())
    current_product_selection = st.session_state.get(product_filter_key)
    known_products = set(st.session_state.get(product_known_key, []))
    if current_product_selection is None:
        st.session_state[product_filter_key] = all_products
        current_product_selection = all_products
    else:
        valid_products = [
            product for product in current_product_selection if product in PRODUCT_LABELS
        ]
        new_products = [
            product for product in all_products if product not in known_products
        ]
        combined_products = valid_products + [
            product for product in new_products if product not in valid_products
        ]
        if combined_products != current_product_selection:
            st.session_state[product_filter_key] = combined_products
            current_product_selection = combined_products
    st.session_state[product_known_key] = all_products

    filter_columns = st.columns([0.55, 0.45])
    with filter_columns[0]:
        selected_quarter_options = st.multiselect(
            "Quarters",
            options=quarter_options,
            format_func=lambda option: option.label,
            key=quarter_filter_key,
            placeholder="Select quarters",
        )
    with filter_columns[1]:
        selected_product_options = st.multiselect(
            "Products",
            options=all_products,
            format_func=lambda raw: PRODUCT_LABELS.get(raw, raw),
            key=product_filter_key,
            placeholder="Select products",
        )

    if not selected_quarter_options:
        st.warning("Select at least one quarter to review performance.")
        return

    selected_quarters = {
        (option.year, option.quarter) for option in selected_quarter_options
    }

    if not selected_product_options:
        st.warning("Choose at least one product to display quarterly performance.")
        return

    selected_products = list(selected_product_options)

    display_modes = ("Stacked", "Grouped")
    display_mode_key = "quarter-display-mode"
    if display_mode_key not in st.session_state:
        st.session_state[display_mode_key] = display_modes[0]
    display_mode = st.radio(
        "Bar display",
        options=display_modes,
        horizontal=True,
        key=display_mode_key,
    )

    filtered = df[
        df["product"].isin(selected_products)
        & df.apply(lambda row: (int(row["year"]), int(row["quarter"])) in selected_quarters, axis=1)
    ].copy()

    if filtered.empty:
        st.markdown(
            "<div class='empty-state'>No revenue recorded for the selected quarters and products.</div>",
            unsafe_allow_html=True,
        )
        return

    filtered["quarter_label"] = filtered.apply(
        lambda row: f"Q{int(row['quarter'])} {int(row['year'])}", axis=1
    )

    quarter_order = (
        filtered.sort_values(["year", "quarter"])["quarter_label"].drop_duplicates().tolist()
    )

    total_revenue = filtered["revenue"].sum()
    summary_bar = (
        f"<div style=\"display:flex; flex-wrap:wrap; gap:12px; margin:12px 0; color:{COLORS['text_muted']}; font-size:0.9rem;\">"
        f"<span style=\"font-weight:600; color:{COLORS['text_primary']};\">{display_mode} mode</span>"
        f"<span>{len(selected_quarters)} quarter{'s' if len(selected_quarters) != 1 else ''}</span>"
        f"<span>{len(selected_products)} product{'s' if len(selected_products) != 1 else ''}</span>"
        f"<span>Total revenue <strong>${total_revenue:,.0f}</strong></span>"
        "</div>"
    )
    st.markdown(summary_bar, unsafe_allow_html=True)

    chart_df = (
        filtered.groupby(["quarter_label", "display_name"], as_index=False)["revenue"].sum()
    )
    chart_df["revenue_display"] = chart_df["revenue"].map(lambda value: f"${value:,.0f}")

    quarter_position = {label: idx for idx, label in enumerate(quarter_order)}
    chart_df["quarter_index"] = chart_df["quarter_label"].map(quarter_position)
    chart_df = chart_df.sort_values(["quarter_index", "display_name"]).drop(columns=["quarter_index"])

    color_map = {
        name: PRODUCT_PALETTE.get(name, COLORS["primary"])
        for name in chart_df["display_name"].unique()
    }

    fig = px.bar(
        chart_df,
        x="quarter_label",
        y="revenue",
        color="display_name",
        custom_data=["revenue_display", "display_name"],
        category_orders={"quarter_label": quarter_order},
        color_discrete_map=color_map,
    )

    fig.update_layout(
        barmode="stack" if display_mode == "Stacked" else "group",
        margin=dict(t=20, b=25, l=10, r=10),
        paper_bgcolor="#FFFFFF",
        plot_bgcolor="#FFFFFF",
        legend=dict(
            orientation="h",
            yanchor="bottom",
            y=-0.2,
            x=0.5,
            xanchor="center",
            title="",
        ),
        font=dict(color=COLORS["text_primary"], family="Inter, 'Segoe UI', sans-serif"),
    )

    fig.update_traces(
        hovertemplate="<b>%{x}</b><br>%{customdata[1]}: %{customdata[0]}<extra></extra>",
        marker_line=dict(width=0),
    )

    fig.update_xaxes(title="", showgrid=True, gridcolor=COLORS["border"], tickangle=-15)
    fig.update_yaxes(title="Revenue (USD)", showgrid=True, gridcolor=COLORS["border"], zeroline=False)

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})

    summary = (
        filtered.groupby("display_name")["revenue"].sum().sort_values(ascending=False)
    )
    summary_rows = "".join(
        f"<div style='display:flex; justify-content:space-between; color:{COLORS['text_primary']};'>"
        f"<span>{name}</span><span>${value:,.0f}</span></div>"
        for name, value in summary.items()
    )
    empty_summary_html = summary_rows or (
        f"<span style=\"color:{COLORS['text_muted']};\">No revenue values available.</span>"
    )
    container_html = (
        f"<div style=\"background-color:{COLORS['surface']}; border:1px solid {COLORS['border']}; "
        f"border-radius:12px; padding:16px; margin-top:12px;\">"
        f"<p style=\"margin:0 0 8px 0; color:{COLORS['text_muted']}; font-size:0.85rem;\">Revenue by product</p>"
        f"{empty_summary_html}"
        "</div>"
    )
    st.markdown(container_html, unsafe_allow_html=True)



if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()





