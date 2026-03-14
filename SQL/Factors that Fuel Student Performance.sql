/*

In today's fast-paced and competitive educational environment, understanding the factors that influence student success is more important than ever. Just like the transport system in a bustling city like London must adapt to serve its residents, schools and educators must adapt to meet the needs of students. In this project, we will take a deep dive into a dataset containing rich details about various aspects of student life, such as hours studied, sleep patterns, attendance, and more, to uncover what truly impacts exam performance.

The dataset we'll be working with includes a wide range of factors influencing student performance. By analyzing this data, we'll be able to identify key drivers of success and provide insights that could help students, teachers, and policymakers make informed decisions. The table we'll use for this project is called `student_performance` and includes the following data:

| Column                   | Definition                                                      | Data type             |
|--------------------------|-----------------------------------------------------------------|-----------------------|
| `attendance`              | Percentage of classes attended                                  |     `float`               |
| `extracurricular_activities` | Participation in extracurricular activities                   |     `varchar` (Yes, No)    |
| `sleep_hours`             | Average number of hours of sleep per night                      |     `float`               |
| `tutoring_sessions`       | Number of tutoring sessions attended per month                  |     `integer`             |
| `teacher_quality`         | Quality of the teachers                                         |     `varchar` (Low, Medium, High) |
| `exam_score`              | Final exam score                                                |     `float`               |

You will execute SQL queries to answer three questions, as listed in the instructions.


*/

-- Let's take a look at the dataset
SELECT *
FROM student_performance
LIMIT 10;

-- avg_exam_score_by_study_and_extracurricular

SELECT
	hours_studied,
	AVG(exam_score) AS avg_exam_score
FROM public.student_performance
WHERE hours_studied > 10 
	AND extracurricular_activities = 'Yes'
GROUP BY hours_studied
ORDER BY hours_studied DESC;

-- avg_exam_score_by_hours_studied_range

SELECT
	CASE 
		WHEN hours_studied >= 1 AND hours_studied <= 5 THEN '1-5 hours'
		WHEN hours_studied >= 6 AND hours_studied <= 10 THEN '6-10 hours'
		WHEN hours_studied >= 11 AND hours_studied <= 15 THEN '11-15 hours'
		WHEN hours_studied >= 16 THEN '16+ hours'
	END AS hours_studied_range,
	AVG(exam_score) AS avg_exam_score
FROM public.student_performance
GROUP BY hours_studied_range
ORDER BY avg_exam_score DESC;

-- Actual Solution

CASE
       WHEN Hours_Studied BETWEEN 1 AND 5 THEN '1-5 hours'
       WHEN Hours_Studied BETWEEN 6 AND 10 THEN '6-10 hours'
       WHEN Hours_Studied BETWEEN 11 AND 15 THEN '11-15 hours'
       ELSE '16+ hours'

-- student_exam_ranking

SELECT
	attendance,
	hours_studied,
	sleep_hours,
	tutoring_sessions,
	DENSE_RANK() OVER(ORDER BY exam_score DESC) AS exam_rank
FROM public.student_performance
ORDER BY exam_rank ASC
LIMIT 30;