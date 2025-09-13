

with base as (

    select
        b.account_id,
        b.platform,
        b.date,
        b.balance,
        b.equity,
        b.floating_pnl,
        b.credit,
        b.margin_level,
        a.account_sk,
        a.client_sk
    from "postgres"."public"."stg_balances_eod" b
    left join "postgres"."public"."dim_account" a
        on b.account_id = a.account_id
        and b.platform = a.platform

),

deduplicated as (

    select distinct *
    from base

)

select
    row_number() over (order by date, account_id) as account_eod_sk,
    account_sk,
    client_sk,
    account_id,
    platform,
    date,
    balance,
    equity,
    floating_pnl,
    credit,
    margin_level,
    current_timestamp as load_ts
from deduplicated