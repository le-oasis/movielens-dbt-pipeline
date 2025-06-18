-- Most relevant tags for a specific movie
SELECT 
    t.tag_name, 
    f.relevance, 
    f.relevance_category,
    m.movie_title
FROM {{ ref('fct_genome_scores') }} f
JOIN {{ ref('dim_genome_tags') }} t ON f.tag_id = t.tag_id
JOIN {{ ref('dim_movies') }} m ON f.movie_id = m.movieId
WHERE m.movie_title LIKE '%Toy Story%'
ORDER BY f.relevance DESC

