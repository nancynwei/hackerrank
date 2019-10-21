/*
NOTE: The following code will work in MySQL	Ver 14.14 Distrib 5.7.25.
It might not work in more recent versions of MySQL, such as MySQL 8.

This is one solution (of many) to the problem "Occupation" in Hackerrank.
https://www.hackerrank.com/challenges/occupations/problem
Author: Nancy Wei
*/

# Create a "base table" with two columns: Name and Occupation.
CREATE TABLE Occupations
(
  Name varchar(10),
  Occupation varchar(25)
);

# Insert data into base table.
INSERT INTO Occupations VALUES
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
FROM Occupations;


# Create a new column to count rows for each occupation listed in the Occupation column.
SET @r1=0, @r2=0, @r3=0, @r4=0;
SELECT MIN(Doctor), MIN(Professor), MIN(Singer), MIN(Actor)
FROM(
	SELECT 
	CASE 
		WHEN Occupation='Doctor' THEN (@r1:=@r1+1)
		WHEN Occupation='Professor' then (@r2:=@r2+1)
		WHEN Occupation='Singer' then (@r3:=@r3+1)
		WHEN Occupation='Actor' then (@r4:=@r4+1) END AS RowNumber,
	CASE WHEN Occupation='Doctor' then Name end as Doctor,
    CASE WHEN Occupation='Professor' then Name end as Professor,
    CASE WHEN Occupation='Singer' then Name end as Singer,
    CASE WHEN Occupation='Actor' then Name end as Actor
	FROM OCCUPATIONS
	ORDER BY Name
) Temp
GROUP BY RowNumber;