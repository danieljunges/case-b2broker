{{ config(materialized='table') }}

with base as (

    select
        client_id,
        client_external_id,
        upper(jurisdiction) as jurisdiction,
        initcap(segment) as segment,
        created_at

    from {{ ref('stg_clients') }}
    where client_id is not null

),

deduplicated as (

    select distinct *
    from base

)

select
    {{ dbt_utils.generate_surrogate_key(['client_id']) }} as client_sk,
    client_id,
    client_external_id,
    jurisdiction,
    segment,
    created_at,
    current_timestamp as load_ts

from deduplicated
