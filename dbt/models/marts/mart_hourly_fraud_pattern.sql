{{ config(materialized='table') }}

select
    day_of_week,
    transaction_hour,
    count(*) as total_transactions,
    countIf(target = 1) as fraud_transactions,
    100.0 * countIf(target = 1) / count() as fraud_rate,
    sum(amount) as total_amount,
    avg(amount) as avg_amount
from {{ ref('stg_transactions') }}
group by day_of_week, transaction_hour
order by fraud_rate desc;
