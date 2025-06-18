{{ config(materialized='view') }}

with raw_movies as (
    select * from {{ source('movielens_staging', 'movies_staging') }}
)

select 
    movieId,
    title,
    genres
from raw_movies
where movieId is not null