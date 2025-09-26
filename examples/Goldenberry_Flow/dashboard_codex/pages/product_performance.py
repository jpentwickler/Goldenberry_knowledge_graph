"""Product performance page with selector-driven metrics."""

from __future__ import annotations

import html
import sys
from dataclasses import dataclass
from pathlib import Path
from typing import Callable, Dict, List

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


def _get_display_name(raw_name: str) -> str:
    return PRODUCT_LABELS.get(raw_name, raw_name)


def _load_product_metrics() -> List[Dict[str, float]]:
    connection = get_connection()
    try:
        return connection.get_product_metrics()
    except Exception as exc:  # pragma: no cover - runtime fallback
        st.error(f"Unable to load product metrics: {exc}")
        return []


def _render_metric_cards(metrics: Dict[str, float]) -> None:
    cards_html: List[str] = ["<div class='metric-grid'>"]

    for field_config in METRIC_FIELDS:
        raw_value = metrics.get(field_config.field)
        if raw_value is None:
            formatted_value = "--"
        else:
            formatted_value = field_config.formatter(raw_value)

        cards_html.append("<div class='metric-card'>")
        cards_html.append(f"<div class='label'>{html.escape(field_config.label)}</div>")
        cards_html.append(f"<div class='value'>{html.escape(formatted_value)}</div>")
        cards_html.append("</div>")

    cards_html.append("</div>")
    st.markdown("".join(cards_html), unsafe_allow_html=True)


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
    st.caption(
        "Upcoming phases will add margin analysis, combination charts, and portfolio benchmarks to this page."
    )


if __name__ == "__main__":  # pragma: no cover - standalone Streamlit page
    render()
