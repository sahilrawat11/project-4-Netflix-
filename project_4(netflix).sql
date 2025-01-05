-- Netflix project 
-- Creating a Table 
CREATE TABLE netflix(
show_id VARCHAR(10),
type VARCHAR(20),
title VARCHAR(150) ,
director VARCHAR(220) ,
casts VARCHAR(1000) ,
country VARCHAR(150),
date_added VARCHAR(100),
release_year INT,
rating VARCHAR(100),
duration VARCHAR(200),
listed_in VARCHAR(200),
description VARCHAR(1000)
);
select * from netflix;

select count(*)  as total_content 
  from netflix;

select distinct type
  from netflix;

SELECT * FROM netflix;
-- 15 Business Problems & Solutions

-- 1. Count the number of Movies vs TV Shows
select type ,count(type) as total_num
  from netflix 
  group by type;
  
  -- 2. Find the most common rating for movies and TV shows
 select type , rating from ( 
select  type ,
       rating ,
	   count(rating) as common_rating ,
	   rank() over (partition by type order by count(rating) desc) as ranking
 from netflix
 group by type ,rating 
 ) as t1
 where 
     ranking = 1;

-- 3. List all movies released in a specific year (e.g., 2020)
select *
from netflix
where type = 'Movie'
   and 
   release_year = '2020';

-- 4. Find the top 5 countries with the most content on Netflix
select 
      unnest(string_to_array(country , ',')) as new_country  ,
	   count(show_id) as total_show
from netflix 
group by 1
order by  2 desc 
limit 5
-- 5. Identify the longest movie
select *
from netflix 
where type = 'Movie'
	and 
	  cast(split_part(duration , ' ' , 1 ) as integer ) =
	  				(select max(cast(split_part(duration , ' ' , 1 ) as integer ))
					  FROM netflix
		  where 
			  type = 'Movie');
					
-- 6. Find content added in the last 5 years
select 
	*
from netflix 
where to_date(date_added , 'month dd , yyyy') >= current_date - interval '5 year'

-- 7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
select * 
from netflix 
where director like '%Rajiv Chilaka%'

-- 8. List all TV shows with more than 5 seasons
select * 
from netflix 
where 
	type = 'TV Show'
		and
		cast(split_part(duration , ' ' , 1) as integer) > 5 ;

-- 9. Count the number of content items in each genre

select unnest(string_to_array(listed_in , ',')) as genre ,
       count(show_id)as num_of_content
from netflix
group by 1;

-- 10.10.Find each year and the average numbers of content release in India on netflix. 
return top 5 year with highest avg content release!


select 
		extract(year from to_date(date_added , 'month dd , yyyy')) as year,
		round(count(*):: numeric/(select count(*) from netflix
		           where 'India' = any(string_to_array(country , ' '))) :: numeric
				           * 100 , 2) as avg_content_per_year
from netflix
where  'India' = any(string_to_array(country , ' '))
group by 1

-- 11. List all movies that are Documentaries
select *
from netflix
where 
    listed_in like '%Documentaries%';

-- 12. Find all content without a director
select * 
from netflix
where 
    director is null;
-- 13. Find how many movies actor 'Salman Khan' appeared in last 10 years!
select *
from netflix
where casts like '%Salman Khan%'
  and
    release_year >= extract(year from current_date) - 10;

-- 14.Find the top 10 actors who have appeared in the highest number of movies produced in India.
select 
     actors ,
     count(actors)
from 
    (select unnest(string_to_array(casts , ','))as actors ,
       title
from netflix
where
    country like '%India%' )
group by 1
order by  2 desc
limit 10;

-- 15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
-- the description field. Label content containing these keywords as 'Bad' and all other 
-- content as 'Good'. Count how many items fall into each category.
create table new_table 
	AS 
(select * ,
		case 
		when description like '%kill%'
		 or 
		 description like '%violence%' then 'bad_content'
		 else 'good_content'
		 end category
from netflix
)

SELECT category ,
	   count(*) as total_content
	   
from new_table
group by 1;











