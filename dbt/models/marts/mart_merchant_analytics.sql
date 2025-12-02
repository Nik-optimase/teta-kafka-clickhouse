{{ config(materialized='table') }}

select
    merch as merchant,
    count(*) as total_transactions,
    countIf(target = 1) as fraud_transactions,
    100.0 * countIf(target = 1) / count() as fraud_rate,
    sum(amount) as total_amount,
    avg(amount) as avg_amount,
    max(amount) as max_amount,
    if(100.0 * countIf(target = 1) / count() >= 5 OR avg(amount) >= 500, 1, 0) as suspicious_flag
from {{ ref('stg_transactions') }}
group by merch
order by fraud_rate desc;
