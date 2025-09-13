

with raw as (
    select *
    from "postgres"."public"."symbols_ref"
),

clean as (
    select
        upper(platform) as platform,
        upper(platform_symbol) as platform_symbol,
        upper(std_symbol) as std_symbol,
        coalesce(asset_class, 'UNKNOWN') as asset_class,
        upper(quote_currency) as quote_currency,
        coalesce(tick_value, 0) as tick_value
    from raw
    where platform_symbol is not null
)

select *
from clean