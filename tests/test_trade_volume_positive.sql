select *
from {{ ref('fact_trades') }}
where volume <= 0
