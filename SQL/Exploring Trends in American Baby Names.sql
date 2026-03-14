/*

How have American baby name tastes changed since 1920? Which names have remained popular for over 100 years, and how do those names compare to more recent top baby names? These are considerations for many new parents, but the skills you'll practice while answering these queries are broadly applicable. After all, understanding trends and popularity is important for many businesses, too!

You'll be working with data provided by the United States Social Security Administration, which lists first names along with the number and sex of babies they were given to in each year. For processing speed purposes, the dataset is limited to first names which were given to over 5,000 American babies in a given year. The data spans 101 years, from 1920 through 2020.

## The Data

### `baby_names`

| column         | type    | description                                                                  |
| -------------- | ------- | ------------------------------------------------------------------------ |
| `year`         | int     | year                                                                     |
| `first_name`   | varchar | first name                                                               |
| `sex`          | varchar | `sex` of babies given `first_name`                                       |
| `num`          | int     | number of babies of `sex` given `first_name` in that `year`              |


*/

-- List the overall top five names in alphabetical order and find out if each name is "Classic" or "Trendy."

SELECT
	first_name,
	SUM(num),
	CASE WHEN COUNT(year) > 50 THEN 'Classic'
		ELSE 'Trendy' END AS popularity_type
FROM baby_names
GROUP BY first_name
ORDER BY first_name
LIMIT 5;

-- What were the top 20 male names overall, and how did the name Paul rank?

SELECT
	RANK() OVER(ORDER BY SUM(num) DESC) AS name_rank,
	first_name,
	SUM(num)
FROM public.baby_names
WHERE sex = 'M'
GROUP BY first_name
ORDER BY name_rank
LIMIT 20;

-- Which female names appeared in both 1920 and 2020?

SELECT
	first_name,
	SUM(num) AS total_occurrences
FROM public.baby_names
WHERE sex = 'F'
	AND year IN (1920, 2020)
GROUP BY first_name
HAVING COUNT(DISTINCT year) = 2;

-- ChatGPT answer to the last question

-- Select first name and total occurrences
SELECT a.first_name, (a.num + b.num) AS total_occurrences
FROM baby_names a
JOIN baby_names b
-- Join on first name
ON a.first_name = b.first_name
-- Filter for the years 1920 and 2020 and sex equals 'F'
WHERE a.year = 1920 AND a.sex = 'F'
AND b.year = 2020 AND b.sex = 'F'