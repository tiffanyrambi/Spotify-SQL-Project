SELECT * FROM spotify

-- change column datatype (energy, valence, energyLiveness --> from varchar to float)
ALTER TABLE spotify
ALTER COLUMN EnergyLiveness FLOAT;

-- EDA (Exploratory Data Analysis)
SELECT * FROM spotify -- 20594 ROWS

SELECT COUNT(DISTINCT artist) FROM spotify -- 2074 artist
SELECT COUNT(DISTINCT album) FROM spotify -- 11798 albums
SELECT DISTINCT Album_type FROM spotify -- 3 album types --> single, album, compilation

--SELECT len(duration_min) FROM spotify
--group by len(duration_min)
--order by len(duration_min)
--having len(duration_min) = 1

--select duration_min from spotify
--where duration_min like '779343%'

--select max(duration_min) from spotify

SELECT * FROM spotify
WHERE Duration_min = 0

DELETE FROM spotify
WHERE Duration_min = 0

SELECT DISTINCT channel FROM spotify

SELECT DISTINCT most_playedon FROM spotify




--15 Practice Questions

--Easy Level
--1. Retrieve the names of all tracks that have more than 1 billion streams.
SELECT * FROM spotify
WHERE stream > 1000000000

--2. List all albums along with their respective artists.
SELECT DISTINCT Album, Artist FROM spotify -- there are same album names with different artist

SELECT DISTINCT Album FROM spotify

--3. Get the total number of comments for tracks where licensed = TRUE.
SELECT 
	SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'TRUE'

--4. Find all tracks that belong to the album type single.
SELECT * FROM spotify
WHERE Album_type = 'single'

--5. Count the total number of tracks by each artist.
SELECT 
	Artist, 
	COUNT(Track) AS num_of_track
FROM spotify
GROUP BY Artist
ORDER BY 2


--Medium Level
--1. Calculate the average danceability of tracks in each album.
UPDATE spotify
SET Danceability = Danceability / 1000

SELECT 
	distinct album,
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC

SELECT DISTINCT album FROM spotify

--2. Find the top 5 tracks with the highest energy values.
SELECT * FROM spotify

SELECT TOP 5 * FROM spotify
ORDER BY Energy DESC

--3. List all tracks along with their views and likes where official_video = TRUE.
SELECT * FROM spotify

SELECT 
	Track,
	SUM(Views) total_views,
	SUM(Likes) total_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY Track
ORDER BY 2 DESC

--4. For each album, calculate the total views of all associated tracks.
SELECT * FROM spotify

SELECT 
	Album,
	Track,
	SUM(VIEWS) AS total_views
FROM spotify
GROUP BY Album, Track
ORDER BY 3 DESC

--5. Retrieve the track names that have been streamed on Spotify more than YouTube.
SELECT * FROM 
(
SELECT 
	track,
	COALESCE(SUM(CASE WHEN most_playedon = 'Youtube' THEN stream END),0) AS streamed_on_youtube,
	COALESCE(SUM(CASE WHEN most_playedon = 'Spotify' THEN stream END),0) AS streamed_on_spotify
FROM spotify
GROUP BY track
) AS t1
WHERE
	streamed_on_spotify > streamed_on_youtube
	AND
	streamed_on_youtube <> 0

--Advanced Level
--1. Find the top 3 most-viewed tracks for each artist using window functions.
SELECT * FROM spotify

--my solution
SELECT * FROM
(
SELECT 
	artist,
	track,
	views,
	DENSE_RANK() OVER (PARTITION BY artist ORDER BY views DESC) AS rank
FROM spotify
) AS t1
WHERE rank <=3

--solution
WITH rank_art AS
(
    SELECT 
        artist,
        track,
        SUM(views) AS total_views,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM spotify
    GROUP BY artist, track
)
SELECT *
FROM rank_art
WHERE rank <= 3
ORDER BY artist, rank, total_views DESC;


--2. Write a query to find tracks where the liveness score is above the average.
SELECT * FROM spotify

SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE Liveness > (SELECT AVG(liveness) FROM spotify)

--3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
SELECT * FROM spotify

WITH energy_diff AS
(
SELECT 
	album,
	MAX(energy) AS highest_energy,
	MIN(energy) AS lowest_energy
FROM spotify
GROUP BY album
)
SELECT 
	album,
	highest_energy - lowest_energy AS energy_difference
FROM energy_diff
ORDER BY 2 DESC

--4. Find tracks where the energy-to-liveness ratio is greater than 1.2.
--problem with liveness data (data not converted accurately)
update spotify 
set Liveness = Liveness/ 1000

SELECT 
	energy,
	liveness,
	ROUND(energy / liveness, 2) energy_liveness_ratio
FROM spotify
WHERE energy / liveness > 1.2

--5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.
SELECT 
	Track,
	Views,
	Likes,
	SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes
FROM spotify
