"""
Neo4j Database Connection Handler
Handles database connections, queries, and error management
"""

from neo4j import GraphDatabase
import logging
from typing import Optional, Dict, Any, List
import sys
from pathlib import Path

# Add parent directory to path for config import
sys.path.append(str(Path(__file__).parent.parent))
from config import NEO4J_CONFIG, CONNECTION_SETTINGS

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class Neo4jConnection:
    """Neo4j database connection handler"""

    def __init__(self):
        """Initialize connection to Neo4j database"""
        self.driver = None
        self.connected = False
        self.error_message = None

        try:
            self.driver = GraphDatabase.driver(
                NEO4J_CONFIG["uri"],
                auth=(NEO4J_CONFIG["username"], NEO4J_CONFIG["password"]),
                max_connection_lifetime=CONNECTION_SETTINGS["max_connection_lifetime"],
                max_connection_pool_size=CONNECTION_SETTINGS["max_connection_pool_size"],
                connection_acquisition_timeout=CONNECTION_SETTINGS["connection_acquisition_timeout"],
                connection_timeout=CONNECTION_SETTINGS["connection_timeout"]
            )

            # Test the connection
            self._test_connection()

        except Exception as e:
            self.error_message = f"Failed to connect to Neo4j: {str(e)}"
            logger.error(self.error_message)
            self.connected = False

    def _test_connection(self):
        """Test the database connection"""
        try:
            with self.driver.session(database=NEO4J_CONFIG["database"]) as session:
                result = session.run("RETURN 1 as test")
                test_value = result.single()["test"]
                if test_value == 1:
                    self.connected = True
                    logger.info("Successfully connected to Neo4j database")
                else:
                    raise Exception("Connection test failed")
        except Exception as e:
            self.error_message = f"Connection test failed: {str(e)}"
            logger.error(self.error_message)
            self.connected = False

    def execute_query(self, query: str, parameters: Optional[Dict[str, Any]] = None) -> List[Dict[str, Any]]:
        """
        Execute a Cypher query and return results

        Args:
            query: Cypher query string
            parameters: Query parameters (optional)

        Returns:
            List of dictionaries containing query results
        """
        if not self.connected:
            raise Exception(f"Database not connected: {self.error_message}")

        try:
            with self.driver.session(database=NEO4J_CONFIG["database"]) as session:
                result = session.run(query, parameters or {})
                return [record.data() for record in result]
        except Exception as e:
            error_msg = f"Query execution failed: {str(e)}"
            logger.error(error_msg)
            raise Exception(error_msg)

    def get_product_count(self) -> int:
        """
        Get the total number of products in the database

        Returns:
            Number of products
        """
        try:
            query = "MATCH (p:Product) RETURN count(p) as product_count"
            result = self.execute_query(query)
            return result[0]["product_count"] if result else 0
        except Exception as e:
            logger.error(f"Failed to get product count: {str(e)}")
            raise

    def get_total_revenue(self) -> float:
        """
        Calculate total revenue across all revenue streams

        Returns:
            Total revenue in USD
        """
        try:
            query = """
            MATCH (rs:RevenueStream)-[:HAS_VOLUME_DATA]->(vd:VolumeData)-[:OCCURS_IN_PERIOD]->(tp:TimePeriod),
                  (rs)-[:HAS_PRICE_DATA]->(pd:PriceData)-[:PRICED_IN_PERIOD]->(tp)
            RETURN SUM(vd.volume * pd.price) as totalRevenue
            """
            result = self.execute_query(query)
            return float(result[0]["totalRevenue"]) if result and result[0]["totalRevenue"] else 0.0
        except Exception as e:
            logger.error(f"Failed to get total revenue: {str(e)}")
            raise

    def get_connection_status(self) -> Dict[str, Any]:
        """
        Get connection status information

        Returns:
            Dictionary with connection status details
        """
        return {
            "connected": self.connected,
            "error_message": self.error_message,
            "database_uri": NEO4J_CONFIG["uri"],
            "database_name": NEO4J_CONFIG["database"]
        }

    def close(self):
        """Close the database connection"""
        if self.driver:
            self.driver.close()
            logger.info("Neo4j connection closed")

# Global connection instance
_connection_instance = None

def get_connection() -> Neo4jConnection:
    """
    Get or create a global connection instance

    Returns:
        Neo4jConnection instance
    """
    global _connection_instance
    if _connection_instance is None:
        _connection_instance = Neo4jConnection()
    return _connection_instance

def close_connection():
    """Close the global connection instance"""
    global _connection_instance
    if _connection_instance:
        _connection_instance.close()
        _connection_instance = None