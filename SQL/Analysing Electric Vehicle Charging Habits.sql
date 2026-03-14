/*

As electronic vehicles (EVs) become more popular, there is an increasing need for access to charging stations, also known as ports. To that end, many modern apartment buildings have begun retrofitting their parking garages to include shared charging stations. A charging station is shared if it is accessible by anyone in the building.

But with increasing demand comes competition for these ports — nothing is more frustrating than coming home to find no charging stations available! In this project, you will use a dataset to help apartment building managers better understand their tenants’ EV charging habits.

The data has been loaded into a PostgreSQL database with a table named `charging_sessions` with the following columns:

## charging_sessions

| Column | Definition | Data type |
|-|-|-|
|`garage_id`| Identifier for the garage/building|`VARCHAR`|
|`user_id` | Identifier for the individual user|`VARCHAR`|
|`user_type`|Indicating whether the station is `Shared` or `Private`| `VARCHAR` |
|`start_plugin`|The date and time the session started |`DATETIME`|
|`start_plugin_hour`|The hour (in military time) that the session started | `NUMERIC`|
|`end_plugout`|The date and time the session ended | `DATETIME` |
|`end_plugout_hour`|The hour (in military time) that the session ended | `NUMERIC`|
|`duration_hours`| The length of the session, in hours|`NUMERIC`|
|`el_kwh`| Amount of electricity used (in Kilowatt hours)|`NUMERIC`|
|`month_plugin`| The month that the session started |`VARCHAR`|
|`weekdays_plugin`| The day of the week that the session started|`VARCHAR`|

Let’s get started!

#### Sources
- **Data**: [CC BY 4.0](https://creativecommons.org/licenses/by/4.0), via [Kaggle](https://www.kaggle.com/datasets/anshtanwar/residential-ev-chargingfrom-apartment-buildings),
- **Image**: Julian Herzog, [CC BY 4.0](https://creativecommons.org/licenses/by/4.0), via Wikimedia Commons

*/

-- unique_users_per_garage
-- Modify the code below
SELECT *
FROM charging_sessions
LIMIT 5;

SELECT
	garage_id,
	COUNT(DISTINCT user_id) AS num_unique_users
FROM public.charging_sessions
WHERE user_type = 'Shared'
GROUP BY garage_id
ORDER BY num_unique_users DESC;

SELECT
	weekdays_plugin,
	start_plugin_hour,
	COUNT(*) AS num_charging_sessions
FROM public.charging_sessions
WHERE user_type = 'Shared'
GROUP BY weekdays_plugin, start_plugin_hour
ORDER BY COUNT(*) DESC
LIMIT 10;

SELECT
	user_id,
	AVG(duration_hours) AS avg_charging_duration
FROM public.charging_sessions
WHERE user_type = 'Shared'
GROUP BY user_id
HAVING AVG(duration_hours) > 10
ORDER BY AVG(duration_hours) DESC;