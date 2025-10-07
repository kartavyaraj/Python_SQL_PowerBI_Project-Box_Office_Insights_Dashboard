-- Creating Table

CREATE TABLE movies (
    Rank INT,
    Movie VARCHAR(200),
    Worldwide_Revenue BIGINT,
    Domestic_Revenue INT,
    Domestic_Share NUMERIC(5,2),
    Foreign_Revenue INT,
    Foreign_Share NUMERIC(5,2),
    Year INT,
    Genres VARCHAR(20),
    Rating NUMERIC(3,1),
    Vote_Count INT,
    Original_Language VARCHAR(20),
    Production_Countries VARCHAR(25),
    Performance VARCHAR(20),
    Rating_Category VARCHAR(20),
    Vote_Category VARCHAR(20)
);

-------------------------------------------------------------------------------------------

--1) Top 10 Performing Movies by Revenue (Worldwide)
SELECT 
	DISTINCT movie,
	ROUND(worldwide_revenue/1000000000.,2) as worldwide_revenue_b
FROM movies
ORDER BY worldwide_revenue_b DESC
LIMIT 10;

-------------------------------------------------------------------------------------------

--2) Top 10 Performing Movies by Revenue (Domestic)
SELECT 
	DISTINCT movie,
	domestic_revenue / 1000000 as domestic_revenue_m
FROM movies
ORDER BY domestic_revenue_m DESC
LIMIT 10;

-------------------------------------------------------------------------------------------

--3) Top 10 Performing Movies by Revenue (Foreign)
SELECT 
	DISTINCT movie,
	ROUND(foreign_revenue / 1000000000.0,2) as foreign_revenue_b
FROM movies
ORDER BY foreign_revenue_b DESC
LIMIT 10;

-------------------------------------------------------------------------------------------

--3) Highest Performing Movies by Worldwide Revenue Yearly
WITH yearly_performance AS (
    SELECT 
        year,
        movie,
        worldwide_revenue,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY worldwide_revenue DESC
        ) AS rnk
    FROM movies
)
SELECT 
    DISTINCT year,
    movie,
    ROUND(worldwide_revenue / 1000000000.0,2) as worldwide_revenue_b
FROM yearly_performance
WHERE rnk = 1
ORDER BY year;

-------------------------------------------------------------------------------------------

--4) Top 10 High Rated Movies
SELECT 
	DISTINCT movie,
	rating
FROM movies
ORDER BY rating DESC
LIMIT 10;

-------------------------------------------------------------------------------------------

--5) Highest Rated Movies Yearly
WITH highest_rated AS (
    SELECT 
        year,
        movie,
        rating,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY rating DESC
        ) AS rnk
    FROM movies
)
SELECT 
    DISTINCT year,
    movie,
    rating
FROM highest_rated
WHERE rnk = 1
ORDER BY year;

-------------------------------------------------------------------------------------------

--6) Top 10 Popular Movies
SELECT 
	DISTINCT movie,
	vote_count
FROM movies
ORDER BY vote_count DESC
LIMIT 10;

-------------------------------------------------------------------------------------------

--7) Most Popular Movies Yearly
WITH most_popular AS (
    SELECT 
        year,
        movie,
        vote_count,
        DENSE_RANK() OVER (
            PARTITION BY year 
            ORDER BY vote_count DESC
        ) AS rnk
    FROM movies
)
SELECT 
    DISTINCT year,
    movie,
    vote_count
FROM most_popular
WHERE rnk = 1
ORDER BY year;

-------------------------------------------------------------------------------------------

--8) Genres wise Top Performing Movies
WITH genres_wise_performance AS (
    SELECT 
        genres,
        movie,
        worldwide_revenue,
        DENSE_RANK() OVER (
            PARTITION BY genres 
            ORDER BY worldwide_revenue DESC
        ) AS rnk
    FROM movies
)
SELECT 
    DISTINCT genres,
    movie,
    ROUND(worldwide_revenue / 1000000000.0,2) as worldwide_revenue_b
FROM genres_wise_performance
WHERE rnk = 1
ORDER BY genres;

-------------------------------------------------------------------------------------------

--9) Country-wise Highest Performing movie by Worldwide Revenue
WITH country_wise_performance_worldwide AS (
    SELECT 
        production_countries as country,
        movie,
        worldwide_revenue,
        DENSE_RANK() OVER (
            PARTITION BY production_countries
            ORDER BY worldwide_revenue DESC
        ) AS rnk
    FROM movies
)
SELECT 
    DISTINCT country,
    movie,
    ROUND(worldwide_revenue / 1000000.0,2) as worldwide_revenue_m
FROM country_wise_performance_worldwide
WHERE rnk = 1
ORDER BY country;

