DROP TABLE IF EXISTS teta.transactions_optimized;
DROP TABLE IF EXISTS teta.mv_transactions_optimized;

CREATE TABLE teta.transactions_optimized
(
    id UInt64,
    state LowCardinality(String),
    category LowCardinality(String),
    amount Float64
)
ENGINE = MergeTree
PARTITION BY state
ORDER BY (state, amount DESC);

CREATE MATERIALIZED VIEW teta.mv_transactions_optimized
TO teta.transactions_optimized
AS
SELECT
    id,
    state,
    category,
    amount
FROM teta.transactions_kafka;
