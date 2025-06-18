-- Top movies for a specific tag
SELECT 
    m.movie_title, 
    f.relevance, 
    f.relevance_category,
    t.tag_name
FROM {{ ref('fct_genome_scores') }} f
JOIN {{ ref('dim_movies') }} m ON f.movie_id = m.movieId
JOIN {{ ref('dim_genome_tags') }} t ON f.tag_id = t.tag_id
WHERE t.tag_name LIKE '%Action%'
ORDER BY f.relevance DESC

