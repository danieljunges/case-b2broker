{{ config(materialized='table') }}

with base as (
    select
        platform,
        platform_symbol,
        upper(std_symbol) as std_symbol,
        upper(asset_class) as asset_class,
        upper(quote_currency) as quote_currency,
        tick_value
    from {{ ref('stg_symbols') }}
    where platform_symbol is not null
),

deduplicated as (
    select distinct *
    from base
)

select
    {{ dbt_utils.generate_surrogate_key(['platform', 'platform_symbol']) }} as symbol_sk,
    platform,
    platform_symbol,
    std_symbol,
    asset_class,
    quote_currency,
    tick_value,
    current_timestamp as load_ts
from deduplicated
