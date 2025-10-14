"""Executive dashboard page - refreshed layout with reusable components."""

from __future__ import annotations

import html
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import TYPE_CHECKING, Callable, List, Optional

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
    _render_distribution_section(connection, product_metrics)

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
        product_name = product.get("Product", "")
        clean_name = html.escape(_clean_product_name(product_name))
        revenue = float(product.get("TotalRevenue") or 0.0)
        volume = float(product.get("TotalVolume") or 0.0)

        try:
            variable_cost = float(connection.get_product_variable_cost(product_name))
        except Exception:  # pragma: no cover - runtime fallback
            variable_cost = None

        cost_per_kg = (variable_cost / volume) if (variable_cost is not None and volume) else None
        gross_profit = (revenue - variable_cost) if variable_cost is not None else None
        gross_margin = (
            (gross_profit / revenue) * 100 if (gross_profit is not None and revenue) else None
        )

        product_cards.append("<div class='product-card'>")
        product_cards.append(f"<h3>{clean_name}</h3>")
        product_cards.append(
            "<div class='product-stat'><span>Revenue</span><span class='value'>"
            f"{html.escape(_format_currency(revenue))}</span></div>"
        )
        product_cards.append(
            "<div class='product-stat'><span>Variable Cost</span><span class='value'>"
            f"{html.escape(_format_currency(variable_cost))}</span></div>"
        )
        product_cards.append(
            "<div class='product-stat'><span>Gross Profit</span>"
            f"<span class='value' style='color:#0EA5E9;'>"
            f"{html.escape(_format_currency(gross_profit))}</span></div>"
        )
        product_cards.append(
            "<div class='product-stat'><span>Gross Margin</span>"
            f"<span class='value' style='color:#0284C7;'>"
            f"{html.escape(_format_percentage(gross_margin))}</span></div>"
        )
        product_cards.append(
            "<div class='product-stat'><span>Cost per KG</span><span class='value'>"
            f"{html.escape(_format_currency(cost_per_kg, decimals=2, suffix='/kg'))}</span></div>"
        )
        product_cards.append("</div>")

    product_cards.append("</div>")

    st.markdown("".join(product_cards), unsafe_allow_html=True)
    return products


VARIABLE_BEHAVIOR_COLORS = ["#1E3A8A", "#3730A3", "#4338CA", "#1D4ED8"]
FIXED_BEHAVIOR_COLORS = ["#60A5FA", "#93C5FD", "#BFDBFE", "#DBEAFE"]


