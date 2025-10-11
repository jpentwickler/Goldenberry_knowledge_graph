"""Executive dashboard page - refreshed layout with reusable components."""

from __future__ import annotations

import html
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING, Callable, List, Optional

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

if TYPE_CHECKING:  # pragma: no cover - for type checkers only
    from dashboard_codex.database.connection import Neo4jConnection


@dataclass
class MetricDefinition:
    label: str
    fetch: Callable[["Neo4jConnection"], float]
    formatter: Callable[[float], str]
    footnote: Optional[str] = None


@dataclass
class MetricResult:
    label: str
    formatted_value: str
    error: Optional[str] = None
    footnote: Optional[str] = None


def _clean_product_name(raw_name: str) -> str:
    """Return a display-friendly product name."""

    if not raw_name:
        return "Unnamed Product"
    return raw_name.split(" (")[0]


METRIC_DEFINITIONS: List[MetricDefinition] = [
    MetricDefinition("Total Revenue", lambda db: db.get_total_revenue(), lambda v: f"${v:,.2f}"),
    MetricDefinition("Total Volume", lambda db: db.get_total_volume(), lambda v: f"{v:,.2f} kg"),
    MetricDefinition(
        "Avg Monthly Revenue",
        lambda db: db.get_average_monthly_revenue(),
        lambda v: f"${v:,.2f}",
        footnote="Average revenue per recorded month",
    ),
    MetricDefinition(
        "Avg Price per KG",
        lambda db: db.get_average_price_per_kg(),
        lambda v: f"${v:,.2f}/kg",
        footnote="Weighted by product volume",
    ),
]


def _format_currency(value: Optional[float], *, decimals: int = 0, suffix: str = "") -> str:
    if value is None:
        return "--"
    return f"${value:,.{decimals}f}{suffix}"


def _format_percentage(value: Optional[float], *, decimals: int = 1) -> str:
    if value is None:
        return "--"
    return f"{value:.{decimals}f}%"


def _calculate_cost_overview(connection: "Neo4jConnection") -> dict:
    total_costs = float(connection.get_total_costs() or 0.0)
    variable_costs = float(connection.get_variable_costs() or 0.0)
    fixed_costs = float(connection.get_fixed_costs() or 0.0)
    avg_cost_per_kg = float(connection.get_average_cost_per_kg() or 0.0)
    total_revenue = float(connection.get_total_revenue() or 0.0)

    gross_margin_pct = None
    if total_revenue:
        gross_margin_pct = ((total_revenue - variable_costs) / total_revenue) * 100

    variable_pct = (variable_costs / total_costs * 100) if total_costs else None
    fixed_pct = (fixed_costs / total_costs * 100) if total_costs else None

    cost_records = connection.get_cost_timeseries()
    month_keys = {
        (row.get("year"), row.get("month"))
        for row in cost_records
        if row.get("year") and row.get("month")
    }
    month_count = len(month_keys)
    avg_monthly_cost = (total_costs / month_count) if month_count else None

    return {
        "total_costs": total_costs,
        "variable_costs": variable_costs,
        "fixed_costs": fixed_costs,
        "variable_pct": variable_pct,
        "fixed_pct": fixed_pct,
        "avg_cost_per_kg": avg_cost_per_kg,
        "gross_margin_pct": gross_margin_pct,
        "avg_monthly_cost": avg_monthly_cost,
        "month_count": month_count,
    }


