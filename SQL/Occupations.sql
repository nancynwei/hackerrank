/*
NOTE: The following code will only work in MySQL 8 or above.

STEP 1: Select the columns of interest, i.e. y-values and x-values
extend the base table with extra columns -- one for each x-value
group and aggregate the extended table -- one group for each y-value
(optional) prettify the aggregated table
*/


# Create a "base table"
CREATE TABLE People
(
  Name varchar(10),
  Occupation varchar(25)
);


# Insert data into this base table
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


# See all data from the base table
SELECT * 
FROM People;


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



# Group and aggregate the extended table. 
# We need to group by row_num, since it provides the y-values.
create view People_Extended_Pivot as (
  select
    row_num,
    max(Doctor) as Doctor,
    max(Professor) as Professor,
    max(Singer) as Singer,
    max(Actor) as Actor
  from People_Extended
  group by row_num
);

SELECT * 
FROM People_Extended_Pivot;
