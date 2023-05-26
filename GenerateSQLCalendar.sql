
-- SQLite3: Generate SQL Calendar

DROP TABLE IF EXISTS calendar;
CREATE TABLE IF NOT EXISTS calendar (
	cDate date UNIQUE NOT NULL,
	cDayofWeek INT NOT NULL,
	cWeekday INT NOT NULL,
	cQuarter INT NOT NULL,
	cYear INT NOT NULL,
	cMonth INT NOT NULL,
	cDay INT NOT NULL,
	cDayofYear INT NOT NULL,
	cWeekofYear INT NOT NULL,
	cWeekofYearIso INT NOT NULL
);
INSERT
  OR ignore INTO calendar ( cDate, cDayofWeek, cWeekday, cQuarter, cYear, cMonth, cDay, cDayofYear, cWeekofYear, cWeekofYearIso )
SELECT *
FROM (
  WITH RECURSIVE dates( cDate ) AS (
    VALUES( '2023-01-01' )
    UNION ALL
    SELECT date( cDate, '+1 day' )
    FROM dates
    WHERE cDate < '2023-12-31'
  )
  SELECT cDate,
    ( CAST( strftime( '%w', cDate ) AS INT ) + 6 ) % 7 AS cDayofWeek,
    CASE
      ( CAST( strftime( '%w', cDate ) AS INT ) + 6 ) % 7
      WHEN 0 THEN 'Monday'
      WHEN 1 THEN 'Tuesday'
      WHEN 2 THEN 'Wednesday'
      WHEN 3 THEN 'Thursday'
      WHEN 4 THEN 'Friday'
      WHEN 5 THEN 'Saturday'
      ELSE 'Sunday'
    END AS cWeekday,
    CASE
      WHEN CAST( strftime( '%m', cDate ) AS INT ) BETWEEN 1 AND 3 THEN 1
      WHEN CAST( strftime( '%m', cDate ) AS INT ) BETWEEN 4 AND 6 THEN 2
      WHEN CAST( strftime( '%m', cDate ) AS INT ) BETWEEN 7 AND 9 THEN 3
      ELSE 4
    END AS cQuarter,
    CAST( strftime( '%Y', cDate ) AS INT ) AS cYear,
    CAST( strftime( '%m', cDate ) AS INT ) AS cMonth,
    CAST( strftime( '%d', cDate ) AS INT ) AS cDay,
	CAST( strftime( '%j', cDate ) AS INT ) AS cDayofYear,
	CAST( strftime( '%W', cDate ) AS INT ) AS cWeekofYear,
	CAST( ( strftime( '%j', date( cDate, '-3 days', 'weekday 4' ) ) - 1 ) / 7 + 1 AS INT ) AS cWeekofYearIso
  FROM dates
);