-------------------------------------------------------------------------------------------

--10) Country-wise Highest Performing movie by Domestic Revenue
WITH country_wise_performance_domestic AS (
    SELECT 
        production_countries as country,
        movie,
        domestic_revenue,
        DENSE_RANK() OVER (
            PARTITION BY production_countries
            ORDER BY domestic_revenue DESC
        ) AS rnk
    FROM movies
)
SELECT 
    DISTINCT country,
    movie,
    domestic_revenue
FROM country_wise_performance_domestic
WHERE rnk = 1
ORDER BY country;

-------------------------------------------------------------------------------------------

-- Some Important Insights

-- Which genres have the highest worldwide revenue?
SELECT 
    genres,
    ROUND(SUM(worldwide_revenue) / 1000000000, 2) AS revenue_billion
FROM (
    SELECT 
        genres,
        MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY genres, movie
) 
GROUP BY genres
ORDER BY revenue_billion DESC
LIMIT 1;

-- Which genres have the highest average worldwide revenue?
SELECT 
    genres,
    ROUND(AVG(worldwide_revenue) / 1000000, 2) AS revenue_million
FROM (
    SELECT 
        genres,
        MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY genres, movie
)
GROUP BY genres
ORDER BY revenue_million DESC
LIMIT 1;

-- Which genres have the highest average ratings?
SELECT
    genres,
    ROUND(AVG(rating), 2) AS average_rating
FROM (
    SELECT 
        genres,
        MAX(rating) AS rating
    FROM movies
    GROUP BY genres, movie
) 
GROUP BY genres
ORDER BY average_rating DESC
LIMIT 1;

-- How do ratings correlate with worldwide revenue?
SELECT 
    rating_category,
    ROUND(AVG(worldwide_revenue)/1000000, 2) AS ave_ww_revenue_m
FROM (
    SELECT 
        movie,
        rating_category,
        MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY movie, rating_category
)
GROUP BY rating_category
ORDER BY ave_ww_revenue_m DESC;

-- How do ratings vary by year — are movies getting better or worse?
SELECT 
    year,
    ROUND(AVG(rating), 1) AS avg_rating
FROM (
    SELECT 
        movie,
        year,
        MAX(rating) AS rating
    FROM movies
    GROUP BY movie, year
)
GROUP BY year
ORDER BY year;

-- Which production countries produce the most highest-rated movies?
SELECT
    production_countries AS production_country,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS num_movies_above_8
FROM movies
WHERE rating > 8.0
GROUP BY production_countries
ORDER BY num_movies_above_8 DESC;

-- Which genres are most popular (based on number of movies)?
SELECT 
    genres,
    COUNT(DISTINCT movie) AS total_movies
FROM movies
GROUP BY genres
ORDER BY total_movies DESC;

-- Do movies with higher votes tend to earn more revenue?
SELECT
    vote_category,
    ROUND(AVG(worldwide_revenue)/1000000, 2) AS avg_revenue_m
FROM (
    SELECT movie, vote_category, MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY movie, vote_category
)
GROUP BY vote_category
ORDER BY avg_revenue_m DESC;

-- Which genres attract the most audience engagement (highest votes)?
-- Average Analysis
SELECT 
    genres,
    ROUND(AVG(vote_count), 2) AS avg_vote
FROM (
    SELECT 
        movie,
        genres,
        MAX(vote_count) AS vote_count
    FROM movies
    GROUP BY movie, genres
) 
GROUP BY genres
ORDER BY avg_vote DESC;

-- Overall Analysis
SELECT 
    genres,
    SUM(vote_count) AS total_vote
FROM (
    SELECT 
        movie,
        genres,
        MAX(vote_count) AS vote_count
    FROM movies
    GROUP BY movie, genres
) 
GROUP BY genres
ORDER BY total_vote DESC;

-- Which movies have high ratings but low revenue?
SELECT 
    movie,
    ROUND(rating, 2) AS rating,
    ROUND(MAX(worldwide_revenue) / 1000000, 2) AS revenue_million
FROM movies
GROUP BY movie, rating
HAVING rating > 8.0 
   AND MAX(worldwide_revenue) < (
        SELECT AVG(worldwide_revenue) FROM (
            SELECT movie, MAX(worldwide_revenue) AS worldwide_revenue
            FROM movies
            GROUP BY movie
        ) 
    )
ORDER BY revenue_million ASC;

-- Which movies have low ratings but high revenue (blockbusters despite poor reviews)?
SELECT 
    movie,
    ROUND(MAX(rating), 2) AS rating,
    ROUND(MAX(worldwide_revenue) / 1000000, 2) AS revenue_million
