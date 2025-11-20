# TETA ML 1 2025 — Kafka to ClickHouse

This project demonstrates streaming data from a CSV file into a Kafka topic and ingesting it into ClickHouse for analytical queries.

## Contents

- `docker-compose.yml` — brings up Kafka (with Zookeeper) and ClickHouse.
- `kafka_producer.py` — Python script to stream rows of `train.csv` to Kafka.
- `sql/` — SQL DDL and query scripts.
- `data/` — put your `train.csv` file here (not tracked in git).
- `results/` — stores query results such as CSV output.

## Setup

### Prerequisites

- Docker and docker-compose installed.
- Python 3.10+ with `kafka-python` installed (use `requirements.txt`).
- Download `train.csv` from [Kaggle dataset](https://www.kaggle.com/competitions/teta-ml-1-2025/data?select=train.csv) and place it under `data/train.csv`.

### Running services

Start the Kafka and ClickHouse stack:

```bash
docker-compose up -d
```

This brings up Zookeeper, Kafka (accessible on host at `localhost:29092`), and ClickHouse (HTTP interface on `localhost:8123`).

### Create ClickHouse tables

After services are up, create the ClickHouse database and tables. You can choose between the base and optimized schemas.

Run the base DDL (simple `MergeTree` table):

```bash
docker exec -it <clickhouse-container-name> \
  clickhouse-client --queries-file=/sql/01_ddl_base.sql
```

For improved query performance, you can instead use the optimized schema:

```bash
docker exec -it <clickhouse-container-name> \
  clickhouse-client --queries-file=/sql/02_ddl_optimized.sql
```

Replace `<clickhouse-container-name>` with the name of your ClickHouse container (check with `docker ps`).

### Stream data from CSV into Kafka

Create a virtual environment and install dependencies:

```bash
python -m venv .venv
source .venv/bin/activate   # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Export environment variables and run the producer:

```bash
export KAFKA_BOOTSTRAP_SERVERS=localhost:29092
export KAFKA_TOPIC=teta_transactions
export CSV_PATH=data/train.csv

python kafka_producer.py
```

This reads each row of `train.csv` and publishes it as a message to Kafka. The materialized view in ClickHouse consumes these messages and populates the `transactions_raw` or `transactions_optimized` table.

### Verify data ingestion

To verify that rows have been ingested, run:

```bash
docker exec -it <clickhouse-container-name> \
  clickhouse-client -q "SELECT count() FROM teta.transactions_optimized"
```

(Replace the table name with `transactions_raw` if you used the base schema.)

### Run analytical query

The script `sql/03_max_tx_category_by_state.sql` finds, for each state, the category of the largest transaction and its amount. To execute and dump results to CSV:

```bash
docker exec -i <clickhouse-container-name> \
  clickhouse-client --queries-file=/sql/03_max_tx_category_by_state.sql \
  > results/max_tx_category_by_state.csv
```

The resulting CSV will be saved under `results/`.

## Notes

- Adjust the column definitions in `01_ddl_base.sql` and `02_ddl_optimized.sql` to match the exact structure of `train.csv` (column names and data types).
- The optimized schema uses `LowCardinality` strings, partitions by `state`, and orders by `(state, amount DESC)` for faster aggregation queries.
