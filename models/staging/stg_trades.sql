{{ config(materialized='view') }}

select
    trim(trade_id) as trade_id,
    trim(account_id) as account_id,
    nullif(trim(client_external_id), '') as client_external_id,
    platform,
    upper(symbol) as symbol,
    case
        when side in ('B', 'BUY') then 'BUY'
        when side in ('S', 'SELL') then 'SELL'
        else upper(side)
    end as side,
    volume,
    open_time,
    close_time,
    open_price,
    close_price,
    commission,
    realized_pnl,
    book_flag,
    counterparty,
    quote_currency,
    status,
    extract(epoch from close_time - open_time)/60 as duration_minutes
from {{ ref('trades_raw') }}
