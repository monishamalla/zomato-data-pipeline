select 
customer_id,
customer_name,
email,
age,
case when age<25 then 'GenZ'
    when age>=25 and age<40 then 'Millennial'
    when age>=40 and age<55 then 'GenX'
    when age is null then 'Unknown'
    else 'Boomer' end as age_segment,
gender,
marital_status, 
occupation,
income_band,
education,
family_size
from {{ ref('stg_users') }}
    