/*
NOTE: The following code will only work in MySQL 8 or above.
Author: Nancy Wei
*/

# Create a base table.
CREATE TABLE People
(
  Name varchar(10),
  Occupation varchar(25)
);

# Insert data into this base table.
INSERT INTO People VALUES
('Samantha', 'Doctor'),
('Julia', 'Actor'),
('Maria', 'Actor'),
('Meera', 'Singer'),
('Ashely', 'Professor'),
('Ketty', 'Professor'),
('Christeen', 'Professor'),
('Jane', 'Actor'),
('Jenny', 'Doctor'),
('Priya', 'Singer');

SELECT * 
FROM People;

# Extend this base table by creating a view and add row numbers for each occupation.
CREATE VIEW People_Extended AS (
  SELECT
    ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS row_num,
  CASE WHEN Occupation = "Doctor" THEN Name END AS Doctor,
  CASE WHEN Occupation = "Professor" THEN Name END AS Professor,
  CASE WHEN Occupation = "Singer" THEN Name END AS Singer,
  CASE WHEN Occupation = "Actor" THEN Name END AS Actor
FROM People
);

SELECT * 
FROM People_Extended;

# Group and aggregate the extended table using the row numbers.
# MAX function will eliminate the rows with NULL values.
CREATE VIEW People_Extended_Pivot AS (
  SELECT
    row_num,
    MAX(Doctor) AS Doctor,
    MAX(Professor) AS Professor,
    MAX(Singer) AS Singer,
    MAX(Actor) AS Actor
  FROM People_Extended
  GROUP BY row_num
);

SELECT Doctor, Professor, Singer, Actor
FROM People_Extended_Pivot;