{{ config(materialized='table') }}

with trades_base as (
    select
        t.trade_id,
        t.account_id,
        t.client_external_id,
        t.symbol,
        t.platform,
        t.side,
        t.volume,
        t.open_time,
        t.close_time,
        t.open_price,
        t.close_price,
        t.commission,
        t.realized_pnl,
        t.realized_pnl + t.commission as net_pnl,
        extract(epoch from (t.close_time - t.open_time))/60 as duration_minutes
    from {{ ref('stg_trades') }} t
    where t.trade_id is not null
      and t.account_id is not null
),

joined_dims as (
    select
        tb.trade_id,
        coalesce(c.client_sk, a.client_sk) as client_sk, 
        a.account_sk,
        s.symbol_sk,
        tb.platform,
        tb.side,
        tb.volume,
        tb.open_time,
        tb.close_time,
        tb.open_price,
        tb.close_price,
        tb.commission,
        tb.realized_pnl,
        tb.net_pnl,
        tb.duration_minutes
    from trades_base tb
    left join {{ ref('dim_client') }} c
        on tb.client_external_id = c.client_external_id
    left join {{ ref('dim_account') }} a
        on tb.account_id = a.account_id
    left join {{ ref('dim_symbol') }} s
        on tb.symbol = s.platform_symbol
),

deduplicated as (
    select *
    from (
        select *,
               row_number() over (partition by trade_id order by close_time desc) as rn
        from joined_dims
    ) t
    where rn = 1
)

select
    trade_id,
    client_sk,
    account_sk,
    symbol_sk,
    platform,
    side,
    volume,
    open_time,
    close_time,
    open_price,
    close_price,
    commission,
    realized_pnl,
    net_pnl,
    duration_minutes,
    current_timestamp as load_ts
from deduplicated
