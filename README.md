# Netflix Movies and Tv shows data analysis using SQL 
## Overview
  This project focuses on analyzing Netflix data using SQL to extract meaningful insights. Various SQL queries will be used to clean, filter, and explore the dataset, identifying trends in content, genres, and user preferences. The results will be visualized in Power BI through interactive dashboards, charts, and graphs. The aim is to provide data-driven insights into Netflix's content strategy and audience engagement.

## Objective
Data Extraction & Cleaning – Use SQL to clean, filter, and preprocess Netflix data for accurate analysis.
Content Analysis – Identify trends in genres, release years, and regional distribution of Netflix content.
User Engagement Insights – Analyze audience preferences and viewing patterns to understand content popularity.
Visualization & Reporting – Create interactive Power BI dashboards to present insights effectively.

## Dataset
The data for this project is sourced from Kaggle dataset.
Dataset link:https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download

## Schemas
```sql
CREATE TABLE netflix
(
show_id  VARCHAR(6),
type	VARCHAR(10),
title	VARCHAR(150),
director	VARCHAR(208),
casts	VARCHAR(1000),
country	VARCHAR(150),
date_added	VARCHAR(50),
release_year	INT,
rating VARCHAR(10),
duration	VARCHAR(15),
listed_in	VARCHAR(100),
description VARCHAR(250)

)
select * from netflix;
```
1.counting the no. of movies vs tv shows
```sql
SELECT type,count(*) as total_no FROM netflix
group by type ;
```

2.find the most common rating for movies and tv shows 
```sql
SELECT type,rating,count(*),
rank() over(partition by type order by count(*) desc)as ranking 
from netflix
group by 1,2
order by 1,3 desc
```

 3.list all the movies released in a specefic year
```sql
SELECT * from netflix 
where type ='Movie' AND release_year=2020
```

4.find the top 5 countries with the most content on netflix
```sql
select                           
   unnest(STRING_TO_ARRAY(country,','))as new_country,
   count(show_id) as total_content
from netflix
group by 1 
```

5.identify the longest movie
```sql
select title,duration from netflix
where type='Movie' AND duration=(select max(duration) from netflix)
```

6.find the content added in last five year
```sql
select * from netflix 
where TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE - INTERVAL '5 years'
```
7.Find all the movies/tv shows directed by rajiv chilaka
```sql
select * from netflix 
where director='Rajiv Chilaka'
```
8. list all the tv shows with more than 5 seasons
 ```sql
SELECT * 
FROM netflix 
WHERE 
    type = 'TV Show' 
    AND 
    SPLIT_PART(duration, ' ', 1) ~ '^[0-9]+$' 
    AND 
    SPLIT_PART(duration, ' ', 1)::numeric > 5;

```
9.count the number of item content in each genre
```sql
   select 
   unnest(STRING_TO_ARRAY(listed_in,','))as gerne,
   count(show_id) as total_content
   from netflix 
   group by 1
```

10.find the each year and the average no. of content release by india on netflix 
      return top 5 year which higest avg content release

```sql
      select
	  EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD,YYYY'))as year,
	  count(*) as yearly_content,
	  count(*)::numeric/(select count(*)from netflix where country = 'India')::numeric *100 as avg_content_per_year
	  from netflix 
	  where country='India'
	  group by 1
```
11.select all the movies that are documntries
```sql
	  select *from netflix
	 where listed_in='Documentaries'
```
12.find all the content without a director
```sql
         select *from netflix
	 where director IS NULL
```
13.FIND HOW MANY MOVIES actor salman khan appear in movies in last 15 years
```sql
	select * from netflix 
	where  casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-15
```

14.find the top 10 actor who have appeared in the highest number of movies produced in india
```sql
	select 
	unnest (STRING_TO_ARRAY(casts,','))as actors,
	count (*) as total_content
	from netflix 
	where country ILIKE '%India%'
	group by 1
	order by 2 desc
	limit 10
```
15.categories the content based on the presence of the keyword "kill "and "violence" in the description field.
	Label content containing these keyword as "bads " and all other content as "good" .count how many item fall under each category.
```sql
	 WITH new_table 
	 as(
	 select 
	 * ,
	 case 
	 when description ILIKE '%kill%' or
	      description ILIKE '%violence%' THEN 'BAD CONTENT'
		  ELSE 'GOOD CONTENT'
	 END category 
	 from netflix
	 )
	 select category,count(*) as total_content
	 from new_table 
	 group by 1
```

##Conclusion
This project successfully analyzed Netflix data using SQL, uncovering key trends in content distribution, genres, and user engagement. The insights were visualized through Power BI dashboards, enabling better understanding of content performance. These findings can help optimize Netflix’s content strategy and enhance user experience.
