
  
    

  create  table "postgres"."public"."dim_account__dbt_tmp"
  
  
    as
  
  (
    

with base as (

    select
        trim(a.account_id) as account_id,
        trim(a.client_id) as client_id,
        trim(a.platform) as platform,
        upper(a.base_currency) as base_currency,
        a.created_at,
        a.closed_at,
        a.is_system,
        a.is_deleted
    from "postgres"."public"."stg_accounts" a
    where a.account_id is not null

),

client_linked as (
    select
        b.*,
        c.client_sk
    from base b
    left join "postgres"."public"."dim_client" c
        on b.client_id = c.client_id
),

deduplicated as (
    select distinct *
    from client_linked
)

select
    md5(cast(coalesce(cast(account_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(platform as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as account_sk,
    account_id,
    client_id,
    client_sk,
    platform,
    base_currency,
    created_at,
    closed_at,
    is_system,
    is_deleted,
    current_timestamp as load_ts

from deduplicated
  );
  