/*
    Netflix Data Exploration & Insights:
    This script analyzes content from the 'netflix_titles' table to solve 15 business questions, 
    such as content type distribution, ratings trends, director/actor appearances, and regional insights.
*/

-- ═══════════════════════════════════════════════════════════════════════
-- View the full dataset
-- ═══════════════════════════════════════════════════════════════════════
SELECT *
FROM dbo.netflix_titles;


-- ═══════════════════════════════════════════════════════════════════════
-- 1. Count the number of Movies vs TV Shows
-- ═══════════════════════════════════════════════════════════════════════
SELECT 
    [type],
    COUNT(*) AS total_content
FROM netflix_titles
GROUP BY [type];


-- ═══════════════════════════════════════════════════════════════════════
-- 2. Most common rating for Movies and TV Shows
-- ═══════════════════════════════════════════════════════════════════════
WITH RatingCounts AS (
    SELECT
        [type],
        rating,
        COUNT(*) AS rating_count
    FROM netflix_titles
    GROUP BY [type], rating
),
RankingCounts AS (
    SELECT
        [type],
        rating,
        rating_count,
        RANK() OVER (PARTITION BY [type] ORDER BY rating_count DESC) AS rn
    FROM RatingCounts
)
SELECT *
FROM RankingCounts
WHERE rn = 1;


-- ═══════════════════════════════════════════════════════════════════════
-- 3. List all Movies released in a specific year (e.g., 2020)
-- ═══════════════════════════════════════════════════════════════════════
SELECT 
    title,
    release_year
FROM netflix_titles
WHERE release_year = 2020
  AND [type] = 'Movie';


-- ═══════════════════════════════════════════════════════════════════════
-- 4. Top 5 countries with the most content
-- ═══════════════════════════════════════════════════════════════════════
WITH CountrySplit AS (
    SELECT 
        TRIM(value) AS country
    FROM netflix_titles
    CROSS APPLY STRING_SPLIT(country, ',')
    WHERE value <> ''
)
SELECT TOP 5
    country,
    COUNT(*) AS content_count
FROM CountrySplit
GROUP BY country
ORDER BY content_count DESC;


-- ═══════════════════════════════════════════════════════════════════════
-- 5. Identify the longest movie
-- ═══════════════════════════════════════════════════════════════════════
SELECT *
FROM netflix_titles
WHERE type = 'Movie'
  AND duration = (
        SELECT MAX(duration)
        FROM netflix_titles
        WHERE type = 'Movie'
    );


-- ═══════════════════════════════════════════════════════════════════════
-- 6. Content added in the last 5 years
-- ═══════════════════════════════════════════════════════════════════════
SELECT 
    title,
    [type] AS content_type,
    release_year
FROM netflix_titles
WHERE date_added >= DATEADD(YEAR, -5, CAST(GETDATE() AS DATE))
ORDER BY date_added DESC;


-- ═══════════════════════════════════════════════════════════════════════
-- 7. All content by Director 'Rajiv Chilaka'
-- ═══════════════════════════════════════════════════════════════════════
SELECT *
FROM (
    SELECT 
        [type],
        title,
        TRIM(value) AS director_name
    FROM netflix_titles
    CROSS APPLY STRING_SPLIT(director, ',')
    WHERE value <> ''
) AS T
WHERE director_name = 'Rajiv Chilaka';


-- ═══════════════════════════════════════════════════════════════════════
-- 8. List all TV shows with more than 5 seasons
-- ═══════════════════════════════════════════════════════════════════════
SELECT *
FROM (
    SELECT 
        [type],
        LEFT(duration, 2) AS seasons
    FROM netflix_titles
) AS T
WHERE [type] = 'TV Show'
  AND TRY_CAST(seasons AS INT) > 5
ORDER BY seasons ASC;


-- ═══════════════════════════════════════════════════════════════════════
-- 9. Count number of content items per genre
-- ═══════════════════════════════════════════════════════════════════════
SELECT 
    TRIM(value) AS genre,
    COUNT(*) AS total
FROM netflix_titles
CROSS APPLY STRING_SPLIT(listed_in, ',')
GROUP BY value
ORDER BY total DESC;


-- ═══════════════════════════════════════════════════════════════════════
-- 10. Top 5 years with highest number of content released in India
-- ═══════════════════════════════════════════════════════════════════════
SELECT TOP 5
    release_year,
    COUNT(*) AS total_per_year
FROM netflix_titles
CROSS APPLY STRING_SPLIT(country, ',')
WHERE value = 'India'
GROUP BY release_year
ORDER BY total_per_year DESC;


-- ═══════════════════════════════════════════════════════════════════════
-- 11. List all Movies that are Documentaries
-- ═══════════════════════════════════════════════════════════════════════
SELECT *
FROM netflix_titles
WHERE listed_in LIKE '%Documentaries%';


-- ═══════════════════════════════════════════════════════════════════════
-- 12. Content with no listed Director
-- ═══════════════════════════════════════════════════════════════════════
SELECT *
FROM netflix_titles
WHERE director IS NULL;


-- ═══════════════════════════════════════════════════════════════════════
-- 13. Movies with 'Salman Khan' in the last 10 years
-- ═══════════════════════════════════════════════════════════════════════
DECLARE @CurrentYear INT = YEAR(GETDATE());

SELECT 
    title,
    [type],
    release_year,
    value AS actor
FROM netflix_titles
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE value = 'Salman Khan'
  AND release_year >= @CurrentYear - 10;


-- ═══════════════════════════════════════════════════════════════════════
-- 14. Top 10 actors in most Indian-produced movies
-- ═══════════════════════════════════════════════════════════════════════
SELECT TOP 10
    value AS actor,
    COUNT(*) AS movie_count
FROM netflix_titles
CROSS APPLY STRING_SPLIT(cast, ',')
WHERE country = 'India'
GROUP BY value
ORDER BY movie_count DESC;


-- ═══════════════════════════════════════════════════════════════════════
-- 15. Categorize content by presence of 'kill' or 'violence'
-- ═══════════════════════════════════════════════════════════════════════
SELECT 
    category,
    COUNT(*) AS content_count
FROM (
    SELECT 
        CASE 
            WHEN description LIKE '%kill%' OR description LIKE '%violence%' 
                THEN 'Not_for_children'
            ELSE 'Good_for_children'
        END AS category
    FROM netflix_titles
) AS T
GROUP BY category;

--THE END