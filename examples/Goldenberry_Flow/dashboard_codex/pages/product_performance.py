"""Product performance page with selector-driven metrics and charts."""

from __future__ import annotations

import html
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Dict, List

import pandas as pd
import plotly.graph_objects as go
import streamlit as st

if __package__ in (None, ""):
    package_root = Path(__file__).resolve().parents[1]
    sys.path.insert(0, str(package_root.parent))
    from dashboard_codex.database import get_connection
    from dashboard_codex.pages.components import render_page_header
else:  # pragma: no cover - executed in package context
    from ..database import get_connection
    from .components import render_page_header


PRODUCT_LABELS: Dict[str, str] = {
    "Goldenberries (Physalis)": "Goldenberries",
    "Pitahaya (Dragon Fruit)": "Pitahaya",
    "Exotic Fruits Mix": "Exotic Fruits Mix",
}


@dataclass(frozen=True)
class MetricField:
    field: str
    label: str
    formatter: Callable[[float], str]


METRIC_FIELDS: List[MetricField] = [
    MetricField(
        field="TotalRevenue",
        label="Total Revenue",
        formatter=lambda value: f"${value:,.0f}",
    ),
    MetricField(
        field="TotalVolume",
        label="Total Volume",
        formatter=lambda value: f"{value:,.0f} kg",
    ),
    MetricField(
        field="AvgPrice",
        label="Avg Price per KG",
        formatter=lambda value: f"${value:,.2f}/kg",
    ),
]


COST_CARD_CONFIG = [
    ("Variable Cost", "variable_cost", "#1E40AF", "currency"),
    ("Cost per KG", "cost_per_kg", "#1E40AF", "currency_per_kg"),
    ("Gross Profit", "gross_profit", "#0EA5E9", "currency"),
    ("Gross Margin", "gross_margin", "#0284C7", "percentage"),
    ("Profit per KG", "profit_per_kg", "#0EA5E9", "currency_per_kg"),
]

def _get_display_name(raw_name: str) -> str:
    return PRODUCT_LABELS.get(raw_name, raw_name)


def _load_product_metrics() -> List[Dict[str, float]]:
    connection = get_connection()
    try:
        return connection.get_product_metrics()
    except Exception as exc:  # pragma: no cover - runtime fallback
        st.error(f"Unable to load product metrics: {exc}")
        return []


def _load_monthly_performance() -> pd.DataFrame:
    connection = get_connection()
    try:
        records = connection.get_product_monthly_performance()
    except Exception as exc:  # pragma: no cover - runtime fallback
        st.error(f"Unable to load monthly performance: {exc}")
        return pd.DataFrame()

    if not records:
        return pd.DataFrame()

    df = pd.DataFrame(records)
    df["date"] = pd.to_datetime({"year": df["year"].astype(int), "month": df["month"].astype(int), "day": 1})
    df["display_name"] = df["product"].map(PRODUCT_LABELS).fillna(df["product"])
    return df[["product", "display_name", "date", "revenue", "volume"]]


def _render_metric_cards(metrics: Dict[str, float]) -> None:
    cards_html: List[str] = ["<div class='metric-grid'>"]

    for field_config in METRIC_FIELDS:
        raw_value = metrics.get(field_config.field)
        formatted_value = field_config.formatter(raw_value) if raw_value is not None else "--"

        cards_html.append("<div class='metric-card'>")
        cards_html.append(f"<div class='label'>{html.escape(field_config.label)}</div>")
        cards_html.append(f"<div class='value'>{html.escape(formatted_value)}</div>")
        cards_html.append("</div>")

    cards_html.append("</div>")
    st.markdown("".join(cards_html), unsafe_allow_html=True)


def _format_cost_metric(value: float | None, style: str) -> str:
    if value is None:
        return "--"
    if style == "currency":
        return f"${value:,.0f}"
    if style == "currency_per_kg":
        return f"${value:,.2f}/kg"
    if style == "percentage":
        return f"{value:.1f}%"
    return str(value)



