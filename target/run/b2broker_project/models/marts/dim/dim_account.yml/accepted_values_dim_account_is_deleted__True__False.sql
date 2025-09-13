
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        is_deleted as value_field,
        count(*) as n_records

    from "postgres"."public"."dim_account"
    group by is_deleted

)

select *
from all_values
where value_field not in (
    'True','False'
)



  
  
      
    ) dbt_internal_test