"""Revenue Overview page with timeline filters."""

from __future__ import annotations

import calendar
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Dict, Iterable, List, Optional, Tuple

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


def render() -> None:
    """Render the Revenue Overview page."""

    connection = get_connection()
    timeline_df = _load_timeline_dataframe(connection)

    render_page_header(
        "Revenue Overview",
        "Interactive filters highlight how revenue evolves across months and products.",
    )
    _render_timeline_section(timeline_df)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    st.caption("Additional revenue insights (cohorts and quarterly performance) will arrive in upcoming phases.")


def _load_timeline_dataframe(connection) -> pd.DataFrame:
    records = connection.get_revenue_timeseries()
    if not records:
        return pd.DataFrame(columns=["product", "display_name", "date", "revenue"])

    df = pd.DataFrame(records)
    df["date"] = pd.to_datetime(dict(year=df["year"].astype(int), month=df["month"].astype(int), day=1))
    df["display_name"] = df["product"].map(PRODUCT_LABELS).fillna(df["product"])
    df = df.sort_values("date").reset_index(drop=True)
    return df[["product", "display_name", "date", "revenue"]]


def _build_month_options(df: pd.DataFrame) -> List[MonthOption]:
    unique = df[["date"]].drop_duplicates().sort_values("date")
    return [MonthOption(row.date.year, row.date.month) for row in unique.itertuples()]  # type: ignore[attr-defined]


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

    product_columns = st.columns(len(PRODUCT_LABELS))
    selected_products: List[str] = []
    for (raw_name, display_name), column in zip(PRODUCT_LABELS.items(), product_columns):
        if column.checkbox(display_name, value=True, key=f"timeline-product-{display_name.lower().replace(' ', '-')}"):
            selected_products.append(raw_name)

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


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()
