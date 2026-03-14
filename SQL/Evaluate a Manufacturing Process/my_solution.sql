/*

Manufacturing processes for any product is like putting together a puzzle. Products are pieced together step by step, and keeping a close eye on the process is important.

For this project, you're supporting a team that wants to improve how they monitor and control a manufacturing process. The goal is to implement a more methodical approach known as statistical process control (SPC). SPC is an established strategy that uses data to determine whether the process works well. Processes are only adjusted if measurements fall outside of an acceptable range. 

This acceptable range is defined by an upper control limit (UCL) and a lower control limit (LCL), the formulas for which are:

$ucl = avg\_height + 3 * \frac{stddev\_height}{\sqrt{5}}$

$lcl = avg\_height - 3 * \frac{stddev\_height}{\sqrt{5}}$

The UCL defines the highest acceptable height for the parts, while the LCL defines the lowest acceptable height for the parts. Ideally, parts should fall between the two limits.

Using SQL window functions and nested queries, you'll analyze historical manufacturing data to define this acceptable range and identify any points in the process that fall outside of the range and therefore require adjustments. This will ensure a smooth running manufacturing process consistently making high-quality products.

## The data
The data is available in the `manufacturing_parts` table which has the following fields:
- `item_no`: the item number
- `length`: the length of the item made
- `width`: the width of the item made
- `height`: the height of the item made
- `operator`: the operating machine

*/

-- my solution
WITH priliminary_table AS(
	SELECT
		operator,
		ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS row_number,
		item_no,
		height,
		AVG(height) OVER(
			PARTITION BY operator
			ORDER BY item_no
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		) AS avg_height,
		STDDEV(height) OVER(
			PARTITION BY operator
			ORDER BY item_no
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		) AS stddev_height
	FROM public.manufacturing_parts
),

final_table AS(
	SELECT
		operator,
		row_number,
		height,
		avg_height,
		stddev_height,
		(avg_height + 3 * stddev_height / SQRT(5)) AS ucl,
		(avg_height - 3 * stddev_height / SQRT(5)) AS lcl,
		CASE
			WHEN height NOT BETWEEN
				(avg_height - 3 * stddev_height / SQRT(5))
				AND (avg_height + 3 * stddev_height / SQRT(5))
			THEN True
			ELSE True
		END AS alert
	FROM priliminary_table
	WHERE row_number >=5
	GROUP BY
		operator,
		row_number,
		height,
		avg_height,
		stddev_height,
		item_no
	ORDER BY item_no
)
	
SELECT *
FROM final_table
LIMIT 10;

-- my solution (cleaned with chatgpt)
WITH window_calculations AS(
	SELECT
		operator,
		ROW_NUMBER() OVER(PARTITION BY operator ORDER BY item_no) AS row_number,
		item_no,
		height,
		AVG(height) OVER(
			PARTITION BY operator
			ORDER BY item_no
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		) AS avg_height,
		STDDEV(height) OVER(
			PARTITION BY operator
			ORDER BY item_no
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		) AS stddev_height
	FROM public.manufacturing_parts
),

limit_calculations AS(
	SELECT
		operator,
		row_number,
		height,
		avg_height,
		stddev_height,
		(avg_height + 3 * stddev_height / SQRT(5)) AS ucl,
		(avg_height - 3 * stddev_height / SQRT(5)) AS lcl
	FROM window_calculations
	WHERE row_number >=5
	ORDER BY item_no
),

final_calculations AS(
	SELECT
		*,
		(height NOT BETWEEN lcl AND ucl) AS alert
	FROM limit_calculations
)
	
SELECT *
FROM final_calculations
LIMIT 10;

-- datacamp solution
-- Flag whether the height of a product is within the control limits
SELECT
	b.*,
	CASE
		WHEN 
			b.height NOT BETWEEN b.lcl AND b.ucl
		THEN TRUE
		ELSE FALSE
	END as alert
FROM (
	SELECT
		a.*, 
		a.avg_height + 3*a.stddev_height/SQRT(5) AS ucl, 
		a.avg_height - 3*a.stddev_height/SQRT(5) AS lcl  
	FROM (
		SELECT 
			operator,
			ROW_NUMBER() OVER w AS row_number, 
			height, 
			AVG(height) OVER w AS avg_height, 
			STDDEV(height) OVER w AS stddev_height
		FROM manufacturing_parts 
		WINDOW w AS (
			PARTITION BY operator 
			ORDER BY item_no 
			ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
		)
	) AS a
	WHERE a.row_number >= 5
) AS b;