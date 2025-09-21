"""
Configuration for Codex-crafted Goldenberry Dashboard
- Reads Neo4j credentials from environment variables with sensible defaults
"""

from __future__ import annotations

import os
from dataclasses import dataclass


@dataclass(frozen=True)
class Neo4jConfig:
    """Typed container for Neo4j connection details."""

    uri: str = os.getenv("NEO4J_URI", "neo4j://127.0.0.1:7687")
    username: str = os.getenv("NEO4J_USERNAME", "neo4j")
    password: str = os.getenv("NEO4J_PASSWORD", "12345678")
    database: str = os.getenv("NEO4J_DATABASE", "neo4j")


NEO4J_CONFIG = Neo4jConfig()

CONNECTION_SETTINGS = {
    "max_connection_lifetime": 3600,
    "max_connection_pool_size": 50,
    "connection_acquisition_timeout": 60,
    "connection_timeout": 30,
}
