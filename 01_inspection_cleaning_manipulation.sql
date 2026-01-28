/* This dataset comprises 12 tables, one for each month, covering the most recent 12-month period from April 2024 through March 2025.
Before consolidating them, check the number of records for each month as shown below:
*/


CREATE TEMP TABLE records_per_month AS (
	SELECT 
		TO_DATE('2024-04', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202404_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-05', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202405_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-06', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202406_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-07', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202407_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-08', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202408_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-09', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202409_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-10', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202410_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-11', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202411_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2024-12', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202412_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2025-01', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202501_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2025-02', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202502_divvy_tripdata"
	
	UNION ALL
	
	SELECT 
		TO_DATE('2025-03', 'YYYY-MM') AS month,
		COUNT(*) AS records_count
	FROM cyclistic."202503_divvy_tripdata"
);

SELECT 
	*,
	SUM(records_count) OVER () AS total_count,
	ROUND(records_count/SUM(records_count) OVER ()*100.0, 1) AS percentage
FROM records_per_month
ORDER BY MONTH;

-- < CONSOLIDATE INTO ONE TEMPORARY TABLE FOR DATA INSPECTION >

DROP TABLE IF EXISTS combined_table;
CREATE TEMP TABLE combined_table AS (
	SELECT *
	FROM cyclistic."202404_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202405_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202406_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202407_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202408_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202409_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202410_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202411_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202412_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202501_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202502_divvy_tripdata"
	
	UNION ALL
	
	SELECT *
	FROM cyclistic."202503_divvy_tripdata"
);

SELECT COUNT(*)
FROM combined_table; -- 5779568: the same as the count above.

SELECT *
FROM combined_table
LIMIT 20;

-- < INSPECT CONSOLIDATED DATA AND IDENTIFY DATA ISSUES >

--> 1. Check data types for each column
SELECT 
	column_name,
	data_type
FROM information_schema.COLUMNS
WHERE table_schema = (SELECT pg_my_temp_schema()::regnamespace::text) AND table_name = 'combined_table'; -- find this session's temporary schema name 

--> 2. Check for duplicate rows: none found
SELECT 
	*,
	COUNT(*) AS duplicate_count
FROM combined_table
GROUP BY 1,2,3,4,5,6,7,8,9,10,11,12,13
HAVING COUNT(*) > 1; -- no duplicates

--> 3. Check for duplicate ride_id(primary key) values: 211 reocrds found 
WITH primary_key_duplicates AS (
	SELECT
		ride_id,
		COUNT(*) AS duplicate_count
	FROM combined_table
	GROUP BY 1
	HAVING COUNT(*) > 1 
)

SELECT COUNT(*)
FROM primary_key_duplicates; -- 211

---- Verification: 211 records confirmed 
SELECT 
	COUNT(ride_id) AS ride_count, -- 5779568
	COUNT(DISTINCT ride_id) AS distinct_ride_count -- 5779357
FROM combined_table;

SELECT 5779568-5779357; -- 211

----> 3.1. Identify Duplicate Pattern: initial observation suggested duplicate ride_id values were isolated to 05/2024.
SELECT *
FROM combined_table
WHERE ride_id IN (
	SELECT
		ride_id
	FROM combined_table
	GROUP BY 1
	HAVING COUNT(*) > 1)
ORDER BY ride_id;

----> Verification: Confirmed via the query below. In each duplicate pair, one record contains timestamp values ending in .000 milliseconds for both started_at and ended_at 
----> (Data cleaning action: remove duplicate records where both timestamps end in .000 milliseconds)
SELECT 
	COUNT(ride_id) - COUNT(DISTINCT ride_id) 
FROM combined_table
WHERE EXTRACT(MONTH FROM started_at) = 5; -- 211

SELECT *
FROM combined_table
WHERE EXTRACT(MONTH FROM started_at) = 5 AND
	ride_id IN (
	SELECT
		ride_id
	FROM combined_table
	GROUP BY 1
	HAVING COUNT(*) > 1)
ORDER BY ride_id;

--> 4. Check for missing/null values: only end station coordinates columns have null values
SELECT
    COUNT(*) FILTER (WHERE ride_id IS NULL) AS ride_id_nulls,
    COUNT(*) FILTER (WHERE rideable_type IS NULL) AS bike_type_nulls,
    COUNT(*) FILTER (WHERE started_at IS NULL) AS started_at_nulls,
    COUNT(*) FILTER (WHERE ended_at IS NULL) AS ended_at_nulls,
    COUNT(*) FILTER (WHERE start_station_name IS NULL) AS start_station_name_nulls,
    COUNT(*) FILTER (WHERE start_station_id IS NULL) AS start_station_id_nulls,
    COUNT(*) FILTER (WHERE end_station_name IS NULL) AS end_station_name_nulls,
    COUNT(*) FILTER (WHERE end_station_id IS NULL) AS end_station_id_nulls,
    COUNT(*) FILTER (WHERE start_lat IS NULL) AS start_lat_nulls,
    COUNT(*) FILTER (WHERE start_lng IS NULL) AS start_lng_nulls,
    COUNT(*) FILTER (WHERE end_lat IS NULL) AS end_lat_nulls, -- 6589
    COUNT(*) FILTER (WHERE end_lng IS NULL) AS end_lng_nulls, -- 6589
    COUNT(*) FILTER (WHERE member_casual IS NULL) AS member_casual_nulls
FROM combined_table;

--> 5. Check for empty strings ('') or whitespace across VARCHAR columns.
--- (Data cleaning action: replace empty strings with NULL)
SELECT
    COUNT(*) FILTER (WHERE LENGTH(TRIM(ride_id)) = 0) AS empty_ride_id,
    COUNT(*) FILTER (WHERE LENGTH(TRIM(rideable_type)) = 0) AS empty_bike_type,
    COUNT(*) FILTER (WHERE LENGTH(TRIM(start_station_name)) = 0) AS empty_start_station_name, -- 1091230
    COUNT(*) FILTER (WHERE LENGTH(TRIM(start_station_id)) = 0) AS empty_start_station_id, -- 1091230
    COUNT(*) FILTER (WHERE LENGTH(TRIM(end_station_name)) = 0) AS empty_end_station_name, -- 1120919
    COUNT(*) FILTER (WHERE LENGTH(TRIM(end_station_id)) = 0) AS empty_end_station_id,-- 1120919
    COUNT(*) FILTER (WHERE LENGTH(TRIM(member_casual)) = 0) AS empty_member_casual
FROM combined_table;

----> 5.1. Double-check start station
SELECT COUNT(*) -- 1091230: all of them have start station coordinates but not station names and IDs.
FROM combined_table
WHERE LENGTH(TRIM(start_station_name)) = 0 AND (start_lat IS NOT NULL AND start_lng IS NOT NULL)

----> 5.1.1.  Explore possibility of imputation: fill missing start station names and IDs using coordinates from the same location.
SELECT 
	start_lat, 
	start_lng, 
	COUNT(start_station_name)) AS count_start_station_name, 
	COUNT(start_station_id)) AS count_start_station_id
