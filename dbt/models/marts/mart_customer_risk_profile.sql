{{ config(materialized='table') }}

with customer_stats as (
    select
        concat(name_1, ' ', name_2) as customer_name,
        count() as total_transactions,
        sum(target) as fraud_transactions,
        sum(target) / count() * 100 as fraud_rate,
        avg(amount) as avg_amount,
        sum(amount) as total_amount
    from {{ ref('stg_transactions') }}
    group by customer_name
)
select
    customer_name,
    total_transactions,
    fraud_transactions,
    fraud_rate,
    avg_amount,
    total_amount,
    case
        when fraud_rate >= 5 then 'HIGH'
        when fraud_rate >= 1 then 'MEDIUM'
        else 'LOW'
    end as risk_level
from customer_stats
order by fraud_rate desc
