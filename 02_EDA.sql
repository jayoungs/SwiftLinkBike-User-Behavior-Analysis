-- < EXPLORATORY DATA ANALYSIS >

-- 1. Metrics: rides, average & median trip duration, long ride frequency
-- (Findings: Members have a higher total ride volume, but their average and median trip durations are shorter than casual riders. Casual users tend to take long rides (> 30 minutes) more frequently.)
SELECT 	
	member_casual,
	COUNT(*) AS rides, -- casual users 2,079,850 vs. members 3,601,724
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency 
FROM cyclistic_analysis
GROUP BY 1
ORDER BY 1; 

-- 2. Metrics by month
-- (Findings: Seasonal patterns confirmed. During the winter months (Dec–Feb), ride volume was lower and trip durations were shorter.)
SELECT 	
	month,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1
ORDER BY 1; 

----> 2.1. Metrics + Coefficient of Variation (CV) across months per user type
---- (Findings:
---- * Both groups follow the same seasonal pattern, with members consistently taking shorter trips.
---- * Casual users exhibit a higher CV than members across ride volume, duration, and long-ride frequency. This indicates higher volatility and stronger seasonality among casual riders.)
WITH rides_per_user_month AS (
SELECT 	
	member_casual,
	month,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1, 2)

SELECT 
	*,
	ROUND(100 * STDDEV_POP(rides) OVER (PARTITION BY member_casual) / AVG(rides) OVER (PARTITION BY member_casual), 2) AS cv_rides, -- casual users 67% VS members 42%
	ROUND(100 * STDDEV_POP(avg_duration_sec) OVER (PARTITION BY member_casual) / AVG(avg_duration_sec) OVER (PARTITION BY member_casual), 2) AS cv_duration_sec, -- casual users 22% VS members 11% 
	ROUND(100 * STDDEV_POP(long_ride_frequency) OVER (PARTITION BY member_casual) / AVG(long_ride_frequency) OVER (PARTITION BY member_casual), 2) AS cv_long_rides -- casual users 78% VS members 59%
FROM rides_per_user_month
ORDER BY member_casual, month;

-- 3. Metrics by Day of Week
-- (Findings: Saturdays recorded the highest number of rides, followed by Fridays and Wednesdays. Weekend trips are generally longer and have a higher frequency of long rides.)
SELECT 	
	day_of_week, -- SUN 0 to SAT 6
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1
ORDER BY 1; 