FROM combined_table
GROUP BY 1,2; -- not possible: different precision level of coordinates. some coodinates are linked to 300+ different station names.

----> Double-check decimal place range/precision levels: precision is too inconsistent to support reliable imputation
WITH coordination_precision AS (
	SELECT 
		SCALE(start_lat) AS start_lat_dp,
		SCALE(start_lng) AS start_lng_dp,
		SCALE(end_lat) AS end_lat_dp,
		SCALE(end_lng)AS end_lng_dp
	FROM combined_table
)

SELECT 
	MIN(start_lat_dp) AS min_start_lat_dp, -- 1
	MAX(start_lat_dp) AS max_start_lat_dp, -- 15
	MIN(start_lng_dp) AS min_start_lng_dp, -- 1
	MAX(start_lng_dp) AS max_start_lng_dp, -- 14
	MIN(end_lat_dp) AS min_end_lat_dp, -- 1
	MAX(end_lat_dp) AS max_end_lat_dp, -- 15
	MIN(end_lng_dp) AS min_end_lng_dp, -- 1
	MAX(end_lng_dp) AS max_end_lng_dp -- 14
FROM coordination_precision;

--> 6. Check for non-sensible data

----> 6.1. started_at >= ended_at
---- (Data cleaning action: remove these 492 records)
SELECT 
	COUNT(*) -- 492
FROM combined_table
WHERE started_at >= ended_at;

----> 6.2. trip duration < 1 minute and start & end station are the same
---- (Data cleaning action: remove these 97291 records)
SELECT COUNT(*) -- 97291
FROM combined_table
WHERE started_at < ended_at AND ended_at - started_at < INTERVAL '1 MINUTE' AND start_station_id = end_station_id;
-- 4 out of 10 have different end_station_name FROM start_station_name. Those three were members.


/* The data issues identified above are documented in the Issue Log uploaded to the repository.
* These issues will be addressed during the following data cleaning process.
*/

