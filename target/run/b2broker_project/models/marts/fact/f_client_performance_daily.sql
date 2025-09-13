
  
    

  create  table "postgres"."public"."f_client_performance_daily__dbt_tmp"
  
  
    as
  
  (
    

with trades as (

    select
        t.trade_id,
        a.account_sk,
        c.client_sk,
        s.symbol_sk,
        t.volume,
        t.realized_pnl,
        t.commission,
        t.open_time::date as trade_date
    from "postgres"."public"."stg_trades" t
    left join "postgres"."public"."dim_account" a
        on t.account_id = a.account_id
    left join "postgres"."public"."dim_client" c
        on a.client_id = c.client_id
    left join "postgres"."public"."dim_symbol" s
        on t.symbol = s.std_symbol
),

agg as (

    select
        trade_date,
        client_sk,
        account_sk,
        sum(realized_pnl + commission) as net_pnl,
        count(trade_id) as num_trades,
        avg(volume) as avg_volume
    from trades
    group by 1,2,3
)

select
    trade_date,
    client_sk,
    account_sk,
    net_pnl,
    num_trades,
    avg_volume,
    current_timestamp as load_ts
from agg
  );
  