{{ config(materialized='view') }}

with raw_genome_tags AS (
    select * from {{ source('movielens_staging', 'genome_tags_staging') }}
)

select 
    tagId AS tag_id,
    tag
from raw_genome_tags