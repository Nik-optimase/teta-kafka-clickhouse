{{ config(materialized='view') }}

with source as (
    select * 
    from {{ source('transactions_db', 'transactions') }}
)

select
    toDate(transaction_time) as transaction_date,
    toHour(transaction_time) as transaction_hour,
    toDayOfWeek(transaction_time) as day_of_week,
    transaction_time,
    merch as merchant,
    cat_id as category_id,
    amount,
    name_1 as first_name,
    name_2 as last_name,
    gender,
    us_state as state,
    lat as customer_lat,
    lon as customer_lon,
    merchant_lat,
    merchant_lon,
    target as is_fraud,
    {{ amount_bucket('amount') }} as amount_bucket
from source;
