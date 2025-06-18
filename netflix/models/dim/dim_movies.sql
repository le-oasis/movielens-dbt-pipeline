-- models/marts/dim_movies.sql
-- Fixed movies dimension table

{{ config(materialized='table') }}

with stg_movies as (
    select * from {{ ref('stg_movies') }}
)

select
    movieId,
    initcap(trim(title)) as movie_title,
    split(genres, '|') as genre_array,
    genres,
    current_timestamp() as created_at
from stg_movies