def _render_cost_metrics(connection: "Neo4jConnection") -> None:
    try:
        summary = _calculate_cost_overview(connection)
    except Exception as exc:  # pragma: no cover - display fallback
        st.error(f"Unable to load cost overview: {exc}")
        return

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Cost Overview</h2>
        </div>
        """,
        unsafe_allow_html=True,
    )

    month_note = (
        f"{summary['month_count']} recorded month{'s' if summary['month_count'] != 1 else ''}"
        if summary["month_count"]
        else None
    )

    cards = [
        {
            "label": "Total Costs",
            "value": _format_currency(summary["total_costs"]),
            "footnote": None,
        },
        {
            "label": "Variable Costs",
            "value": _format_currency(summary["variable_costs"]),
            "footnote": (
                f"{summary['variable_pct']:.1f}% of total" if summary["variable_pct"] is not None else None
            ),
        },
        {
            "label": "Fixed Costs",
            "value": _format_currency(summary["fixed_costs"]),
            "footnote": (
                f"{summary['fixed_pct']:.1f}% of total" if summary["fixed_pct"] is not None else None
            ),
        },
        {
            "label": "Avg Cost per KG",
            "value": _format_currency(summary["avg_cost_per_kg"], decimals=2, suffix="/kg"),
            "footnote": None,
        },
        {
            "label": "Gross Margin",
            "value": _format_percentage(summary["gross_margin_pct"]),
            "footnote": "Avg across all products",
        },
        {
            "label": "Avg Monthly Cost",
            "value": _format_currency(summary["avg_monthly_cost"]),
            "footnote": month_note,
        },
    ]

    cards_html: List[str] = ["<div class='metric-grid'>"]
    for card in cards:
        cards_html.append(
            "<div class='metric-card'>"
            "<div class='label'>{label}</div>"
            "<div class='value'>{value}</div>"
            "{footnote}"
            "</div>".format(
                label=html.escape(card["label"]),
                value=html.escape(card["value"]),
                footnote=(
                    f"<small>{html.escape(card['footnote'])}</small>" if card.get("footnote") else ""
                ),
            )
        )
    cards_html.append("</div>")

    st.markdown("".join(cards_html), unsafe_allow_html=True)


def render() -> None:
    """Render the executive dashboard page."""

    connection = get_connection()

    render_page_header(
        "Executive Dashboard",
        "Critical revenue metrics and top product performance at a glance.",
    )
    _render_metrics(connection)
    _render_cost_metrics(connection)
    product_metrics = _render_product_highlights(connection)
    _render_revenue_share_chart(product_metrics)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    st.caption("Additional executive insights, charts, and filters will arrive in the next phase.")


def _render_metrics(connection: "Neo4jConnection") -> None:
    metrics: List[MetricResult] = []

    for definition in METRIC_DEFINITIONS:
        try:
            value = definition.fetch(connection)
            metrics.append(
                MetricResult(
                    label=definition.label,
                    formatted_value=definition.formatter(value),
                    footnote=definition.footnote,
                )
            )
        except Exception as exc:  # pragma: no cover - display fallback
            metrics.append(
                MetricResult(
                    label=definition.label,
                    formatted_value="--",
                    error=str(exc),
                    footnote=definition.footnote,
                )
            )

    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Revenue Overview</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    cards_html = ["<div class='metric-grid'>"]

    for metric in metrics:
        cards_html.append("<div class='metric-card'>")
        cards_html.append(f"<div class='label'>{html.escape(metric.label)}</div>")
        if metric.error:
            cards_html.append("<div class='value' style='font-size:1.1rem; color:#B91C1C;'>Error</div>")
            cards_html.append(f"<small>{html.escape(metric.error)}</small>")
        else:
            cards_html.append(f"<div class='value'>{html.escape(metric.formatted_value)}</div>")
            if metric.footnote:
                cards_html.append(f"<small>{html.escape(metric.footnote)}</small>")
        cards_html.append("</div>")
    cards_html.append("</div>")

    st.markdown("".join(cards_html), unsafe_allow_html=True)


def _render_product_highlights(connection: "Neo4jConnection") -> List[dict]:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Product Performance Highlights</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    try:
        products = connection.get_product_metrics()
    except Exception as exc:  # pragma: no cover - fallback
        st.error(f"Unable to load product metrics: {exc}")
        return []

    if not products:
        st.markdown("<div class='empty-state'>No product data available yet.</div>", unsafe_allow_html=True)
        return []

    product_cards: List[str] = ["<div class='product-grid'>"]

    for product in products[:3]:
        clean_name = html.escape(_clean_product_name(product.get("Product", "")))
        total_revenue = html.escape(f"${product.get('TotalRevenue', 0.0):,.0f}")
        total_volume = html.escape(f"{product.get('TotalVolume', 0.0):,.0f} kg")
        avg_price = html.escape(f"${product.get('AvgPrice', 0.0):.2f}/kg")

        product_cards.append("<div class='product-card'>")
        product_cards.append(f"<h3>{clean_name}</h3>")
        product_cards.append(
            "<div class='product-stat'><span>Total Revenue</span><span class='value'>"
            f"{total_revenue}</span></div>"
        )
        product_cards.append(
            "<div class='product-stat'><span>Total Volume</span><span class='value'>"
            f"{total_volume}</span></div>"
        )
        product_cards.append(
            "<div class='product-stat'><span>Average Price</span><span class='value'>"
            f"{avg_price}</span></div>"
        )
        product_cards.append("</div>")

    product_cards.append("</div>")

    st.markdown("".join(product_cards), unsafe_allow_html=True)
    return products


def _render_revenue_share_chart(product_metrics: List[dict]) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Revenue Distribution</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    top_products = product_metrics[:3]
    chart_rows = []
    total_revenue = 0.0

    for product in top_products:
        revenue = float(product.get("TotalRevenue") or 0.0)
        total_revenue += max(revenue, 0.0)
        chart_rows.append(
            {
                "label": _clean_product_name(product.get("Product", "")),
                "revenue": max(revenue, 0.0),
            }
        )

    if total_revenue <= 0.0 or not chart_rows:
        st.markdown(
            "<div class='empty-state'>Revenue data is not available for the selected period.</div>",
            unsafe_allow_html=True,
        )
        return

    values = [row["revenue"] for row in chart_rows]
    labels = [row["label"] for row in chart_rows]
    formatted_revenue = [f"${value:,.0f}" for value in values]

    palette = [COLORS["primary"], COLORS["primary_alt"], COLORS["accent"], COLORS["primary_tint"]]
    color_sequence = palette[: len(chart_rows)]

    fig = px.pie(
        names=labels,
        values=values,
        hole=0.55,
        color=labels,
        color_discrete_sequence=color_sequence,
    )

    fig.update_traces(
        sort=False,
        textposition="outside",
        texttemplate="%{percent:.1%}",
        hovertemplate="<b>%{label}</b><br>Revenue: %{customdata[0]}<br>Share: %{percent:.1%}<extra></extra>",
        customdata=[[value] for value in formatted_revenue],
        marker=dict(line=dict(color="#FFFFFF", width=2)),
        pull=0,
    )

    fig.update_layout(
        margin=dict(t=20, b=20, l=10, r=10),
        paper_bgcolor="#FFFFFF",
        plot_bgcolor="#FFFFFF",
        showlegend=True,
        legend=dict(orientation="h", yanchor="bottom", y=-0.15, x=0.5, xanchor="center"),
        font=dict(color=COLORS["text_primary"], family="Inter, 'Segoe UI', sans-serif"),
        uniformtext_minsize=12,
        uniformtext_mode="hide",
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()
