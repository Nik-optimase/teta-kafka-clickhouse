{{ config(materialized='table') }}

with base as (
    select
        toDate(transaction_time) as transaction_date,
        us_state as state,
        amount,
        case when amount >= 100 then 1 else 0 end as is_large
    from {{ ref('stg_transactions') }}
)
select
    transaction_date,
    state,
    count() as transaction_count,
    sum(amount) as total_amount,
    avg(amount) as avg_amount,
    quantileExact(0.95)(amount) as p95_amount,
    sum(is_large) / count() as large_transaction_share
from base
group by transaction_date, state
order by transaction_date, state
