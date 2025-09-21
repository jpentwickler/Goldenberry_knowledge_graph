"""
Database connectivity status helpers for the Codex dashboard variant.
"""

from __future__ import annotations

from typing import Dict

from .connection import get_connection


def get_compact_database_status() -> Dict[str, str]:
    """Return status metadata for the database connection."""

    connection = get_connection()

    if not connection.connected:
        return {
            "status": "error",
            "icon": "\u26A0",
            "label": "Database Issue",
            "description": connection.error_message or "Unable to reach Neo4j",
        }

    try:
        product_count = connection.get_product_count()
        return {
            "status": "ready",
            "icon": "\u2713",
            "label": "Database Ready",
            "description": f"Connected | {product_count} products",
        }
    except Exception as exc:  # pragma: no cover - information only
        return {
            "status": "error",
            "icon": "\u26A0",
            "label": "Query Failed",
            "description": str(exc),
        }


def render_status_pill() -> str:
    """Return HTML markup for the header status pill."""

    info = get_compact_database_status()
    status = info.get("status", "ready")
    return (
        f"<span class='status-pill' data-status='{status}'>"
        f"<span>{info.get('icon')}</span>"
        f"<span>{info.get('label')}</span>"
        f"</span>"
        f"<span style='display:none'>| {info.get('description')}</span>"
    )


__all__ = ["get_compact_database_status", "render_status_pill"]
