
    
    

select
    client_sk as unique_field,
    count(*) as n_records

from "postgres"."public"."dim_client"
where client_sk is not null
group by client_sk
having count(*) > 1


