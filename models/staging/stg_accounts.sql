{{ config(materialized='view') }}

with raw as (
    select *
    from {{ ref('accounts_raw') }}
),

clean as (
    select
        account_id,
        platform,
        client_id,
        upper(base_currency) as base_currency,
        created_at,
        closed_at,
        salesforce_account_id,
        is_system,
        is_deleted,
        case 
            when is_deleted then 'deleted'
            when is_system then 'system'
            when closed_at is not null then 'closed'
            else 'active'
        end as account_status
    from raw
    where account_id is not null
)

select *
from clean
