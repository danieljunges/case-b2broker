
  
    

  create  table "postgres"."public"."dim_symbol__dbt_tmp"
  
  
    as
  
  (
    

with base as (
    select
        platform,
        platform_symbol,
        upper(std_symbol) as std_symbol,
        upper(asset_class) as asset_class,
        upper(quote_currency) as quote_currency,
        tick_value
    from "postgres"."public"."stg_symbols"
    where platform_symbol is not null
),

deduplicated as (
    select distinct *
    from base
)

select
    md5(cast(coalesce(cast(platform as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(platform_symbol as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as symbol_sk,
    platform,
    platform_symbol,
    std_symbol,
    asset_class,
    quote_currency,
    tick_value,
    current_timestamp as load_ts
from deduplicated
  );
  