FROM movies
GROUP BY movie
HAVING MAX(rating) < 5.0 
   AND MAX(worldwide_revenue) > (
        SELECT AVG(worldwide_revenue) FROM (
            SELECT movie, MAX(worldwide_revenue) AS worldwide_revenue
            FROM movies
            GROUP BY movie
        ) 
    )
ORDER BY revenue_million DESC;

-------------------------------------------------------------------------------------------
--DASHBOARD KPIs

--Total Movies
SELECT 
	COUNT(DISTINCT movie) as total_movies
FROM movies;

-- Total_Revenue
SELECT 
	ROUND(SUM(movie_revenue)/1000000000,0) AS total_revenue_b
FROM (
    SELECT 
		movie, 
		MAX(worldwide_revenue) AS movie_revenue
    FROM movies
    GROUP BY movie
) AS unique_movies;

-- Average Movie Rating
SELECT
	ROUND(AVG(movie_rating),2) as avg_rating
FROM(
	SELECT
		movie,
		MAX(rating) as movie_rating
	FROM movies
	GROUP BY movie
)
	
-- Highest Grossing, Rated & Voted Movie
SELECT 
	DISTINCT movie as movie_name,
	ROUND(worldwide_revenue/1000000000.0,1) as worldwide_revenue_b
FROM movies
ORDER BY worldwide_revenue_b DESC
LIMIT 1;
---
SELECT 
	DISTINCT movie as movie_name,
	rating
FROM movies
ORDER BY rating DESC
LIMIT 1;
---
SELECT 
	DISTINCT movie as movie_name,
	vote_count
FROM movies
ORDER BY vote_count DESC
LIMIT 1;

-- All year top grossing/votting/rating movies
WITH top AS(
	SELECT 
		year,
		movie,
		worldwide_revenue,
		DENSE_RANK() OVER(PARTITION BY year ORDER BY worldwide_revenue DESC) as rnk
	FROM movies
)
SELECT DISTINCT
	year,
	movie,
	ROUND(worldwide_revenue/1000000000.0,2) as worldwide_revenue_b
FROM top
WHERE rnk = 1
ORDER BY year;
---
WITH top AS(
	SELECT 
		year,
		movie,
		rating,
		DENSE_RANK() OVER(PARTITION BY year ORDER BY rating DESC) as rnk
	FROM movies
)
SELECT DISTINCT
	year,
	movie,
	rating
FROM top
WHERE rnk = 1
ORDER BY year;
---
WITH top AS(
	SELECT 
		year,
		movie,
		vote_count,
		DENSE_RANK() OVER(PARTITION BY year ORDER BY vote_count DESC) as rnk
	FROM movies
)
SELECT DISTINCT
	year,
	movie,
	vote_count
FROM top
WHERE rnk = 1
ORDER BY year;

-- Avg. Domestic % and Foreign % 
SELECT 
	ROUND(AVG(domestic_share),1) as avg_domestic,
	ROUND(AVG(foreign_share),1) as avg_domestic
FROM (
	SELECT 
		movie,
		MAX(domestic_share) as domestic_share,
		MAX(foreign_share) as foreign_share
	FROM movies
	GROUP BY movie
);

-- Movies by Avg. Rating Cateogry
SELECT 
    rating_category,
    ROUND(
        (AVG(rating) * 100.0 / SUM(AVG(rating)) OVER ()),
        0
    ) AS avg_rating_percent
FROM movies
GROUP BY rating_category
ORDER BY avg_rating_percent DESC;

-- Movies by Voting Category
SELECT 
    vote_category,
    ROUND(SUM(vote_count) * 100.0 / (SELECT SUM(vote_count) FROM movies), 0) AS total_votes_pct
FROM movies
GROUP BY vote_category
ORDER BY total_votes_pct DESC;

-- Revenue by Country
SELECT 
    production_countries,
    ROUND(SUM(worldwide_revenue) / 1000000, 2) AS revenue_million
FROM (
    SELECT 
        movie,
        production_countries,
        MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY movie, production_countries
) 
GROUP BY production_countries
ORDER BY revenue_million DESC;

-- Revenue by Genres
SELECT 
    genres,
    ROUND(SUM(worldwide_revenue) / 1000000000, 2) AS revenue_billion
FROM (
    SELECT 
        movie,
        genres,
        MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY movie, genres
) 
GROUP BY genres
ORDER BY revenue_billion DESC;

-- Year-Over-Year Revnue Trend
SELECT 
    year,
    ROUND(SUM(worldwide_revenue)/1000000000,1) AS total_revenue_b
FROM (
    SELECT year, MAX(worldwide_revenue) AS worldwide_revenue
    FROM movies
    GROUP BY year, movie
) 
GROUP BY year
ORDER BY year;


