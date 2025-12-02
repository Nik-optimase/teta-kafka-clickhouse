{{ config(materialized='table') }}

select
    cat_id as category,
    count() as total_transactions,
    sum(target) as fraud_transactions,
    sum(target) / count() * 100 as fraud_rate,
    sum(amount) as total_amount,
    avg(amount) as avg_amount
from {{ ref('stg_transactions') }}
group by category
order by fraud_rate desc