----> 3.1. Metrics + Coefficient of Variation (CV) across days per user type
---- (Findings: Casual ridership peaks on Saturdays and Sundays, while member ridership peaks on Wednesdays and Thursdays. Weekend trips are generally longer and have a higher frequency of long rides across both groups. Casual users' long-ride frequency is notably more volatile.)
WITH rides_per_user_days AS (
SELECT 	
	member_casual,
	day_of_week,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1, 2)

SELECT 
	*,
	ROUND(100 * STDDEV_POP(rides) OVER (PARTITION BY member_casual) / AVG(rides) OVER (PARTITION BY member_casual), 2) AS cv_rides, -- casual users 23% VS members 11%
	ROUND(100 * STDDEV_POP(avg_duration_sec) OVER (PARTITION BY member_casual) / AVG(avg_duration_sec) OVER (PARTITION BY member_casual), 2) AS cv_duration_sec, -- casual users 12% VS members 7% 
	ROUND(100 * STDDEV_POP(long_ride_frequency) OVER (PARTITION BY member_casual) / AVG(long_ride_frequency) OVER (PARTITION BY member_casual), 2) AS cv_long_rides -- casual users 45% VS members 12%
FROM rides_per_user_days
ORDER BY member_casual, day_of_week;

----> 3.2. Metrics: Weekends vs. Weekdays per User Type
---- (Findings: Casual users show a higher percentage of total rides and long rides on weekends compared to members.)
WITH rides_per_user_weekends AS (
SELECT 	
	member_casual,
	(CASE 
		WHEN day_of_week IN (0, 6) THEN 1 -- weekends
		ELSE 0 -- weekdays
	END) AS is_weekends,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1, 2)

SELECT 
	*,
	ROUND(rides / SUM(rides) OVER (PARTITION BY member_casual) * 100.0, 2) AS rides_pct, -- weekends: casual users 38% VS members 24%
	ROUND(long_ride_frequency / SUM(long_ride_frequency) OVER (PARTITION BY member_casual) * 100.0, 2) AS long_ride_pct -- weekends: casual users 48% VS members 33%
FROM rides_per_user_weekends
ORDER BY member_casual, is_weekends;

-- 4. Metrics by hour
-- (Findings: Rides increase starting at 5 AM and peak twice: at 8 AM (324,002) and 5 PM (577,307).)
SELECT 	
	hour_of_day,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1
ORDER BY 1; 

----> 4.1. Metrics + Coefficient of Variation (CV) across hours per user type
---- (Findings:
---- * Both groups see an increase in activity starting at 5 AM. Casual rides follow a smooth curve peaking at 5 PM (197,310). In contrast, members show a "triple-peak" pattern (8 AM, 12 PM, 5 PM).
---- * Interestingly, members show a slightly higher CV in ride volume (70% vs 68%) across hours. This is due to the extreme surge during commute windows compared to the gradual rise of casual usage.
---- * However, member trip durations are nearly 3x more stable than casual users' durations throughout the day (6% CV vs 16% CV).
WITH rides_per_user_hour AS (
SELECT 	
	member_casual,
	hour_of_day,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1, 2)

SELECT 
	*,
	ROUND(100 * STDDEV_POP(rides) OVER (PARTITION BY member_casual) / AVG(rides) OVER (PARTITION BY member_casual), 2) AS cv_rides, -- casual users 68% VS members 70%
	ROUND(100 * STDDEV_POP(avg_duration_sec) OVER (PARTITION BY member_casual) / AVG(avg_duration_sec) OVER (PARTITION BY member_casual), 2) AS cv_duration_sec, -- casual users 16% VS members 6%
	ROUND(100 * STDDEV_POP(long_ride_frequency) OVER (PARTITION BY member_casual) / AVG(long_ride_frequency) OVER (PARTITION BY member_casual), 2) AS cv_long_rides -- casual users 84% VS members 77%
FROM rides_per_user_hour
ORDER BY member_casual, hour_of_day;

----> 4.2. Metrics by commute time (7–9 AM & 4–6 PM) per user type
---- (Findings: Member ride volume during commute hours is more than double that of casual users. Members also have a higher percentage of commute-hour trips and long rides by 9% and 12% respectively. Trip duration remained consistent between commute and non-commute periods for both groups.)
WITH rides_per_user_commute_time AS (
SELECT 	
	member_casual,
	(CASE 
		WHEN hour_of_day IN (7,8,9,16,17,18) THEN 1 -- commute time
		ELSE 0 -- non-commute time
	END) AS is_commute_time,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1, 2)

SELECT 
	*, -- rides: casual users in non-commute time 1,327,644, casual users in commute time 752,206 | members in non-commute time 1,973,934, members in commute time 1,627,790
	ROUND(rides / SUM(rides) OVER (PARTITION BY member_casual) * 100.0, 2) AS rides_pct, -- -- casual users in non-commute time 64%, casual users in commute time 36% | members in non-commute time 55%, members in commute time 45%
	ROUND(long_ride_frequency / SUM(long_ride_frequency) OVER (PARTITION BY member_casual) * 100.0, 2) AS long_ride_pct -- casual users in non-commute time 69%, casual users in commute time 31% | members in non-commute time 57%, members in commute time 43%
FROM rides_per_user_commute_time
ORDER BY member_casual, is_commute_time;

-- 5. Metrics by bike type (classic bikes, electric bikes, electric scooters)
-- (Findings: Electric bikes were the most popular equipment type. However, classic bikes showed longer average trip durations and a higher frequency of long rides.)
SELECT 	
	rideable_type,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1
ORDER BY 1;  

----> 5.1. Metrics by bike type per user type 
---- (Findings: Both Casual and Member groups mirror the overall pattern noted above.)
WITH rides_per_user_biketype AS (
SELECT 	
	member_casual,
	rideable_type,
	COUNT(*) AS rides,
	AVG(duration_sec) AS avg_duration_sec,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY duration_sec) AS median_duration_sec,
	COUNT(*) FILTER(WHERE duration_sec > 1800) AS long_ride_frequency
FROM cyclistic_analysis
GROUP BY 1, 2)

SELECT 
	*,
	ROUND(rides / SUM(rides) OVER (PARTITION BY member_casual) * 100.0, 2) AS rides_pct, -- electric bikes: casual users 51% VS members 53% | classic bikes: casual users 45% VS members 45%
	ROUND(long_ride_frequency / SUM(long_ride_frequency) OVER (PARTITION BY member_casual) * 100.0, 2) AS long_ride_pct -- electric bikes: casual users 30% VS members 36% | classic bikes: casual users 68% VS members 64%
FROM rides_per_user_biketype
ORDER BY member_casual, rideable_type;

-- 6. Top start station 
-- (Findings: 1. Streeter Dr & Grand Ave 2. DuSable Lake Shore Dr & Monroe St 3. Kingsbury St & Kinzie St 4. Michigan Ave & Oak St 5. DuSable Lake Shore Dr & North Blvd)
SELECT 
	start_station_name,
	COUNT(*) AS ride_count
FROM cyclistic_analysis
WHERE start_station_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5; 

----> 6.1. Top start stations by user type
---- (Findings: There is no overlap between the top start stations for each group, suggesting distinct geographic preferences.)
WITH start_station_ranking AS (
SELECT 
	member_casual,
	start_station_name,
	COUNT(*) AS ride_count,
	DENSE_RANK() OVER (
		PARTITION BY member_casual
		ORDER BY COUNT(*) DESC) AS ranking
FROM cyclistic_analysis
WHERE start_station_name IS NOT NULL
GROUP BY 1, 2
)

SELECT *
FROM start_station_ranking
WHERE ranking <= 5; 

-- 7. Top end station 
-- (Findings: 1. Streeter Dr & Grand Ave 2. DuSable Lake Shore Dr & North Blvd 3. DuSable Lake Shore Dr & Monroe St 4. Kingsbury St & Kinzie St 5. Michigan Ave & Oak St)
SELECT 
	end_station_name,
	COUNT(*) AS ride_count
FROM cyclistic_analysis
WHERE end_station_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5; 

----> 7.1. Top end station by user type 
---- (Findings: There is no overlap between the top end stations for each group, suggesting distinct geographic preferences.)
WITH end_station_ranking AS (
SELECT 
	member_casual,
	end_station_name,
	COUNT(*) AS ride_count,
	DENSE_RANK() OVER (
		PARTITION BY member_casual
		ORDER BY COUNT(*) DESC) AS ranking
FROM cyclistic_analysis
WHERE end_station_name IS NOT NULL
GROUP BY 1, 2
)

SELECT *
FROM end_station_ranking
WHERE ranking <= 5; 

-- 8. Top route 
-- (Findings: 1. Streeter Dr & Grand Ave - Streeter Dr & Grand Ave 2. DuSable Lake Shore Dr & Monroe St - DuSable Lake Shore Dr & Monroe St 3. DuSable Lake Shore Dr & Monroe St - Streeter Dr & Grand Ave 4. Calumet Ave & 33rd St - State St & 33rd St 5. State St & 33rd St - Calumet Ave & 33rd St)
SELECT 
	start_end_station,
	COUNT(*) AS ride_count
FROM cyclistic_analysis
WHERE end_station_name IS NOT NULL AND start_station_name IS NOT NULL
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5; 

----> 8.1. Top route by user type
---- (Findings: There is no overlap between the top routes for each group, suggesting distinct geographic preferences.)
WITH start_end_station_ranking AS (
SELECT 
	member_casual,
	start_end_station,
	COUNT(*) AS ride_count,
	DENSE_RANK() OVER (
		PARTITION BY member_casual
		ORDER BY COUNT(*) DESC) AS ranking
FROM cyclistic_analysis
WHERE end_station_name IS NOT NULL AND start_station_name IS NOT NULL
GROUP BY 1, 2
ORDER BY 1, 3 DESC
)

SELECT *
FROM start_end_station_ranking
WHERE ranking <= 5; 

-- 9. Same-station (circular) trips vs. station-to-station trips by user type
-- (Findings: In both groups, 90%+ of rides are station-to-station. However, members show a higher propensity for station-to-station trips compared to casual riders (98% vs. 91%).)
WITH ride_type AS (
	SELECT
		member_casual,
		COUNT(*) AS total_rides,
		COUNT(*) FILTER(WHERE start_station_name = end_station_name) AS circular_rides,
		COUNT(*) FILTER(WHERE start_station_name != end_station_name) AS station_to_station_rides
	FROM cyclistic_analysis
	WHERE start_station_name IS NOT NULL AND end_station_name IS NOT NULL -- casual users' records decreased by 28.5% while members' records decreased by 28.3%
	GROUP BY 1
)

SELECT
	member_casual,
	total_rides, -- casual users 1,487,186 VS members 2,582,050
	circular_rides,
	ROUND(100.0 * circular_rides / total_rides, 1) AS circular_trip_pct,
	station_to_station_rides,
	ROUND(100.0 * station_to_station_rides / total_rides, 1) AS station_to_station_pct -- casual users 91% VS members 98%
FROM ride_type
ORDER BY 1; 