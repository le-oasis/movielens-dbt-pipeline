{{ config(materialized='view') }}

with raw_links AS (
    select * from {{ source('movielens_staging', 'links_staging') }}
)

select 
movieId AS movie_id,
imdbId AS imdb_id,
tmdbId AS tmdb_id,
from raw_links