-- < CLEAN AND MANIPULATE DATA >

--> 1. Clean data

DROP TABLE IF EXISTS cleaned_table;
CREATE TEMP TABLE cleaned_table AS (
WITH deduped_table AS (
	SELECT
		ride_id,
		rideable_type,
		started_at,
		ended_at,
		NULLIF(TRIM(start_station_name), '') AS start_station_name, -- replace empty string values with NULL
		NULLIF(TRIM(start_station_id), '') AS start_station_id,
		NULLIF(TRIM(end_station_name), '') AS end_station_name,
		NULLIF(TRIM(end_station_id), '') AS end_station_id,
		start_lat,
		start_lng,
		end_lat,
		end_lng,
		member_casual,
		ROW_NUMBER() OVER (
			PARTITION BY ride_id
			ORDER BY 
				(TO_CHAR(started_at, 'MS') = '000') ASC, -- sort FALSE (non-zero) before TRUE (.000)
				(TO_CHAR(ended_at, 'MS') = '000') ASC
		) AS row_num
	FROM combined_table
	WHERE started_at < ended_at AND -- remove records where started_at >= ended_at
	((ended_at - started_at < INTERVAL '1 MINUTE' AND start_station_id != end_station_id) OR 
	ended_at - started_at >= INTERVAL '1 MINUTE') -- remove records where trip duration < 1 minute and start/end stations are the same
)

SELECT *
FROM deduped_table
WHERE row_num = 1 -- remove duplicate ride_id records with .000 millisecond timestamp values
ORDER BY started_at
);

SELECT *
FROM cleaned_table
LIMIT 50;

--> 2. Data validation

----> 2.1. Row count verification
SELECT COUNT(*) -- 5681574 (actual) 
FROM cleaned_table;

SELECT 5779568 - 211 - 492 - 97291; -- 5681574 (expected = same as the above actual count)

----> 2.2. Ensure no duplicate ride_id values remain
SELECT 
	COUNT(ride_id), -- 5681574
	COUNT(DISTINCT ride_id) -- 5681574
FROM cleaned_table;

----> 2.3. Ensure all empty strings are converted to NULL
SELECT
    COUNT(*) FILTER (WHERE LENGTH(TRIM(start_station_name)) = 0) AS empty_start_station_name, -- 0
    COUNT(*) FILTER (WHERE LENGTH(TRIM(start_station_id)) = 0) AS empty_start_station_id, -- 0
    COUNT(*) FILTER (WHERE LENGTH(TRIM(end_station_name)) = 0) AS empty_end_station_name, -- 0
    COUNT(*) FILTER (WHERE LENGTH(TRIM(end_station_id)) = 0) AS empty_end_station_id -- 0
FROM cleaned_table;

----> 2.4. Ensure no nonsensical data remains (started_at >= ended_at)
SELECT *
FROM cleaned_table
WHERE started_at >= ended_at; -- no record

----> 2.5. Ensure no invalid trips remain (same-station trips under 1 minute)
SELECT *
FROM cleaned_table
WHERE ended_at - started_at < INTERVAL '1 MINUTE' AND start_station_id = end_station_id; -- no record

-- 3. Add columns for analysis and create the final table
-- (Added: month, day of week, hour of day, trip duration, and ride route [start station - end station])

DROP TABLE IF EXISTS cyclistic_analysis;
CREATE TEMP TABLE cyclistic_analysis AS (
SELECT
	ride_id,
	rideable_type,
	started_at,
	ended_at,
	EXTRACT(MONTH FROM started_at) AS month, -- added
	EXTRACT(DOW FROM started_at) AS day_of_week, -- added: SUN 0 - SAT 6
	EXTRACT(HOUR FROM started_at) AS hour_of_day, -- added
	(ended_at - started_at) AS duration, -- added
	EXTRACT(EPOCH FROM (ended_at - started_at)) AS duration_sec, -- added
	start_station_name,
	start_station_id,
	end_station_name,
	end_station_id,
	CONCAT(start_station_name, ' - ', end_station_name) AS start_end_station, -- added
	start_lat,
	start_lng,
	end_lat,
	end_lng,
	member_casual
FROM cleaned_table
); -- 5681574 records

SELECT *
FROM cyclistic_analysis
LIMIT 50;

-- < DATA EXPORT >

COPY cyclistic_analysis TO '/Users/jayoungsuh/bikeshare_db_202404to202503.csv' DELIMITER ',' CSV HEADER; 