
    
    

select
    account_sk as unique_field,
    count(*) as n_records

from "postgres"."public"."dim_account"
where account_sk is not null
group by account_sk
having count(*) > 1


