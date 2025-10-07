# Box Office Insights & Dashboard Project

_An interactive Power BI dashboard analyzing global box-office trends from 2000 to 2024. Built using Python, SQL, and Power BI to uncover revenue patterns, ratings insights, and market dynamics._


## Table of Contents  

1. <u>[Overview](#overview)</u>  
2. <u>[Screenshot](#screenshot)</u>  
3. <u>[Project Description](#project-description)</u>  
4. <u>[Project Objective](#project-objective)</u>  
5. <u>[Dataset Description](#dataset-description)</u>  
6. <u>[Data Exploration & Analysis](#data-exploration--analysis)</u>
7. <u>[Dashboard Highlights](#dashboard-highlights)</u> 
8. <u>[Key Insights](#key-insights)</u>  
8. <u>[Tools & Skills Used](#tools--skills-used)</u>  
9. <u>[How to Use This Project](#how-to-use-this-project)</u>  
10. <u>[Conclusion](#conclusion)</u>  
11. <u>[Author](#author)</u>  
12. <u>[Contact](#contact)</u>  



## Overview
A dynamic dashboard providing actionable insights into global box-office trends, helping analysts and stakeholders make data-driven decisions.

Highlights:

- **Data Cleaning**: Cleaned and preprocessed all movie data using Python (Pandas) to ensure accuracy and consistency.

- **Data Analysis**: Analyzed data with SQL to extract key trends, patterns, and performance insights.

- **Interactive Dashboard**: Created an interactive Power BI dashboard with DAX-based KPIs for visualizing revenue, ratings, and trends.

- **Insights Delivered**: Provides actionable insights for understanding global movie performance and supporting strategic decisions.

## Screenshot
![Dashboard Demo](Dashboard%20Demonstration/Dashboard.jpg)


## Project Description

__Box Office Insights__ is an interactive Power BI dashboard providing actionable insights into global movie performance from 2000 to 2024. Data was cleaned and preprocessed using Python pandas and analyzed with SQL to extract trends such as top-grossing movies, yearly revenue patterns, and genre-wise performance. An interactive dashboard with DAX-based KPIs was created to visualize revenue, ratings, and market share. This project showcases skills in data cleaning, analysis, visualization, and deriving meaningful insights for stakeholders and analysts.


## Project Objective

The goal of this project is to analyze and visualize global box-office data from 2000 to 2024, providing actionable insights for analysts, studios, and stakeholders. It aims to identify revenue trends, top-grossing movies, audience ratings, and market dynamics across countries and genres. By leveraging Python (Pandas) for data cleaning, SQL for analysis, and Power BI with DAX for interactive visualizations, the project delivers a comprehensive, easy-to-explore dashboard that supports data-driven decision-making in the movie industry.


## Dataset Description

The dataset used in this project is a CSV file containing detailed records of movies and includes both original and derived columns to support comprehensive analysis and visualization. Key columns include:

- _Rank_: The position of the movie based on its worldwide revenue.
- _Movie_: The title of the movie.
- _Worldwide Revenue_: Total revenue generated globally by the movie.
- _Domestic Revenue_: Revenue earned in the movie’s domestic market.
- _Domestic Share_: Percentage of total revenue contributed by the domestic market.
- _Foreign Revenue_: Revenue earned from international markets.
- _Foreign Share_: Percentage of total revenue contributed by foreign markets.
- _Year_: The release year of the movie.
- _Genres_: Genres of the movie (e.g., Action, Comedy).
- _Rating_: Average audience or critic rating of the movie.
- _Vote_Count_: Number of votes received for the movie.
- _Original_Language_: The language in which the movie was originally produced.
- _Production_Countries_: Countries where the movie was produced.
- _Performance_: Classification of the movie’s commercial success (e.g., Hit, Flop).
- _Rating_Category_: Classification of the movie based on its rating (e.g., Good, Average).
- _Vote_Category_: Classification of the movie based on vote count (e.g., Popular, Moderate).

This dataset combines raw data and derived columns such as Rating_Category and Vote_Category, enabling effective trend analysis, KPI computation, and interactive dashboard visualizations.

## Data Exploration & Analysis

The data exploration and analysis process was carried out in multiple steps to ensure accuracy and extract actionable insights from the global box-office dataset.

1. **Data Cleaning** : The dataset was cleaned and preprocessed using Python (Pandas) to ensure accuracy and reliability. Key steps included:
    - Checked data description and summary to understand structure and quality.
    - Trimmed extra spaces in _Movie_ and _Genres_ columns.
    - Handled missing values and removed duplicate rows.
    - Exploded multi-genre and multi-country data for better analysis.
    - Standardized country names (e.g., replaced long names with short forms like “USA”).
    - Created calculated columns such as _Performance_, _Vote_Category_ and _Rating_Category_.
    - Saved the cleaned dataset as a new CSV for further analysis.

    **Code Snippet**:  
    ```Python
    import pandas as pd

    # Load dataset
    df = pd.read_csv(r"C:\Users\HP\Desktop\Development\enhanced_box_office_data(2000-2024)u.csv")

    # Quick overview
    df.head()
    df.shape
    df.describe()

    # Rename columns for clarity
    df = df.rename(columns={
        "Release Group": "Movie",
        "$Worldwide": "Worldwide Revenue",
        "$Domestic": "Domestic Revenue",
        "Domestic %": "Domestic Share",
        "$Foreign": "Foreign Revenue",
        "Foreign %": "Foreign Share",
    })

    # Round ratings
    df['Rating'] = df['Rating'].round(1)

    # Handle missing values
    df["Genres"] = df["Genres"].fillna("Unknown")
    df["Vote_Count"] = df["Vote_Count"].fillna(0).astype(int)
    df["Original_Language"] = df["Original_Language"].fillna("Unknown")
    df["Production_Countries"] = df["Production_Countries"].fillna("Unknown")

    # Clean and convert rating column
    df["Rating"] = df["Rating"].str.replace("/10", "", regex=False).astype(float)
    df["Rating"] = df["Rating"].fillna(df["Rating"].median())

    # Check duplicates and missing values
    df.isna().sum()
    df.duplicated().sum()

    # Explode multi-value columns
    df["Genres"] = df["Genres"].str.split(",")
    df["Production_Countries"] = df["Production_Countries"].str.split(",")
    df = df.explode("Genres").explode("Production_Countries").reset_index(drop=True)

    # Create calculated columns
    # Performance
    def performance(row):
        revenue = row['Worldwide Revenue']
        if revenue > 100_000_000:
            return 'Blockbuster'
        elif revenue > 50_000_000:
            return 'Hit'
        elif revenue > 5_000_000:
            return 'Average'
        else:
            return 'Flop'
    df['Performance'] = df.apply(performance, axis=1)

    # Rating Category
    def categorize_rating(row):
        rating = row['Rating']
        if rating >= 8.0:
            return "Excellent"
        elif rating >= 6.0:
            return "Good"
        elif rating >= 4.0:
            return "Average"
        else:
            return "Poor"
    df['Rating_Category'] = df.apply(categorize_rating, axis=1)

    # Vote Category
    def vote_category(row):
        votes = row['Vote_Count']
        if votes >= 30000:
            return "Highly Popular"
        elif votes >= 10000:
            return "Popular"
        elif votes >= 5000:
            return "Moderate"
        else:
            return "Low"
    df['Vote_Category'] = df.apply(vote_category, axis=1)

    # Trim spaces
    df['Genres'] = df['Genres'].str.strip()
    df['Movie'] = df['Movie'].str.strip()

    # Save cleaned dataset
    df.to_csv(
        r"C:\Users\HP\Desktop\Development\box_office_cleaned.csv",
        index=False,
        encoding='utf-8'
    )
    ```
Note: Full Python code is available in the repository (Python Code\Box_office_data_cleaning.ipynb).

2. **Database Setup & SQL Analysis** : The cleaned dataset was inserted into PostgreSQL (pgAdmin) and stored in a table named _movies_. SQL queries were then used to extract actionable insights and analyze key trends.

    Some highlights of SQL Analysis:

    - Identified top-grossing movies worldwide.
    - Found top-rated movies based on audience ratings.
    - Analyzed yearly revenue trends to observe growth and fluctuations.
    - Explored top-performing genres and their contribution to revenue.
    - Calculated country-wise total revenue to see global distribution.
    - Calculated genre-wise total revenue for market insights.
    - Identified movies with high rating but low revenue.
    - Identified movies with high revenue but low rating (blockbusters with poor reviews).

This combined Python + SQL workflow ensured thorough data cleaning, accurate analysis, and meaningful insights for the box-office dataset.

**Some Key SQL Queries & Insights**

1. <u>Top 10 Performing Movies by Worldwide Revenue</u>: Identify the highest-grossing movies globally.

```SQL
SELECT 
	DISTINCT movie,
	ROUND(worldwide_revenue/1000000000.,2) as worldwide_revenue_b
FROM movies
ORDER BY worldwide_revenue_b DESC
LIMIT 10;
```

2. <u>Top 10 Performing Movies by Domestic Revenue</u>: Show movies earning the most in their home market.

```SQL
SELECT 
	DISTINCT movie,
	domestic_revenue/1000000 as domestic_revenue_m
FROM movies
ORDER BY domestic_revenue_m DESC
LIMIT 10;

```

3. <u>Top 10 High Rated Movies</u>: Highlight movies with the highest audience ratings.
```SQL
SELECT 
	DISTINCT movie,
	rating
FROM movies
ORDER BY rating DESC
LIMIT 10;
```

4. <u>Top 10 Popular Movies (Based on Votes)</u>: Identify movies with the highest audience engagement.

```SQL
SELECT 
	DISTINCT movie,
	vote_count
FROM movies
ORDER BY vote_count DESC
LIMIT 10;
```

5. <u>Genres with the Highest Worldwide Revenue</u>: Determine which movie genres generate the most revenue globally.

```SQL
SELECT 
    genres,
    ROUND(SUM(worldwide_revenue)/1000000000, 2) AS revenue_billion
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
```

6. <u>Country-wise Highest Performing Movie by Worldwide Revenue</u>: Identify top-performing movies in each production country.

```SQL
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

```

7. <u>Highest Rated Movies Yearly</u>: Track which movies had the highest ratings for each year.

```SQL
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
```

8. <u>Genre which have the highest average ratings</u>: Identify the highest average rated genre (Rank 1).

```SQL
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
```

Note: All other SQL queries and detailed analysis are available in the repository (SQL Query\box_office_insights_queries.sql) for further exploration.

4. **KPIs & DAX Metrics**: Several key KPIs were calculated in Power BI using DAX to provide actionable insights into global box-office performance. These include total worldwide revenue, domestic, and foreign share to track overall and market-specific earnings, average movie rating and vote count to assess movie quality and audience engagement, top-performing genres and countries to highlight major revenue contributors and yearly revenue trends were measured to track growth over time.

    Calculated measures include:
    - Avg_Domestic_%
    - Avg_Foreign_% 
    - Avg_Movie_Rating
    - Total_Movies
    - Total_Worldwide_Revenue
    - Total_Rating 
    - Total_Vote_Count

## Dashboard Highlights

The Box Office Insights Dashboard provides interactive insights into global movie performance using dynamic slicers, KPIs, and visualizations, enabling stakeholders and analysts to monitor key metrics, track trends, and make data-driven decisions for the movie industry.

1. Dynamic Slicers

    - ***Year***: Explore movie performance across different release years to analyze trends over time.

    - ***Country***: Filter movies by production country to assess regional contributions to revenue and ratings.

    - ***Genre***: Analyze performance and revenue across different movie genres.

    - ***Rating***: Focus on movies within specific audience or critic rating ranges.

    - ***Votes***: Explore movies based on audience engagement and popularity.

2. Key Performance Indicators (KPIs)

    - ***Highest Grossing Movie***: Displays the top-performing movie worldwide by revenue.

    - ***Highest Rated Movie***: Highlights the movie with the best audience or critic rating.

    - ***Most Voted Movie***: Tracks the movie with the highest audience engagement.

    - ***Movies***: Total number of movies analyzed.

    - ***Revenue***: Summarizes total revenue.

    - ***Avg. Rating***: Average rating of all movies, providing an overall quality measure.

    - ***Domestic % / Foreign %***: Shows the revenue contribution from domestic vs. international markets.

3. Visualizations

    - ***Movies by Rating***: Visualizes the distribution of movies by rating categories.

    - ***Movies by Popularity***: Shows audience engagement across movies by  popularity.

    - ***Revenue by Country***: Compares revenue generated by production countries.

    - ***Revenue by Genre***: Displays revenue contribution of different genres.

    - ***Top 10 Movies by Worldwide Revenue***: Highlights the highest-grossing movies globally.

    - ***Year-over-Year Revenue Trend***: Tracks revenue growth and trends across years.


## Key Insights

From the year **2000 to 2024**, the global box office industry witnessed the release of **4,955 movies**, generating a staggering **$594 billion** in worldwide revenue. The domestic market dominated the share with **64.3%**, while the foreign market contributed **36.0%**, accompanied by an average movie rating of **6.52**.

- ***Global Box Office Highlights***

    - Over these two decades, **Avengers: Endgame (2019)** reigned supreme as the **highest-grossing movie of all time**, earning **$2.8 billion** worldwide. On the other hand, **Attack on Titan The Movie: The Last Attack (2024)** earned the title of **highest-rated film**, while **Inception (2010)** emerged as the **most voted movie**, reflecting its lasting audience appeal.

    - When we look at audience preferences, **36%** of movies were rated **Excellent**, followed by **Good (30%), Average (24%),** and **Poor (10%)**. In terms of engagement, **42%** of all movies received **Low vote** counts, while only **2%** reached the **Highly Popular** category—proving that true audience virality is rare.

- ***The Titans of Global Revenue***

    - The top ten box office blockbusters were led by **Avengers: Endgame, Avatar**,and **Avatar: The Way of Water**, followed closely by cinematic giants like **Star Wars: The Force Awakens, Avengers: Infinity War**, and **Spider-Man: No Way Home**. Together, these films reshaped modern cinema economics.

    - Country-wise, the **United States** dominated the revenue chart with **\$503 billion**, followed by the **UK (\$82B)** and **China (\$48B)**. Meanwhile, smaller markets like **Belarus, Yugoslavia,** and **Senegal** contributed only a **few million dollars**, emphasizing the stark contrast between global film industries.

- ***Genre Analysis — What Audiences Love***
    - Among genres, **Adventure (\$260B)** and **Action (\$254B)** battled closely for global supremacy, with **Comedy** and **Drama** not far behind. Interestingly, while **Adventure** led in **total revenue**, **Science Fiction** stood out with the **highest average revenue** per film, showing its strong profitability despite fewer releases.

    - At the lower end, genres like **TV Movie, Documentary**, and **Western** generated minimal earnings. Yet, **TV Movie** surprisingly maintained the **highest average rating (7.24)**—while **Horror** ranked **lowest with 6.17**.

- ***Trends Over Time — Rise, Fall, and Recovery***
    - Revenue growth showed an inspiring journey. From **\$13.9 billion in 2000**, the box office grew steadily to **\$35.4 billion in 2019**, **its all-time high**. However, **COVID-19 in 2020** caused a historic collapse to **\$7.9 billion**, before rebounding strongly from 2021 to 2024, closing with **\$18.5 billion in 2024**.

    - Average ratings also improved slightly over time, climbing from **6.3 in 2000 to 6.8 in 2023**, indicating consistent improvements in production quality—though **2024** saw a **slight dip** back to **6.5**.

- ***Market Insights***

    - In the **domestic market**, **Star Wars: The Force Awakens (2015)** dominated with **\$963 million**, while **Avatar (2009)** led **internationally** with **$1.99 billion**.

    - The **USA, Japan**, and **UK** emerged as the **top three countries** producing the **highest-rated films**, showcasing their global influence in cinematic excellence.

- ***The Marvel Era***

    - The **Marvel Cinematic Universe (MCU)** transformed the global box office landscape. Since the **2010s**, nearly every MCU release has achieved **massive worldwide success**, demonstrating the unmatched power of franchise storytelling and loyal fanbases.

- ***Revenue–Rating Connections***

    - Analyzing deeper relationships, it was found that:
        - Movies rated **Excellent** earned an average of **$246M**
        - Good: $129M
        - Average: $75M
        - Poor: $40M.
          
    This clearly highlights how quality and audience approval directly influence financial success.

    - However, its seen — some **low-rated movies** such as **The Last Airbender (4.6 rating, \$319M)** and **The Fighter (2.0 rating, \$129M)** still **performed well financially**, whereas **top-rated films** like **Attack on Titan The Last Attack** and **Break the Silence: The Movie** failed to cross even **$10M** in revenue, proving that **critical acclaim doesn’t always guarantee commercial success**.

- ***Voting & Popularity Insights***

    - While the **Action** genre dominated **total votes**, the **Science Fiction** genre received the **highest average votes per movie**, showing strong audience loyalty.

    - Interestingly, **Highly Popular** movies, despite being only **2% of total releases**, earned **more revenue** than the combined total of **Popular** and **Moderate** movies, reflecting the immense impact of audience virality.

- ***Production Trends***

    - Over the years, **Drama, Comedy**, and **Action** emerged as the **most frequently produced genres**, underlining the audience’s timeless preference for emotional storytelling, humor, and thrill.




#### Key Takeaways & Suggestions

1. Invest more in Adventure and Action genres → They consistently generate the highest global revenue and audience engagement.

2. Expand international distribution, especially in markets like China, Germany, and Japan, which are strong foreign contributors after the U.S. and UK.

3. Capitalize on franchise power → The success of the Marvel Cinematic Universe shows that building long-term, connected storylines ensures massive and repeated box office success.

4. Balance quality and marketing → Some highly rated movies underperformed financially, indicating that strong content still needs proper marketing and global release strategies.

5. Focus on Science Fiction for profitability → Though fewer in number, Sci-Fi movies show the highest average revenue per release.

6. Increase production in TV Movies and Documentaries for OTT platforms → They receive high audience ratings even with lower theatrical earnings, suggesting strong streaming potential.

7. Maintain quality standards → Films rated Excellent earn significantly more revenue; focusing on storytelling and direction quality yields measurable returns.

8. Reinforce post-pandemic strategies → Since revenue has rebounded steadily after 2020, studios should continue leveraging hybrid releases (theater + streaming) to maximize reach.

9. Strengthen engagement campaigns → As only 2% of movies are “Highly Popular” but drive the majority of earnings, investing in targeted fan communities and pre-release buzz can multiply revenue.

10. Prioritize content for global audiences  Since domestic markets dominate but foreign shares are still 36%, tailoring content for international tastes can drive untapped revenue growth.

## Tools & Skills Used

- **Data Cleaning**: Python (Pandas)
- **Data Analysis**: SQL
- **Database & Querying**: PostgreSQL (pgAdmin)
- **Data Visualization & Modeling**: PowerBI, DAX


## How to Use This Project

1. Navigate to the Dashboard/ folder and open the Power BI file (_Box_Office_Insights_Dashboard.pbix_).
2. Explore dashboard in Report View, interact with slicers and visualizations to analyze Box Office insights.
3. In Table View, explore the dataset, DAX measures, and KPIs used for analysis.
4. Check SQL Insights

    - Import _box_office_cleaned.csv_ into your SQL database of choice (e.g., PostgreSQL, MySQL, SQL Server) and create a table to execute the queries.

    - Run the queries in _box_office_insights_queries.sql_ (found in the SQL Query/ folder) to reproduce insights and analysis results.

## Conclusion

This **Box Office Insights Dashboard** project demonstrates my proficiency in data cleaning using Python (Pandas), SQL-based analysis, and interactive visualization using Power BI. It showcases my ability to:

1. Preprocess, clean, and transform large box-office datasets using Python (Pandas) — handling missing values, removing duplicates, and creating calculated columns for accurate analysis.

2. Perform exploratory data analysis using SQL, uncovering trends in worldwide, domestic, and foreign revenues, as well as movie ratings, votes, and performance across genres and countries.

3. Generate insights through SQL queries to identify top-grossing and top-rated movies, most popular genres, country-wise revenue leaders, and rating–revenue relationships.

4. Develop an interactive Power BI dashboard featuring dynamic slicers, KPIs, and DAX measures to visualize box-office performance across multiple dimensions.

5. Deliver data-driven insights that highlight market dominance, audience preferences, and industry patterns from 2000 to 2024.

This project highlights my ability to transform raw movie data into clear, impactful insights — demonstrating strong analytical, Python, SQL, and data visualization (Power BI) skills essential for real-world data analytics roles.


## Author

***Kartavya Raj*** – Aspiring Data Analyst

Passionate about data analysis, visualization, and business insights. Skilled in Excel, SQL, Power BI, Python (Pandas, NumPy, Matplotlib, Seaborn, Plotly) and data visualization


## Contact

For any questions or further information, please contact me.

[![LinkedIn](https://skillicons.dev/icons?i=linkedin&theme=light)](https://www.linkedin.com/in/kartavyaraj) [![Gmail](https://skillicons.dev/icons?i=gmail&theme=light)](mailto:kartavyarajput108@gmail.com)

---

[🔼 Back to Top](#box-office-insights--dashboard-project)
