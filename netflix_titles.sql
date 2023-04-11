-- Create the 'netflix_titles' table
CREATE TABLE netflix_titles (
    show_id VARCHAR(255) PRIMARY KEY,
    type VARCHAR(255),
    title VARCHAR(255),
    director VARCHAR(255),
    cast VARCHAR(255),
    country VARCHAR(255),
    date_added DATE,
    release_year INT,
    rating VARCHAR(255),
    duration VARCHAR(255),
    listed_in VARCHAR(255),
    description TEXT
);

-- Create the 'genres' table
CREATE TABLE genres (
    genre_id INT PRIMARY KEY,
    genre_name VARCHAR(255)
);

-- Create the 'netflix_title_genres' table for many-to-many relationship between 'netflix_titles' and 'genres' tables
CREATE TABLE netflix_title_genres (
    show_id VARCHAR(255),
    genre_id INT,
    FOREIGN KEY (show_id) REFERENCES netflix_titles(show_id),
    FOREIGN KEY (genre_id) REFERENCES genres(genre_id)
);

-- Load data from CSV into the 'netflix_titles' table
LOAD DATA INFILE '/path/to/netflix_titles.csv' INTO TABLE netflix_titles
FIELDS TERMINATED BY ',' -- Set the delimiter used in your CSV file
ENCLOSED BY '"' -- Set the character used to enclose fields that contain special characters
LINES TERMINATED BY '\n' -- Set the line terminator used in your CSV file
IGNORE 1 ROWS; -- Skip the header row of the CSV file

-- Load data into the 'genres' table (assuming genre_id is auto-incremented)
INSERT INTO genres (genre_name)
VALUES ('Drama'), ('Comedy'), ('Thriller'), ('Action'), ('Documentary'), ('Romance'), ('Sci-Fi');

-- Load data into the 'netflix_title_genres' table based on the 'listed_in' column in the 'netflix_titles' table
INSERT INTO netflix_title_genres (show_id, genre_id)
SELECT show_id, genre_id
FROM netflix_titles
CROSS JOIN genres
WHERE FIND_IN_SET(genre_name, listed_in) > 0;

-- Example: Extracting Netflix titles with their associated genres and average release year for each genre
SELECT n.title, g.genre_name, AVG(n.release_year) AS avg_release_year
FROM netflix_titles n
JOIN netflix_title_genres ntg ON n.show_id = ntg.show_id
JOIN genres g ON ntg.genre_id = g.genre_id
GROUP BY n.title, g.genre_name
ORDER BY g.genre_name, avg_release_year DESC;
