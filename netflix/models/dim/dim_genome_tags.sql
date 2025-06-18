-- models/marts/dim_genome_tags.sql
-- Fixed genome tags dimension table

{{ config(materialized='table') }}

with stg_genome_tags as (
    select * from {{ ref('stg_genome_tags') }}
)

select 
    tag_id as tag_id,
    initcap(trim(tag)) as tag_name,
    lower(trim(tag)) as tag_name_lower,
    current_timestamp() as created_at
from stg_genome_tags
order by tag_id