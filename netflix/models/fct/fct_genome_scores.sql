{{ config(materialized='table') }}

with stg_genome_scores as (
    select * from {{ ref('stg_genome_scores') }}
),

enhanced_scores as (
    select 
        movie_id,
        tag_id,
        relevance,
        
        -- Categorize relevance scores
        case 
            when relevance >= 0.9 then 'Very High'
            when relevance >= 0.7 then 'High'
            when relevance >= 0.5 then 'Medium'
            when relevance >= 0.3 then 'Low'
            else 'Very Low'
        end as relevance_category,
        
        -- Create relevance buckets for analysis
        case 
            when relevance >= 0.8 then '0.8-1.0'
            when relevance >= 0.6 then '0.6-0.8'
            when relevance >= 0.4 then '0.4-0.6'
            when relevance >= 0.2 then '0.2-0.4'
            else '0.0-0.2'
        end as relevance_bucket,
        
        -- Round relevance for easier grouping
        round(relevance, 2) as relevance_rounded,
        
        -- Create percentile rank within each movie
        percent_rank() over (
            partition by movie_id 
            order by relevance
        ) as relevance_percentile_within_movie,
        
        -- Create percentile rank within each tag
        percent_rank() over (
            partition by tag_id 
            order by relevance
        ) as relevance_percentile_within_tag,
        
        -- Flag for high relevance scores
        case when relevance >= 0.7 then true else false end as is_high_relevance,
        
        -- Flag for very low relevance scores
        case when relevance <= 0.1 then true else false end as is_very_low_relevance

    from stg_genome_scores
)

select 
    -- Primary keys
    movie_id,
    tag_id,
    
    -- Core metric
    relevance,
    relevance_rounded,
    
    -- Categorizations
    relevance_category,
    relevance_bucket,
    
    -- Percentile rankings
    round(relevance_percentile_within_movie, 3) as relevance_percentile_within_movie,
    round(relevance_percentile_within_tag, 3) as relevance_percentile_within_tag,
    
    -- Flags for easy filtering
    is_high_relevance,
    is_very_low_relevance,
    
    -- Metadata
    current_timestamp() as created_at
    
from enhanced_scores
order by movie_id, relevance desc