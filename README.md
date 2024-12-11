# Spotify Advanced SQL Project

Dataset: [Dataset](https://www.kaggle.com/datasets/sanjanchaudhari/spotify-dataset)

## Overview
This project involves analyzing a Spotify dataset with various attributes about tracks, albums, and artists using **SQL**. It covers an end-to-end process of normalizing a denormalized dataset, performing SQL queries of varying complexity (easy, medium, and advanced), and optimizing query performance. The primary goals of the project are to practice advanced SQL skills and generate valuable insights from the dataset.

```sql
-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);
```
## Project Steps

### 1. Data Exploration
The dataset contains attributes such as:
- `Artist`: The performer of the track.
- `Track`: The name of the song.
- `Album`: The album to which the track belongs.
- `Album_type`: The type of album (e.g., single or album).
- Various metrics such as `danceability`, `energy`, `loudness`, `tempo`, and more.

### 2. Querying the Data
Queries are categorized into **easy**, **medium**, and **advanced** levels to help progressively develop SQL proficiency.

#### Easy Queries
- Simple data retrieval, filtering, and basic aggregations.
  
#### Medium Queries
- More complex queries involving grouping, aggregation functions, and joins.
  
#### Advanced Queries
- Nested subqueries, window functions, CTEs, and performance optimization.
  
---

## 15 Practice Questions

### Easy Level
1. Retrieve the names of all tracks that have more than 1 billion streams.
   
```sql
SELECT * FROM spotify
WHERE stream > 1000000000
```

2. List all albums along with their respective artists.
   
```sql
SELECT DISTINCT Album, Artist FROM spotify
```

3. Get the total number of comments for tracks where `licensed = TRUE`.

```sql
SELECT 
	SUM(comments) AS total_comments
FROM spotify
WHERE licensed = 'TRUE'
```

4. Find all tracks that belong to the album type `single`.

```sql
SELECT * FROM spotify
WHERE Album_type = 'single'
```

5. Count the total number of tracks by each artist.

```sql
SELECT 
	Artist, 
	COUNT(Track) AS num_of_track
FROM spotify
GROUP BY Artist
ORDER BY 2
```

### Medium Level
1. Calculate the average danceability of tracks in each album.
   
```sql
SELECT 
	DISTINCT album,
	AVG(danceability) AS avg_danceability
FROM spotify
GROUP BY album
ORDER BY 2 DESC
```

2. Find the top 5 tracks with the highest energy values.

```sql
SELECT TOP 5 * FROM spotify
ORDER BY Energy DESC
```

3. List all tracks along with their views and likes where `official_video = TRUE`.

```sql
SELECT 
	Track,
	SUM(Views) total_views,
	SUM(Likes) total_likes
FROM spotify
WHERE official_video = 'TRUE'
GROUP BY Track
ORDER BY 2 DESC
```

4. For each album, calculate the total views of all associated tracks.

```sql
SELECT 
	Album,
	Track,
	SUM(VIEWS) AS total_views
FROM spotify
GROUP BY Album, Track
ORDER BY 3 DESC
```

5. Retrieve the track names that have been streamed on Spotify more than YouTube.
    
```sql
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
```

### Advanced Level
1. Find the top 3 most-viewed tracks for each artist using window functions.

```sql
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
```

2. Write a query to find tracks where the liveness score is above the average.

```sql
SELECT 
	track,
	artist,
	liveness
FROM spotify
WHERE Liveness > (SELECT AVG(liveness) FROM spotify)
```

3. **Use a `WITH` clause to calculate the difference between the highest and lowest energy values for tracks in each album.**
```sql
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
```

## Technology Stack
- **Database**: Microsoft SQL Server
- **SQL Queries**: DDL, DML, Aggregations, Joins, Subqueries, Window Functions
- **Tools**: SQL Server Management Studio 20

---

## License
This project is licensed under the MIT License.
