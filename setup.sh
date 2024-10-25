#!/bin/bash

# Create directories
mkdir -p postgres-data

# Start all services
docker-compose up -d

echo "Waiting for services to start..."
sleep 30

# Create Debezium connector
curl -X POST http://localhost:8083/connectors -H "Content-Type: application/json" -d '{
    "name": "postgres-connector",
    "config": {
        "connector.class": "io.debezium.connector.postgresql.PostgresConnector",
        "database.hostname": "postgres",
        "database.port": "5432",
        "database.user": "postgres",
        "database.password": "postgres123",
        "database.dbname": "testdb",
        "database.server.name": "postgres",
        "table.include.list": "public.users",
        "topic.prefix": "postgres-users",
        "transforms": "route",
        "transforms.route.type": "org.apache.kafka.connect.transforms.RegexRouter",
        "transforms.route.regex": "([^.]+)\\.([^.]+)\\.([^.]+)",
        "transforms.route.replacement": "postgres-users-cdc",
        "plugin.name": "pgoutput"
    }
}'

echo "Setup complete! You can now test the CDC pipeline."