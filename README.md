# Netflix Movies and TV Shows Data Analysis using SQL

![Netflix logo](https://github.com/Egitto-Data/Netflix_sql_project/blob/main/logo.png)

## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.



## Objectives
+ Analyze the distribution of content types (movies vs TV shows).  
+ Identify the most common ratings for movies and TV shows.  
+ List and analyze content based on release years, countries, and durations.
+ Explore and categorize content based on specific criteria and keywords.  

## Dataset 
The data for this project is sourced from the Kaggle dataset:
- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```
## Business Problems: 

### 1. Count the Number of Movies vs TV Shows
### 2. Find the Most Common Rating for Movies and TV Shows
### 3. List All Movies Released in a Specific Year (e.g., 2020)
### 4. Find the Top 5 Countries with the Most Content on Netflix
### 5. Identify the Longest Movie
### 6. Find Content Added in the Last 5 Years
### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
### 8. List All TV Shows with More Than 5 Seasons
### 9. Count the Number of Content Items in Each Genre
### 10.Find each year and the average numbers of content release in India on netflix.
### 11. List All Movies that are Documentaries
### 12. Find All Content Without a Director
### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords




## Thank you for your support, and I look forward to connecting with you!

