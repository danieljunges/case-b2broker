
  create view "postgres"."public"."stg_clients__dbt_tmp"
    
    
  as (
    

with raw as (
    select *
    from "postgres"."public"."clients_raw"
),

clean as (
    select
        client_id,
        client_external_id,
        upper(jurisdiction) as jurisdiction,
        lower(segment) as segment,
        created_at
    from raw
    where client_id is not null
)

select *
from clean
  );