def _render_cost_analysis_cards(summary: Dict[str, float | None]) -> None:
    cols = st.columns(len(COST_CARD_CONFIG))
    for col, (label, key, color, style) in zip(cols, COST_CARD_CONFIG):
        value = summary.get(key)
        display_value = _format_cost_metric(value, style)
        card_html = (
            "<div class='metric-card'>"
            "<div class='label'>{label}</div>"
            "<div class='value'>{value}</div>"
            "</div>"
        ).format(color=color, label=html.escape(label), value=html.escape(display_value))
        col.markdown(card_html, unsafe_allow_html=True)



def _calculate_cost_metrics(product: str, metrics: Dict[str, float]) -> Dict[str, float | None]:
    try:
        connection = get_connection()
        variable_cost = connection.get_product_variable_cost(product)
    except Exception as exc:  # pragma: no cover - runtime fallback
        st.error(f"Unable to load cost metrics: {exc}")
        return {
            "variable_cost": None,
            "cost_per_kg": None,
            "gross_profit": None,
            "gross_margin": None,
            "profit_per_kg": None,
        }

    revenue = float(metrics.get("TotalRevenue") or 0.0)
    volume = float(metrics.get("TotalVolume") or 0.0)

    cost_per_kg = (variable_cost / volume) if volume else None
    gross_profit = revenue - variable_cost
    gross_margin = (gross_profit / revenue * 100) if revenue else None
    profit_per_kg = (gross_profit / volume) if volume else None

    return {
        "variable_cost": variable_cost,
        "cost_per_kg": cost_per_kg,
        "gross_profit": gross_profit,
        "gross_margin": gross_margin,
        "profit_per_kg": profit_per_kg,
    }


def _render_combination_chart(df: pd.DataFrame, product: str) -> None:
    filtered = df[df["product"] == product].sort_values("date")
    if filtered.empty:
        st.markdown(
            "<div class='empty-state'>No monthly revenue or volume data is available for this product.</div>",
            unsafe_allow_html=True,
        )
        return

    filtered["month_label"] = filtered["date"].dt.strftime("%b %Y")

    fig = go.Figure()
    fig.add_bar(
        x=filtered["month_label"],
        y=filtered["volume"],
        name="Volume",
        marker_color="#90E0EF",
        yaxis="y1",
        hovertemplate="<b>%{x}</b><br>Volume: %{y:,.0f} kg<extra></extra>",
    )
    fig.add_trace(
        go.Scatter(
            x=filtered["month_label"],
            y=filtered["revenue"],
            name="Revenue",
            mode="lines+markers",
            line=dict(color="#1D4ED8", width=3),
            marker=dict(size=7, color="#1D4ED8"),
            yaxis="y2",
            hovertemplate="<b>%{x}</b><br>Revenue: $%{y:,.0f}<extra></extra>",
        )
    )

    fig.update_layout(
        margin=dict(t=30, r=40, b=60, l=40),
        paper_bgcolor="#FFFFFF",
        plot_bgcolor="#FFFFFF",
        hovermode="x unified",
        legend=dict(orientation="h", yanchor="bottom", y=1.02, xanchor="center", x=0.5),
        yaxis=dict(
            title="Volume (kg)",
            title_font=dict(color="#0F172A"),
            tickfont=dict(color="#0F172A"),
            gridcolor="#E2E8F0",
        ),
        yaxis2=dict(
            title="Revenue (USD)",
            title_font=dict(color="#1D4ED8"),
            tickfont=dict(color="#1D4ED8"),
            overlaying="y",
            side="right",
            gridcolor="rgba(0,0,0,0)",
        ),
        xaxis=dict(showgrid=True, gridcolor="#E2E8F0"),
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})


