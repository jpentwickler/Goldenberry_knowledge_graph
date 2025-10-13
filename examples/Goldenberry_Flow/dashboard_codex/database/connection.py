"""
Neo4j data access layer for the Codex Goldenberry dashboard.
Keeps the API compatible with the original implementation while improving
logging, typing, and data post-processing.
"""

from __future__ import annotations

import logging
from functools import lru_cache
from typing import Any, Dict, List, Optional

from neo4j import GraphDatabase

from ..config import CONNECTION_SETTINGS, NEO4J_CONFIG

logger = logging.getLogger(__name__)
logger.setLevel(logging.INFO)


class Neo4jConnection:
    """Lightweight wrapper around the Neo4j Python driver."""

    def __init__(self) -> None:
        self._driver = None
        self.connected: bool = False
        self.error_message: Optional[str] = None

        try:
            self._driver = GraphDatabase.driver(
                NEO4J_CONFIG.uri,
                auth=(NEO4J_CONFIG.username, NEO4J_CONFIG.password),
                max_connection_lifetime=CONNECTION_SETTINGS["max_connection_lifetime"],
                max_connection_pool_size=CONNECTION_SETTINGS["max_connection_pool_size"],
                connection_acquisition_timeout=CONNECTION_SETTINGS["connection_acquisition_timeout"],
                connection_timeout=CONNECTION_SETTINGS["connection_timeout"],
            )
            self._test_connection()
        except Exception as exc:
            self.error_message = f"Failed to connect to Neo4j: {exc}"
            logger.error(self.error_message)

    # ------------------------------------------------------------------
    def _test_connection(self) -> None:
        """Verify that we can reach the database."""

        if self._driver is None:
            raise RuntimeError("Neo4j driver not initialised")

        try:
            with self._driver.session(database=NEO4J_CONFIG.database) as session:
                result = session.run("RETURN 1 as ok")
                if result.single()["ok"] != 1:
                    raise RuntimeError("Unexpected connection test result")

            self.connected = True
            logger.info("Successfully connected to Neo4j at %s", NEO4J_CONFIG.uri)
        except Exception as exc:
            self.connected = False
            self.error_message = f"Connection test failed: {exc}"
            logger.error(self.error_message)
            raise

    # ------------------------------------------------------------------
    def execute_query(self, query: str, parameters: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """Execute a Cypher query and return a list of dicts."""

        if not self.connected:
            raise RuntimeError(self.error_message or "Database connection is not ready")

        assert self._driver is not None

        try:
            with self._driver.session(database=NEO4J_CONFIG.database) as session:
                result = session.run(query, parameters or {})
                return [record.data() for record in result]
        except Exception as exc:
            message = f"Query execution failed: {exc}"
            logger.error(message)
            raise RuntimeError(message) from exc

    # Metric helpers ----------------------------------------------------
    def get_product_count(self) -> int:
        data = self.execute_query("MATCH (p:Product) RETURN count(p) AS product_count")
        return int(data[0]["product_count"]) if data else 0

    def get_total_revenue(self) -> float:
        query = """
        MATCH (rs:RevenueStream)-[:HAS_VOLUME_DATA]->(vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod),
              (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
        RETURN SUM(vd.volume * pd.price) AS totalRevenue
        """
        data = self.execute_query(query)
        return float(data[0]["totalRevenue"] or 0.0) if data else 0.0

    def get_total_volume(self) -> float:
        data = self.execute_query("MATCH (vd:VolumeData) RETURN SUM(vd.volume) AS totalVolume")
        return float(data[0]["totalVolume"] or 0.0) if data else 0.0

    def get_average_monthly_revenue(self) -> float:
        query = """
        MATCH (rs:RevenueStream)-[:HAS_VOLUME_DATA]->(vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod),
              (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
        WITH tp, SUM(vd.volume * pd.price) AS monthlyRevenue
        RETURN AVG(monthlyRevenue) AS avgMonthlyRevenue
        """
        data = self.execute_query(query)
        return float(data[0]["avgMonthlyRevenue"] or 0.0) if data else 0.0

    def get_average_price_per_kg(self) -> float:
        query = """
        MATCH (rs:RevenueStream)-[:HAS_VOLUME_DATA]->(vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod),
              (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
        RETURN SUM(vd.volume * pd.price) / SUM(vd.volume) AS avgPricePerKg
        """
        data = self.execute_query(query)
        return float(data[0]["avgPricePerKg"] or 0.0) if data else 0.0

    def get_total_costs(self) -> float:
        """Return the sum of all recorded costs."""

        data = self.execute_query("MATCH (cd:CostData) RETURN SUM(cd.amount) AS totalCosts")
        return float(data[0]["totalCosts"] or 0.0) if data else 0.0

    def get_variable_costs(self) -> float:
        """Return the sum of all product-linked costs."""

        query = """
        MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(:Product)
        RETURN SUM(cd.amount) AS variableCosts
        """
        data = self.execute_query(query)
        return float(data[0]["variableCosts"] or 0.0) if data else 0.0

    def get_fixed_costs(self) -> float:
        """Return the sum of costs without an associated product."""

        query = """
        MATCH (cd:CostData)
        WHERE NOT (cd)-[:COST_FOR_PRODUCT]->(:Product)
        RETURN SUM(cd.amount) AS fixedCosts
        """
        data = self.execute_query(query)
        return float(data[0]["fixedCosts"] or 0.0) if data else 0.0

    def get_cost_timeseries(self, product: Optional[str] = None, category: Optional[str] = None) -> List[Dict[str, Any]]:
        """Return monthly cost totals optionally filtered by product or category."""

        query = """
        MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
        OPTIONAL MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
        WITH cd, tp, cs, p
        WHERE ($product IS NULL OR p.name = $product)
          AND ($category IS NULL OR cs.name = $category)
        RETURN p.name AS product,
               cs.name AS category,
               tp.year AS year,
               tp.month AS month,
               SUM(cd.amount) AS cost
        ORDER BY year, month, category, product
        """
        result = self.execute_query(query, {"product": product, "category": category})

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "product": row.get("product"),
                    "category": row.get("category"),
                    "year": int(row["year"]) if row.get("year") is not None else 0,
                    "month": int(row["month"]) if row.get("month") is not None else 0,
                    "cost": float(row["cost"] or 0.0),
                }
            )

        return records

    def get_quarterly_costs(self, product: Optional[str] = None, category: Optional[str] = None) -> List[Dict[str, Any]]:
        """Return quarterly cost totals optionally filtered by product or category."""

        query = """
        MATCH (cd:CostData)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
        OPTIONAL MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
        WITH cd, tp, cs, p
        WHERE ($product IS NULL OR p.name = $product)
          AND ($category IS NULL OR cs.name = $category)
        RETURN p.name AS product,
               cs.name AS category,
               tp.year AS year,
               tp.quarter AS quarter,
               SUM(cd.amount) AS cost
        ORDER BY year, quarter, category, product
        """
        result = self.execute_query(query, {"product": product, "category": category})

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "product": row.get("product"),
                    "category": row.get("category"),
                    "year": int(row["year"]) if row.get("year") is not None else 0,
                    "quarter": _parse_quarter_value(row.get("quarter")),
                    "cost": float(row["cost"] or 0.0),
                }
            )

        return records

    def get_cost_categories(self) -> List[str]:
        """Return the list of cost structures that have recorded costs."""

        query = """
        MATCH (cs:CostStructure)<-[:COST_FOR_STRUCTURE]-(:CostData)
        RETURN DISTINCT cs.name AS name
        ORDER BY name
        """
        result = self.execute_query(query)
        return [row["name"] for row in result if row.get("name")]

    def get_product_costs(self, product_name: str) -> List[Dict[str, Any]]:
        """Return cost totals per category for a specific product."""

        query = """
        MATCH (p:Product {name: $product_name})
        OPTIONAL MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(p)
        OPTIONAL MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
        WITH cs.name AS category, SUM(cd.amount) AS totalCost
        RETURN category, totalCost
        ORDER BY totalCost DESC
        """
        result = self.execute_query(query, {"product_name": product_name})

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "category": row.get("category"),
                    "cost": float(row.get("totalCost") or 0.0),
                }
            )

        return records
    def get_product_variable_cost(self, product_name: str) -> float:
        """Return aggregated variable cost for a specific product."""

        query = """
        MATCH (p:Product {name: $product_name})
        MATCH (cd:CostData {costBehavior: 'variable'})-[:COST_FOR_PRODUCT]->(p)
        RETURN SUM(cd.amount) AS variableCost
        """
        result = self.execute_query(query, {"product_name": product_name})
        if not result:
            return 0.0
        value = result[0].get("variableCost")
        return float(value or 0.0)



    def get_average_cost_per_kg(self) -> float:
        """Return the weighted average cost per kilogram across all products."""

        query = """
        MATCH (cd:CostData)-[:COST_FOR_PRODUCT]->(p:Product)
        MATCH (cd)-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
        MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp)
        WITH SUM(cd.amount) AS totalCosts, SUM(vd.volume) AS totalVolume
        RETURN CASE WHEN totalVolume = 0 THEN 0 ELSE totalCosts / totalVolume END AS avgCostPerKg
        """
        data = self.execute_query(query)
        return float(data[0]["avgCostPerKg"] or 0.0) if data else 0.0


    def get_variable_cost_timeseries(self) -> List[Dict[str, Any]]:
        """Return monthly variable costs grouped by product."""

        query = """
        MATCH (cd:CostData {costBehavior: 'variable'})-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
        RETURN p.name AS product,
               tp.year AS year,
               tp.month AS month,
               SUM(cd.amount) AS cost
        ORDER BY year, month, product
        """
        result = self.execute_query(query)

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "product": row.get("product"),
                    "year": int(row.get("year") or 0),
                    "month": int(row.get("month") or 0),
                    "cost": float(row.get("cost") or 0.0),
                }
            )
        return records


    def get_fixed_cost_timeseries(self) -> List[Dict[str, Any]]:
        """Return monthly fixed costs grouped by cost structure."""

        query = """
        MATCH (cd:CostData {costBehavior: 'fixed'})-[:INCURRED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (cd)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
        RETURN cs.name AS category,
               tp.year AS year,
               tp.month AS month,
               SUM(cd.amount) AS cost
        ORDER BY year, month, category
        """
        result = self.execute_query(query)

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "category": row.get("category"),
                    "year": int(row.get("year") or 0),
                    "month": int(row.get("month") or 0),
                    "cost": float(row.get("cost") or 0.0),
                }
            )
        return records


    def get_cost_totals_by_behavior(self) -> Dict[str, float]:
        """Return aggregated totals for variable and fixed costs."""

        query = """
        MATCH (cd:CostData)
        RETURN cd.costBehavior AS behavior, SUM(cd.amount) AS total
        """
        result = self.execute_query(query)
        totals: Dict[str, float] = {"variable": 0.0, "fixed": 0.0}
        for row in result:
            behavior = (row.get("behavior") or "").lower()
            if behavior in totals:
                totals[behavior] = float(row.get("total") or 0.0)
        return totals

    def get_cost_totals_by_category(self) -> List[Dict[str, Any]]:
        """Return aggregated cost totals per cost structure."""

        query = """
        MATCH (cd:CostData)-[:COST_FOR_STRUCTURE]->(cs:CostStructure)
        OPTIONAL MATCH (cd)-[:COST_FOR_PRODUCT]->(p:Product)
        RETURN cs.name AS category,
               SUM(cd.amount) AS totalCost,
               CASE WHEN EXISTS((cd)-[:COST_FOR_PRODUCT]->(:Product))
            OR cd.costBehavior = 'variable'
       THEN 'variable'
       ELSE 'fixed'
       END AS behavior
        """

        result = self.execute_query(query)

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "category": row.get("category"),
                    "total_cost": float(row.get("totalCost") or 0.0),
                    "behavior": (row.get("behavior") or "").lower(),
                }
            )

        return records


    def get_product_metrics(self) -> List[Dict[str, Any]]:
        """Get metrics for all products"""

        query = """
        MATCH (p:Product)
        OPTIONAL MATCH (rs:RevenueStream)-[:SELLS_PRODUCT]->(p)
        OPTIONAL MATCH (rs)-[:HAS_VOLUME_DATA]->(vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod)
        OPTIONAL MATCH (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
        WITH p.name as Product,
             SUM(vd.volume * pd.price) as TotalRevenue,
             SUM(vd.volume) as TotalVolume,
             CASE WHEN SUM(vd.volume) = 0 THEN null ELSE SUM(vd.volume * pd.price) / SUM(vd.volume) END as AvgPrice
        RETURN Product,
               TotalRevenue,
               TotalVolume,
               AvgPrice
        ORDER BY TotalRevenue DESC
        """
        rows = self.execute_query(query)

        processed: List[Dict[str, Any]] = []
        for row in rows:
            processed.append(
                {
                    "Product": row.get("Product", ""),
                    "TotalRevenue": float(row.get("TotalRevenue") or 0.0),
                    "TotalVolume": float(row.get("TotalVolume") or 0.0),
                    "AvgPrice": float(row.get("AvgPrice") or 0.0),
                }
            )
        return processed
    def get_product_monthly_performance(self) -> List[Dict[str, Any]]:
        """Return monthly revenue and volume for each product."""

        query = """
        MATCH (p:Product)
        MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
        MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
        MATCH (pd)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp2:TimePeriod)
        WHERE tp.id = tp2.id
        WITH p.name AS Product,
             tp.year AS Year,
             tp.month AS Month,
             SUM(pd.price * vd.volume) AS MonthlyRevenue,
             SUM(vd.volume) AS MonthlyVolume
        RETURN Product, Year, Month, MonthlyRevenue, MonthlyVolume
        ORDER BY Year, Month, Product
        """
        result = self.execute_query(query)

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "product": row["Product"],
                    "year": int(row["Year"]),
                    "month": int(row["Month"]),
                    "revenue": float(row["MonthlyRevenue"] or 0.0),
                    "volume": float(row["MonthlyVolume"] or 0.0),
                }
            )

        return records
    def get_revenue_timeseries(self) -> List[Dict[str, Any]]:
        """Return monthly revenue per product."""

        query = """
        MATCH (p:Product)
        MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
        MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
        MATCH (pd)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp2:TimePeriod)
        WHERE tp.id = tp2.id
        WITH p.name AS Product, tp.year AS Year, tp.month AS Month, SUM(pd.price * vd.volume) AS MonthlyRevenue
        RETURN Product, Year, Month, MonthlyRevenue
        ORDER BY Year, Month, Product
        """
        result = self.execute_query(query)

        formatted: List[Dict[str, Any]] = []
        for row in result:
            formatted.append(
                {
                    "product": row["Product"],
                    "year": int(row["Year"]),
                    "month": int(row["Month"]),
                    "revenue": float(row["MonthlyRevenue"] or 0.0),
                }
            )

        return formatted

    def get_quarterly_revenue(self) -> List[Dict[str, Any]]:
        """Return quarterly revenue grouped by product."""

        query = """
        MATCH (p:Product)
        MATCH (pd:PriceData)-[:PRICE_FOR_PRODUCT]->(p)
        MATCH (vd:VolumeData)-[:VOLUME_FOR_PRODUCT]->(p)
        MATCH (pd)-[:PRICED_IN_PERIOD]->(tp:TimePeriod)
        MATCH (vd)-[:OCCURS_IN_PERIOD]->(tp2:TimePeriod)
        WHERE tp.id = tp2.id
        WITH p.name AS Product,
             tp.year AS Year,
             tp.quarter AS Quarter,
             SUM(pd.price * vd.volume) AS QuarterlyRevenue
        RETURN Product, Year, Quarter, QuarterlyRevenue
        ORDER BY Year, Quarter, Product
        """
        result = self.execute_query(query)

        records: List[Dict[str, Any]] = []
        for row in result:
            records.append(
                {
                    "product": row["Product"],
                    "year": int(row["Year"]),
                    "quarter": _parse_quarter_value(row.get("Quarter")),
                    "revenue": float(row["QuarterlyRevenue"] or 0.0),
                }
            )

        return records
    # Housekeeping ------------------------------------------------------
    def get_connection_status(self) -> Dict[str, Any]:
        return {
            "connected": self.connected,
            "error_message": self.error_message,
            "database_uri": NEO4J_CONFIG.uri,
            "database_name": NEO4J_CONFIG.database,
        }

    def close(self) -> None:
        if self._driver is not None:
            self._driver.close()
            logger.info("Closed Neo4j connection")


# ------------------------------------------------------------------
def _parse_quarter_value(raw) -> int:
    """Convert quarter values like "Q3" or 3 to an integer."""

    if raw is None:
        return 0
    if isinstance(raw, int):
        return raw
    if isinstance(raw, str):
        digits = ''.join(ch for ch in raw if ch.isdigit())
        return int(digits) if digits else 0
    try:
        return int(raw)
    except (TypeError, ValueError):
        return 0


@lru_cache(maxsize=1)
def get_connection() -> Neo4jConnection:
    """Return a cached connection instance."""

    connection = Neo4jConnection()
    return connection


def close_connection() -> None:
    connection = get_connection()
    connection.close()
    get_connection.cache_clear()


__all__ = [
    "Neo4jConnection",
    "get_connection",
    "close_connection",
]
