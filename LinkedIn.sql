CREATE TABLE Payment (
    Date DATE,
    MemberId VARCHAR(20),
    Amount DECIMAL(10,2)
);

CREATE TABLE Visitor (
    Date DATE,
    MemberId VARCHAR(20)
);

CREATE TABLE Dates (
    Date DATE
);


/*
This table contains all the payment amounts on a date and member level. A sample of data looks like this:
*/
INSERT INTO Payment (Date, MemberId, Amount)
VALUES 
('2019-01-03', 'A', 33.9),
('2019-01-04', 'C', 19.3),
('2019-01-07', 'A', 29.1),
('2019-01-04', 'C', 30.7),
('2019-01-04', 'A', 30.7),
('2019-01-07', 'A', 107.6);

/*
This table contains all the site visit records on a date and member level. There is row for each member who visited the linkedin.com site on each day. A sample of data looks like this:
*/
INSERT INTO Visitor (Date, MemberId)
VALUES 
('2019-01-01', 'A'),
('2019-01-03', 'A'),
('2019-01-03', 'B'),
('2019-01-04', 'A'),
('2019-01-04', 'C'),
('2019-01-05', 'A'),
('2019-01-06', 'C'),
('2019-01-07', 'C'),
('2019-01-07', 'B');

/*
This table contains a row for each date:
*/
INSERT INTO Dates (Date)
VALUES 
('2019-01-01'),
('2019-01-02'),
('2019-01-03'),
('2019-01-04'),
('2019-01-05'),
('2019-01-06'),
('2019-01-07'),
('2019-01-08'),
('2019-01-09');

SELECT * FROM Payment;
SELECT * FROM Visitor;
SELECT * FROM Dates;

/*
Q1: Total Revenue & Payers: Create a table to display total revenue & number of buyers on each day
Date  revenue  buyers
*/
SELECT Date, SUM(Amount) AS Revenue, COUNT(*) AS Buyers
FROM Payment
GROUP BY Date;

/*
Q2: Top payers: Create a table to display the top one payer on each day
Date  memberID
*/
SELECT Date, MemberId, MAX(Amount)
FROM Payment
GROUP BY MemberId, Date
ORDER BY Date ASC;

/*
Q3: A distribution of # days active within a week: Create a table to show how many members are active for 1 day, 2days, 3days,… 7days during 3/1-3/7.
#DaysActive  Count
*/
CREATE VIEW Visitor_Extended AS (
  SELECT d.Date, v.MemberId
  FROM Dates AS d LEFT JOIN Visitor AS v
    ON d.Date = v.Date
  WHERE d.Date BETWEEN '2019-01-01' AND '2019-01-07'
  GROUP BY d.Date, v.MemberId
  ORDER BY d.Date);

SELECT * FROM Visitor_Extended;


CREATE VIEW Visitor_Extended_Pivot AS (
  SELECT
    ROW_NUMBER() OVER (PARTITION BY Date ORDER BY MemberId) AS row_num,
  CASE WHEN MemberId = "A" THEN Date END AS A,
  CASE WHEN MemberId = "B" THEN Date END AS B,
  CASE WHEN MemberId = "C" THEN Date END AS C
FROM Visitor_Extended
);

SELECT * FROM Visitor_Extended_Pivot;

# Group and aggregate the extended table using the row numbers.
# MAX function will eliminate the rows with NULL values.
CREATE VIEW DaysActive AS (
  SELECT 
    COUNT(A) AS A, COUNT(B) AS B, COUNT(C) AS C
  FROM Visitor_Extended_Pivot
);

SELECT * FROM DaysActive;


/*
Q4: Active but not payers: Create a table to display people who were active but did not pay on each day.
Date  memberID
*/
CREATE VIEW Payment_Extended AS (
  SELECT d.Date AS DatePaid, p.MemberId AS PaidMemberId
  FROM Dates AS d LEFT JOIN Payment AS p
    ON d.Date = p.Date
  GROUP BY d.Date, p.MemberId
  ORDER BY d.Date);

SELECT * FROM Payment_Extended;