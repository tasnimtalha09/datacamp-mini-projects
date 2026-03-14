/*

Video games are big business: the global gaming market is projected to be worth more than $300 billion by 2027 according to Mordor Intelligence. With so much money at stake, the major game publishers are hugely incentivized to create the next big hit. But are games getting better, or has the golden age of video games already passed?

In this project, you'll analyze video game critic and user scores as well as sales data for the top 400 video games released since 1977. You'll search for a golden age of video games by identifying release years that users and critics liked best, and you'll explore the business side of gaming by looking at game sales data.

Your search will involve joining datasets and comparing results with set theory. You'll also filter, group, and order data. Make sure you brush up on these skills before trying this project! The database contains two tables. Each table has been limited to 400 rows for this project, but you can find the complete dataset with over 13,000 games on Kaggle.

### `game_sales` table

| Column | Definition | Data Type |
|-|-|-|  
|name|Name of the video game|`varchar`|
|platform|Gaming platform|`varchar`|
|publisher|Game publisher|`varchar`|
|developer|Game developer|`varchar`|
|games_sold|Number of copies sold (millions)|`float`|
|year|Release year|`int`|

### `reviews` table

| Column | Definition | Data Type |
|-|-|-|
|name|Name of the video game|`varchar`|  
|critic_score|Critic score according to Metacritic|`float`|
|user_score|User score according to Metacritic|`float`|


### `users_avg_year_rating` table

| Column | Definition | Data Type |
|-|-|-|
|year| Release year of the games reviewed |`int`|  
|num_games| Number of games released that year |`int`|
|avg_user_score| Average score of all the games ratings for the year |`float`|

### `critics_avg_year_rating` table

| Column | Definition | Data Type |
|-|-|-|
|year| Release year of the games reviewed |`int`|  
|num_games| Number of games released that year |`int`|
|avg_critic_score| Average score of all the games ratings for the year |`float`|

*/

SELECT *
FROM game_sales
ORDER BY games_sold DESC
LIMIT 10;

-- My Solution
SELECT 
	g.year, 
	a.num_games,
	ROUND(AVG(r.critic_score), 2) AS avg_critic_score
FROM game_sales as g
LEFT JOIN reviews as r
ON g.name = r.name
LEFT JOIN users_avg_year_rating as a
ON g.year = a.year
WHERE a.num_games >= 4
GROUP BY g.year, a.num_games
ORDER BY avg_critic_score DESC
LIMIT 10;

-- Actual Solution
SELECT g.year, COUNT(g.name) AS num_games, ROUND(AVG(r.critic_score),2) AS avg_critic_score
FROM game_sales g
INNER JOIN reviews r
ON g.name = r.name
GROUP BY g.year
HAVING COUNT(g.name) >= 4
ORDER BY avg_critic_score DESC
LIMIT 10;

SELECT
	u.year,
	u.num_games,
	c.avg_critic_score,
	u.avg_user_score,
	(u.avg_user_score - c.avg_critic_score) AS diff
FROM users_avg_year_rating as u
INNER JOIN critics_avg_year_rating as c
ON u.year = c.year
	AND u.num_games = c.num_games
WHERE avg_critic_score > 9
	OR avg_user_score > 9
ORDER BY u.year;