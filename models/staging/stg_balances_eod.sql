{{ config(materialized='view') }}

with raw as (
    select *
    from {{ ref('balances_eod_raw') }}
),

clean as (
    select
        account_id,
        upper(platform) as platform,
        date,
        coalesce(balance, 0) as balance,
        coalesce(equity, 0) as equity,
        coalesce(floating_pnl, 0) as floating_pnl,
        coalesce(credit, 0) as credit,
        coalesce(margin_level, 0) as margin_level
    from raw
    where account_id is not null
)

select *
from clean
