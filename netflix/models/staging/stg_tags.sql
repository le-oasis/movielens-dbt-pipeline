{{ config(materialized='view') }}

with raw_tags AS (
    select * from {{ source('movielens_staging', 'tags_staging') }}
)

select 
    userId AS user_id,
    movieId AS movie_id,
    tag,
    timestamp_seconds(timestamp) as tag_timestamp,
from raw_tags