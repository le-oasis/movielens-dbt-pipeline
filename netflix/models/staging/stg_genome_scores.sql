{{ config(materialized='view') }}

with raw_genome_scores AS (
    select * from {{ source('movielens_staging', 'genome_scores_staging') }}
)

select 
    movieId AS movie_id,
    tagId AS tag_id,
    relevance
from raw_genome_scores