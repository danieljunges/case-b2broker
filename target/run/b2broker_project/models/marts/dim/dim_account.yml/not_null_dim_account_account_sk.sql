
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select account_sk
from "postgres"."public"."dim_account"
where account_sk is null



  
  
      
    ) dbt_internal_test