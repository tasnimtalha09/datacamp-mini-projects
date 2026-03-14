/*

GoodThought NGO has been a catalyst for positive change, focusing its efforts on education, healthcare, and sustainable development to make a significant difference in communities worldwide. With this mission, GoodThought has orchestrated an array of assignments aimed at uplifting underprivileged populations and fostering long-term growth.

This project offers a hands-on opportunity to explore how data-driven insights can direct and enhance these humanitarian efforts. In this project, you'll engage with the GoodThought PostgreSQL database, which encapsulates detailed records of assignments, funding, impacts, and donor activities from 2010 to 2023. This comprehensive dataset includes:

- **`Assignments`:** Details about each project, including its name, duration (start and end dates), budget, geographical region, and the impact score.
- **`Donations`:** Records of financial contributions, linked to specific donors and assignments, highlighting how financial support is allocated and utilized.
- **`Donors`:** Information on individuals and organizations that fund GoodThought’s projects, including donor types.

Refer to the below ERD diagram for a visual representation of the relationships between these data tables:
<img src="erd.png" alt="ERD" width="50%" height="50%">


You will execute SQL queries to answer two questions, as listed in the instructions. Good luck!

*/

-- highest_donation_assignments

SELECT 
	assignments.assignment_name,
	assignments.region,
	SUM(ROUND(donations.amount, 2)) AS rounded_total_donation_amount,
	donors.donor_type
FROM donations
LEFT JOIN donors
	ON donations.donor_id = donors.donor_id
LEFT JOIN assignments
	ON donations.assignment_id = assignments.assignment_id
GROUP BY donor_type, assignments.assignment_name, assignments.region
ORDER BY rounded_total_donation_amount DESC
LIMIT 5;

-- Their solution for the first question

WITH donation_details AS (
    SELECT
        d.assignment_id,
        ROUND(SUM(d.amount), 2) AS rounded_total_donation_amount,
        dn.donor_type
    FROM donations d
    JOIN donors dn 
		ON d.donor_id = dn.donor_id
    GROUP BY d.assignment_id, 
	dn.donor_type
)
SELECT
    a.assignment_name,
    a.region,
    dd.rounded_total_donation_amount,
    dd.donor_type
FROM assignments a
JOIN donation_details dd 
	ON a.assignment_id = dd.assignment_id
ORDER BY dd.rounded_total_donation_amount DESC
LIMIT 5;

-- top_regional_impact_assignments

WITH 
	donations_count AS
		(
		SELECT
			assignment_id,
			COUNT(*) AS num_total_donations
		FROM donations
		GROUP BY assignment_id
		),
	ranked_assignments AS
		(
		SELECT 
			assignment_name,
			region,
			impact_score,
			num_total_donations,
			ROW_NUMBER() OVER(PARTITION BY region ORDER BY impact_score DESC) as rank_in_region
		FROM assignments
		LEFT JOIN donations_count
			ON assignments.assignment_id = donations_count.assignment_id
		WHERE num_total_donations > 0
	)


SELECT
	assignment_name,
	region,
	impact_score,
	num_total_donations
FROM ranked_assignments
WHERE rank_in_region = 1
ORDER BY region ASC;

-- Their solution for the second question

WITH 
	donation_counts AS (
	    SELECT
	        assignment_id,
	        COUNT(donation_id) AS num_total_donations
	    FROM donations
	    GROUP BY assignment_id
),
	ranked_assignments AS (
	    SELECT
	        a.assignment_name,
	        a.region,
	        a.impact_score,
	        dc.num_total_donations,
	        ROW_NUMBER() OVER (PARTITION BY a.region ORDER BY a.impact_score DESC) AS rank_in_region
	    FROM assignments a
	    JOIN donation_counts dc 
			ON a.assignment_id = dc.assignment_id
	    WHERE dc.num_total_donations > 0
)
SELECT
    assignment_name,
    region,
    impact_score,
    num_total_donations
FROM ranked_assignments
WHERE rank_in_region = 1
ORDER BY region ASC;