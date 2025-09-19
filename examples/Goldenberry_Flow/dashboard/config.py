"""
Configuration file for Goldenberry Flow Revenue Dashboard
Contains database credentials and connection settings
"""

# Neo4j Database Configuration
NEO4J_CONFIG = {
    "uri": "neo4j://127.0.0.1:7687",
    "username": "neo4j",
    "password": "12345678",
    "database": "neo4j"  # default database
}

# Connection Settings
CONNECTION_SETTINGS = {
    "max_connection_lifetime": 3600,  # 1 hour
    "max_connection_pool_size": 50,
    "connection_acquisition_timeout": 60,  # 60 seconds
    "connection_timeout": 30,  # 30 seconds
    "max_retry_time": 30
}