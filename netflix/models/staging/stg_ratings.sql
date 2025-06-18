{{ config(materialized='view') }}

with raw_ratings AS (
    select * from {{ source('movielens_staging', 'ratings_staging') }}
)

select 
    userId AS user_id, 
    movieId, 
    rating, 
    timestamp_seconds(timestamp) as rating_timestamp,
from raw_ratings
where movieId is not null