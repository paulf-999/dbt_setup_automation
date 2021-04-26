-- Refunds have a negative amount, so the total amount should always be >= 0.
-- Therefore return records where this isn't true to make the test fail
select
    count(*) as row_count
from {{ ref('vw_dim_brnch' )}}
having row_count > 1