def _render_distribution_section(connection: "Neo4jConnection", product_metrics: List[dict]) -> None:
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Distribution Overview</h2>
        </div>
        <hr class='section-divider'>
        """,
        unsafe_allow_html=True,
    )

    revenue_col, cost_col = st.columns(2)
    with revenue_col:
        _render_revenue_distribution_chart(product_metrics)
    with cost_col:
        _render_cost_distribution_chart(connection)
    performance = _calculate_business_performance(connection, product_metrics)
    _render_business_performance(performance)


def _render_revenue_distribution_chart(product_metrics: List[dict]) -> None:
    st.markdown("<h3 style='margin:0 0 0.75rem;'>Revenue Distribution</h3>", unsafe_allow_html=True)

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
        legend=dict(orientation="h", yanchor="bottom", y=-0.2, x=0.5, xanchor="center"),
        font=dict(color=COLORS["text_primary"], family="Inter, 'Segoe UI', sans-serif"),
        uniformtext_minsize=12,
        uniformtext_mode="hide",
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})


def _render_cost_distribution_chart(connection: "Neo4jConnection") -> None:
    st.markdown("<h3 style='margin:0 0 0.75rem;'>Cost Distribution by Category</h3>", unsafe_allow_html=True)

    try:
        records = connection.get_cost_totals_by_category()
    except Exception as exc:  # pragma: no cover - runtime fallback
        st.error(f"Unable to load cost distribution: {exc}")
        return

    if not records:
        st.markdown(
            "<div class='empty-state'>Cost distribution data is not available for the selected period.</div>",
            unsafe_allow_html=True,
        )
        return

    df = pd.DataFrame(records)
    if df.empty:
        st.markdown(
            "<div class='empty-state'>Cost distribution data is not available for the selected period.</div>",
            unsafe_allow_html=True,
        )
        return

    df["category"] = df["category"].fillna("Uncategorized")
    df["behavior"] = df["behavior"].replace({"": "fixed"}).fillna("fixed")
    df["total_cost"] = df["total_cost"].astype(float)
    df = df[df["total_cost"] > 0].sort_values("total_cost", ascending=False)

    if df.empty:
        st.markdown(
            "<div class='empty-state'>Cost distribution data is not available for the selected period.</div>",
            unsafe_allow_html=True,
        )
        return

    total_cost = df["total_cost"].sum()
    share_threshold = 3.0

    grouped_rows = []
    other_total = 0.0
    other_details: List[str] = []

    for _, row in df.iterrows():
        share_pct = (row["total_cost"] / total_cost) * 100 if total_cost else 0.0
        if share_pct >= share_threshold or not grouped_rows:
            grouped_rows.append(
                {
                    "category": row["category"],
                    "total_cost": float(row["total_cost"]),
                    "behavior": row["behavior"],
                    "share_pct": share_pct,
                }
            )
        else:
            other_total += float(row["total_cost"])
            other_details.append(
                f"{row['category']} ({share_pct:.1f}%, ${row['total_cost']:,.0f})"
            )

    if other_total > 0:
        grouped_rows.append(
            {
                "category": "Other Costs",
                "total_cost": other_total,
                "behavior": "fixed",
                "share_pct": (other_total / total_cost) * 100 if total_cost else 0.0,
                "details": list(other_details),
            }
        )

    grouped_df = pd.DataFrame(grouped_rows)
    grouped_df = grouped_df.sort_values("total_cost", ascending=False).reset_index(drop=True)

    color_map = {}
    variable_index = 0
    fixed_index = 0

    for category, behavior in zip(grouped_df["category"], grouped_df["behavior"]):
        if behavior == "variable":
            color = VARIABLE_BEHAVIOR_COLORS[variable_index % len(VARIABLE_BEHAVIOR_COLORS)]
            variable_index += 1
        else:
            color = FIXED_BEHAVIOR_COLORS[fixed_index % len(FIXED_BEHAVIOR_COLORS)]
            fixed_index += 1
        color_map[category] = color

    formatted_costs = grouped_df["total_cost"].map(lambda value: f"${value:,.0f}")
    hover_text: List[str] = []
    for index, row in grouped_df.iterrows():
        lines = [
            f"<b>{row['category']}</b>",
            f"Type: {'Variable' if row['behavior'] == 'variable' else 'Fixed'}",
            f"Cost: {formatted_costs.loc[index]}",
            f"Share: {row['share_pct']:.1f}%",
        ]
        if row["category"] == "Other Costs" and row.get("details"):
            detail_lines = "<br>".join(f"- {detail}" for detail in row["details"])
            lines.insert(2, f"Includes:<br>{detail_lines}")
        hover_text.append("<br>".join(lines))

    fig = px.pie(
        grouped_df,
        names="category",
        values="total_cost",
        hole=0.55,
        color="category",
        color_discrete_map=color_map,
    )

    fig.update_traces(
        sort=False,
        textposition="outside",
        texttemplate="%{percent:.1%}",
        hovertext=hover_text,
        hoverinfo="text",
        hovertemplate="%{hovertext}<extra></extra>",
        marker=dict(line=dict(color="#FFFFFF", width=2)),
        pull=0,
    )

    fig.update_layout(
        margin=dict(t=20, b=20, l=10, r=10),
        paper_bgcolor="#FFFFFF",
        plot_bgcolor="#FFFFFF",
        showlegend=True,
        legend=dict(orientation="h", yanchor="bottom", y=-0.2, x=0.5, xanchor="center"),
        font=dict(color=COLORS["text_primary"], family="Inter, 'Segoe UI', sans-serif"),
        uniformtext_minsize=12,
        uniformtext_mode="hide",
        annotations=[
            dict(
                text=f"Total Cost<br>${total_cost:,.0f}",
                showarrow=False,
                font=dict(size=15, color=COLORS["text_primary"]),
            )
        ],
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})


def _format_ratio(value: Optional[float]) -> str:
    if value is None:
        return "--"
    return f"{value:.2f}×"


def _calculate_business_performance(connection: "Neo4jConnection", product_metrics: List[dict]) -> dict:
    if not product_metrics:
        return {
            "metrics": {},
            "products": [],
            "totals": {},
            "footnote": "*Net profit includes allocated fixed costs.",
        }

    total_revenue = sum(float(product.get("TotalRevenue") or 0.0) for product in product_metrics)
    variable_total = float(connection.get_variable_costs() or 0.0)
    fixed_total = float(connection.get_fixed_costs() or 0.0)
    total_costs = variable_total + fixed_total

    gross_profit_total = total_revenue - variable_total
    net_profit_total = gross_profit_total - fixed_total

    overall_profit_margin = (net_profit_total / total_revenue * 100) if total_revenue else None
    break_even = (total_revenue / total_costs) if total_costs else None
    contribution_margin = gross_profit_total

    product_rows: List[dict] = []
    allocated_fixed_total = 0.0

    for product in product_metrics:
        name = product.get("Product", "")
        revenue = float(product.get("TotalRevenue") or 0.0)
        variable_cost = float(connection.get_product_variable_cost(name) or 0.0)
        gross_profit = revenue - variable_cost
        gross_margin_pct = (gross_profit / revenue * 100) if revenue else None

        allocation_share = (revenue / total_revenue) if total_revenue else 0.0
        allocated_fixed = fixed_total * allocation_share
        allocated_fixed_total += allocated_fixed

        net_profit = gross_profit - allocated_fixed
        net_margin_pct = (net_profit / revenue * 100) if revenue else None

        product_rows.append(
            {
                "product": name,
                "revenue": revenue,
                "variable_cost": variable_cost,
                "gross_profit": gross_profit,
                "gross_margin_pct": gross_margin_pct,
                "allocated_fixed": allocated_fixed,
                "net_profit": net_profit,
                "net_margin_pct": net_margin_pct,
            }
        )

    # Ensure rounding errors don't accumulate
    allocated_fixed_total = round(allocated_fixed_total, 2)

    totals_row = {
        "product": "TOTAL",
        "revenue": total_revenue,
        "variable_cost": variable_total,
        "gross_profit": gross_profit_total,
        "gross_margin_pct": (gross_profit_total / total_revenue * 100) if total_revenue else None,
        "allocated_fixed": fixed_total,
        "net_profit": net_profit_total,
        "net_margin_pct": overall_profit_margin,
    }

    metrics_summary = {
        "net_profit": net_profit_total,
        "overall_profit_margin": overall_profit_margin,
        "break_even": break_even,
        "contribution_margin": contribution_margin,
        "total_revenue": total_revenue,
        "total_costs": total_costs,
    }

    return {
        "metrics": metrics_summary,
        "products": product_rows,
        "totals": totals_row,
        "footnote": "*Net profit includes allocated fixed costs.",
    }


def _render_business_performance(data: dict) -> None:
    metrics = data.get("metrics", {})
    products = data.get("products", [])
    totals = data.get("totals", {})

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    st.markdown(
        """
        <div class="section-header">
            <h2 class="section-title">Overall Business Performance</h2>
        </div>
        """,
        unsafe_allow_html=True,
    )

    cards = [
        {"label": "Total Net Profit", "value": _format_currency(metrics.get("net_profit"))},
        {
            "label": "Overall Profit Margin",
            "value": _format_percentage(metrics.get("overall_profit_margin")),
        },
        {
            "label": "Break-even Coverage",
            "value": _format_ratio(metrics.get("break_even")),
        },
        {
            "label": "Contribution Margin",
            "value": _format_currency(metrics.get("contribution_margin")),
        },
    ]

    cards_html = ["<div class='metric-grid'>"]
    for card in cards:
        cards_html.append(
            "<div class='metric-card'>"
            "<div class='label'>{label}</div>"
            "<div class='value'>{value}</div>"
            "</div>".format(
                label=html.escape(card["label"]),
                value=html.escape(card["value"]),
            )
        )
    cards_html.append("</div>")
    st.markdown("".join(cards_html), unsafe_allow_html=True)

    if not products:
        render_empty_state("Business performance data is not available yet.")
        return

    table_rows = []
    for row in products:
        table_rows.append(
            "<tr>"
            f"<td>{html.escape(_clean_product_name(row['product']))}</td>"
            f"<td>{html.escape(_format_currency(row['revenue']))}</td>"
            f"<td>{html.escape(_format_currency(row['variable_cost']))}</td>"
            f"<td>{html.escape(_format_currency(row['gross_profit']))}</td>"
            f"<td>{html.escape(_format_percentage(row['gross_margin_pct']))}</td>"
            f"<td>{html.escape(_format_currency(row['net_profit']))}</td>"
            f"<td>{html.escape(_format_percentage(row['net_margin_pct']))}</td>"
            "</tr>"
        )

    totals_row_html = (
        "<tr style='background-color:#DBEAFE; font-weight:600;'>"
        f"<td>{html.escape(totals.get('product', 'TOTAL'))}</td>"
        f"<td>{html.escape(_format_currency(totals.get('revenue')))}</td>"
        f"<td>{html.escape(_format_currency(totals.get('variable_cost')))}</td>"
        f"<td>{html.escape(_format_currency(totals.get('gross_profit')))}</td>"
        f"<td>{html.escape(_format_percentage(totals.get('gross_margin_pct')))}</td>"
        f"<td>{html.escape(_format_currency(totals.get('net_profit')))}</td>"
        f"<td>{html.escape(_format_percentage(totals.get('net_margin_pct')))}</td>"
        "</tr>"
    )

    table_html = (
        "<div style='overflow-x:auto; margin-top:1rem;'>"
        "<table style='width:100%; border-collapse:collapse;'>"
        "<thead>"
        "<tr>"
        "<th style='text-align:left; padding:0.5rem;'>Product</th>"
        "<th style='text-align:right; padding:0.5rem;'>Revenue</th>"
        "<th style='text-align:right; padding:0.5rem;'>Variable Cost</th>"
        "<th style='text-align:right; padding:0.5rem;'>Gross Profit</th>"
        "<th style='text-align:right; padding:0.5rem;'>Gross Margin %</th>"
        "<th style='text-align:right; padding:0.5rem;'>Net Profit*</th>"
        "<th style='text-align:right; padding:0.5rem;'>Net Margin %</th>"
        "</tr>"
        "</thead>"
        "<tbody>"
        f"{''.join(table_rows)}"
        f"{totals_row_html}"
        "</tbody>"
        "</table>"
        "</div>"
        f"<p style='font-size:0.8rem; color:{COLORS['text_muted']}; margin-top:0.5rem;'>{html.escape(data.get('footnote', ''))}</p>"
    )

    st.markdown(table_html, unsafe_allow_html=True)


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()
