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

-- 1.counting the no. of movies vs tv shows
SELECT type,count(*) as total_no FROM netflix
group by type ;

--2.find the most common rating for movies and tv shows 

SELECT type,rating,count(*),
rank() over(partition by type order by count(*) desc)as ranking 
from netflix
group by 1,2
order by 1,3 desc                    
 
--- select type ,rating             ---(most common rating)
-- from
--( SELECT type,rating,
-- count(*),
--rank() over(partition by type order by count(*) desc)as ranking 
--from netflix
--group by 1,2) as t1
--where ranking=1 ;             ---(most common rating )


--3.list all the movies released in a specefic year

SELECT * from netflix 
where type ='Movie' AND release_year=2020

--4.find the top 5 countries with the most content on netflix

select country,count(show_id) as total_content
from netflix
group by 1


select                           --output as no country with double record
   unnest(STRING_TO_ARRAY(country,','))as new_country,
   count(show_id) as total_content
from netflix
group by 1                       --output as no country with double record

--5.identify the longest movie
select title,duration from netflix
where type='Movie' AND duration=(select max(duration) from netflix) 

--6.find the content added in last five year
select * from netflix 
where TO_DATE(date_added,'Month DD,YYYY')>= CURRENT_DATE - INTERVAL '5 years'

--7.Find all the movies/tv shows directed by rajiv chilaka
select * from netflix 
where director='Rajiv Chilaka'

--8. list all the tv shows with more than 5 seasons
select 
   *,
   SPLIT_PART(duration, ' ' ,1)as sessions 
   from netflix
where type= 'TV show' AND sessions > 5     --we cant write this because sessions column in not permanent insted of that write  elow code

select 
   *
from netflix
where 
    type= 'TV show' 
    AND 
    SPLIT_PART(duration, ' ' ,1)::numeric > 5 

	
	
	SELECT * 
FROM netflix 
WHERE 
    type = 'TV Show' 
    AND 
    SPLIT_PART(duration, ' ', 1) ~ '^[0-9]+$' -- Ensures it's only numbers
    AND 
    SPLIT_PART(duration, ' ', 1)::numeric > 5;

   --9.count the number of item content in each genre
   select 
   unnest(STRING_TO_ARRAY(listed_in,','))as gerne,
   count(show_id) as total_content
   from netflix 
   group by 1

   --10.find the each year and the average no. of content release by india on netflix 
      --return top 5 year which higest avg content release

	  select
	  EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD,YYYY'))as year,
	  count(*)
	  from netflix 
	  where country='India'
	  group by 1

	  --for avg
      select
	  EXTRACT (YEAR FROM TO_DATE(date_added,'Month DD,YYYY'))as year,
	  count(*) as yearly_content,
	  count(*)::numeric/(select count(*)from netflix where country = 'India')::numeric *100 as avg_content_per_year
	  from netflix 
	  where country='India'
	  group by 1

	  --11.select all the movies that are documntries
	  select *from netflix
	 where listed_in='Documentaries'

	  --12.find all the content without a director
         select *from netflix
	 where director IS NULL
	  
	 --13.FIND HOW MANY MOVIES actor salman khan appear in movies in last 15 years

	select * from netflix 
	where  casts ILIKE '%Salman Khan%'
	AND 
	release_year > EXTRACT(YEAR FROM CURRENT_DATE)-15

	--14.find the top 10 actor who have appeared in the highest number of movies produced in india,
	select 
	unnest (STRING_TO_ARRAY(casts,','))as actors,
	count (*) as total_content
	from netflix 
	where country ILIKE '%India%'
	group by 1
	order by 2 desc
	limit 10

	--15.categories the content based on the presence of the keyword "kill "and "violence" in the description field.
	--Label content containing these keyword as "bads " and all other content as "good" .count how many item fall under each category.

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