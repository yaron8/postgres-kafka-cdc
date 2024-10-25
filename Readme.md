# CDC with Debezium, PostgreSQL, Kafka, and Redpanda

This project demonstrates a Change Data Capture (CDC) setup using [Debezium](https://debezium.io/) with PostgreSQL, Kafka, and Redpanda. 

The CDC system captures changes in a PostgreSQL database and publishes them to a Kafka topic (`postgres-users-cdc`).

## Project Structure

- **docker-compose.yml**: Defines services for PostgreSQL, Kafka, Debezium Kafka Connect, Redpanda Console, and Zookeeper.
- **init.sql**: SQL file for initializing PostgreSQL with a `users` table.
- **setup.sh**: Script to start all services via Docker Compose.

## Getting Started

### Run the project:

    Before running `setup.sh`, ensure it has executable permissions:
   ```bash
   chmod +x setup.sh
   ```

   Start the Docker Compose services by running:
   ```bash
   ./setup.sh
   ```

   This script launches PostgreSQL (initialize db and tables using `init.sql`), Kafka, Debezium Kafka Connect, Zookeeper, and Redpanda Console services.

### init.sql Changes:

If you made a change on `init.sql`, you must delete postgres data volume:
```bash
docker-compose down

rm -rf postgres-data
```

Then, start the prject again:
```bash
./setup.sh
```


## Accessing Services

### Redpanda Console: 
Access the Kafka data at [http://localhost:8080](http://localhost:8080).

### Kafka Connect: 
Available on [http://localhost:8083](http://localhost:8083) for connector management.

### Postgres:
Connect to Postgres from terminal:
```bash
docker exec -it postgres psql -U postgres -d testdb

select * from users;
```

## Database Initialization

The `init.sql` file initializes the PostgreSQL database with a `users` table. This file is automatically executed when the PostgreSQL container starts, creating the table structure required for capturing data changes.

## Enable Topic Compaction

Please be aware that compaction may not good for db synchronization.

To enalble compaction on `postgres-users-cdc` topic:

```bash
docker exec kafka kafka-configs --bootstrap-server kafka:29092 \
    --entity-type topics \
    --entity-name postgres-users-cdc \
    --alter \
    --add-config cleanup.policy=compact,segment.ms=1000,min.cleanable.dirty.ratio=0.001,delete.retention.ms=1000
```

## Modifying Configurations

- **PostgreSQL CDC Settings**: The `docker-compose.yml` configures PostgreSQL with `wal_level=logical` to enable CDC through logical replication.
- **Kafka Topics**: Changes in the `users` table are published to the `postgres-users-cdc` Kafka topic.

## Notes

- Ensure Docker is running on your system.
- Modify configurations in `docker-compose.yml` if needed (e.g., ports, database credentials).

## Stopping Services

To stop all services, run:
```bash
docker-compose down
```

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
