{{ config(materialized='table') }}

select
    us_state as state,
    count() as total_transactions,
    sum(target) as fraud_transactions,
    sum(target) / count() * 100 as fraud_rate,
    uniq(concat(name_1, '-', name_2)) as unique_customers,
    uniq(merch) as unique_merchants,
    sum(amount) as total_amount
from {{ ref('stg_transactions') }}
group by state
order by fraud_rate desc