def _render_market_share(total_revenue: float, selected_metrics: Dict[str, float], display_name: str) -> None:
    if total_revenue <= 0:
        st.markdown(
            "<div class='empty-state'>Total revenue is zero, so market share cannot be determined.</div>",
            unsafe_allow_html=True,
        )
        return

    selected_revenue = float(selected_metrics.get("TotalRevenue") or 0.0)
    share = max(min((selected_revenue / total_revenue) * 100 if total_revenue else 0.0, 100.0), 0.0)

    fig = go.Figure(
        go.Indicator(
            mode="gauge+number",
            value=share,
            number={"suffix": "%", "valueformat": ".1f"},
            gauge={
                "axis": {"range": [0, 100]},
                "bar": {"color": "#1D4ED8"},
                "steps": [
                    {"range": [0, 33], "color": "#E4ECFF"},
                    {"range": [33, 66], "color": "#B4C7FF"},
                    {"range": [66, 100], "color": "#7B9CFF"},
                ],
            },
            title={"text": f"{html.escape(display_name)} revenue share"},
        )
    )
    fig.update_layout(
        margin=dict(t=40, b=10, l=30, r=30),
        paper_bgcolor="#FFFFFF",
    )

    st.plotly_chart(fig, use_container_width=True, config={"displayModeBar": False})


def render() -> None:
    """Render the product performance page with selector and metrics."""

    render_page_header(
        "Product Performance",
        "Choose a product to review revenue, volume, and pricing metrics.",
    )

    metrics = _load_product_metrics()
    if not metrics:
        st.markdown(
            """
            <div class='empty-state'>
                Product metrics are not available right now. Check the database connection or try again later.
            </div>
            """,
            unsafe_allow_html=True,
        )
        return

    available_products = [record.get("Product", "") for record in metrics if record.get("Product")]
    if not available_products:
        st.markdown(
            """
            <div class='empty-state'>No product records were returned from the database.</div>
            """,
            unsafe_allow_html=True,
        )
        return

    total_revenue = sum(float(record.get("TotalRevenue") or 0.0) for record in metrics)

    preferred_default = "Goldenberries (Physalis)"
    default_product = (
        preferred_default if preferred_default in available_products else available_products[0]
    )

    selector_key = "product-performance-selected-product"
    if selector_key not in st.session_state or st.session_state[selector_key] not in available_products:
        st.session_state[selector_key] = default_product

    selected_product = st.selectbox(
        "Product",
        options=available_products,
        format_func=_get_display_name,
        key=selector_key,
        help="Select a product to update the metrics below.",
    )

    selected_metrics = next(
        (record for record in metrics if record.get("Product") == selected_product),
        None,
    )

    if not selected_metrics:
        st.warning("No metrics were found for the selected product.")
        return

    display_name = _get_display_name(selected_product)
    st.markdown(
        f"<h3 style='margin-top:1.5rem;'>{html.escape(display_name)} snapshot</h3>",
        unsafe_allow_html=True,
    )
    st.caption("Metrics refresh immediately when you switch products.")

    _render_metric_cards(selected_metrics)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)

    performance_df = _load_monthly_performance()
    st.markdown(
        """
        <div class='section-header'>
            <h2 class='section-title'>Revenue & Volume Trend</h2>
        </div>
        """,
        unsafe_allow_html=True,
    )
    st.caption("Dual-axis view comparing monthly revenue and shipment volume for the selected product.")
    if performance_df.empty:
        st.markdown(
            "<div class='empty-state'>Combined revenue and volume data is not available yet.</div>",
            unsafe_allow_html=True,
        )
    else:
        _render_combination_chart(performance_df, selected_product)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)

    st.markdown(
        """
        <div class='section-header'>
            <h2 class='section-title'>Market Share</h2>
        </div>
        """,
        unsafe_allow_html=True,
    )
    st.caption("Share of recorded revenue relative to the full product portfolio.")
    _render_market_share(total_revenue, selected_metrics, display_name)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    st.markdown(
        """
        <div class='section-header'>
            <h2 class='section-title'>Cost Structure Analysis</h2>
        </div>
        """
        , unsafe_allow_html=True,
    )
    cost_summary = _calculate_cost_metrics(selected_product, selected_metrics)
    _render_cost_analysis_cards(cost_summary)

    st.markdown("<hr class='section-divider'>", unsafe_allow_html=True)
    st.caption(
        "Phase 16 will focus on margin analysis, benchmarking, and overall polish."
    )


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()

