
  
    

  create  table "postgres"."public"."dim_client__dbt_tmp"
  
  
    as
  
  (
    

with base as (

    select
        client_id,
        client_external_id,
        upper(jurisdiction) as jurisdiction,
        initcap(segment) as segment,
        created_at

    from "postgres"."public"."stg_clients"
    where client_id is not null

),

deduplicated as (

    select distinct *
    from base

)

select
    md5(cast(coalesce(cast(client_id as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as client_sk,
    client_id,
    client_external_id,
    jurisdiction,
    segment,
    created_at,
    current_timestamp as load_ts

from deduplicated
  );
  