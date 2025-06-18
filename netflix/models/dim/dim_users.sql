-- models/marts/dim_users.sql
-- Fixed users dimension table

{{ config(materialized='table') }}

with ratings_users as (
    select distinct user_id from {{ ref('stg_ratings') }}
),

tags_users as (
    select distinct user_id from {{ ref('stg_tags') }}
),

all_users as (
    select user_id from ratings_users
    union distinct
    select user_id from tags_users
)

select 
    user_id,
    current_timestamp() as created_at
from all_users
order by user_id