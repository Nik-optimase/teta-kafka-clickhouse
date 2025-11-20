CREATE DATABASE IF NOT EXISTS teta;

DROP TABLE IF EXISTS teta.transactions_kafka;
DROP TABLE IF EXISTS teta.transactions_raw;

CREATE TABLE teta.transactions_kafka
(
    id UInt64,
    state String,
    category String,
    amount Float64
)
ENGINE = Kafka
SETTINGS
    kafka_broker_list = 'kafka:9092',
    kafka_topic_list = 'teta_transactions',
    kafka_group_name = 'teta_clickhouse_group',
    kafka_format = 'CSV',
    kafka_row_delimiter = '\n';

CREATE TABLE teta.transactions_raw
(
    id UInt64,
    state String,
    category String,
    amount Float64
)
ENGINE = MergeTree
ORDER BY id;

CREATE MATERIALIZED VIEW teta.mv_transactions_raw
TO teta.transactions_raw
AS
SELECT
    id,
    state,
    category,
    amount
FROM teta.transactions_kafka;
