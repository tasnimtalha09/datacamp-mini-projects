/*

Photo by Maxim Tolchinskiy on Unsplash
  
When factoring heat generation required for the manufacturing and transportation of products, _Greenhouse gas emissions attributable to products, from food to sneakers to appliances, make up more than 75% of global emissions._ (`Source: The Carbon Catalogue https://www.nature.com/articles/s41597-022-01178-9`)

Our data, which is publicly available on nature.com, contains product carbon footprints (PCFs) for various companies. PCFs are the greenhouse gas emissions attributable to a given product, measured in CO<sub>2</sub> (carbon dioxide equivalent).
<!--https://www.nature.com/articles/s41597-022-01178-9-->

This data is stored in a PostgreSQL database containing one table, `product_emissions`, which looks at PCFs by product as well as the stage of production that these emissions occurred. Here's a snapshot of what `product_emissions` contains in each column:

### `product_emissions`

| field                              | data type |
|------------------------------------|-----------|
| `id`                                 | `VARCHAR`   |
| `year`                               | `INT`       |
| `product_name`                       | `VARCHAR`   |
| `company`                            | `VARCHAR`   |
| `country`                            | `VARCHAR`   |
| `industry_group`                     | `VARCHAR`   |
| `weight_kg`                          | `NUMERIC`   |
| `carbon_footprint_pcf`               | `NUMERIC`   |
| `upstream_percent_total_pcf`         | `VARCHAR`   |
| `operations_percent_total_pcf`       | `VARCHAR`   |
| `downstream_percent_total_pcf`       | `VARCHAR`   |

You'll use this data to examine the carbon footprint of each industry in the dataset! 

*/

-- Update your query here
SELECT *
FROM product_emissions
LIMIT 5;

SELECT
	industry_group,
	COUNT(DISTINCT company) AS num_companies,
	ROUND(SUM(carbon_footprint_pcf), 1) AS total_industry_footprint
FROM public.product_emissions
WHERE year IN (
	SELECT MAX(year) 
	FROM public.product_emissions
)
GROUP BY industry_group
ORDER BY total_industry_footprint DESC;