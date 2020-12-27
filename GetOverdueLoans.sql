WITH transactions AS (
  SELECT tmptab.Deal, tmptab.Date, tmptab.Sum, tmptab.AfterCurrentRowAmount, tmptab.RowNum,
	CASE
          WHEN (
            COALESCE (
              LAG(tmptab.AfterCurrentRowAmount) OVER (PARTITION BY tmptab.Deal ORDER BY tmptab.Deal, tmptab.Date), 0) <= 0
          ) THEN tmptab.Date
          ELSE NULL
        END AS OverDueDate
  FROM (
      SELECT PDCL.Deal, PDCL.Date, PDCL.Sum,
	SUM(PDCL.Sum) OVER (PARTITION BY Deal ORDER BY Date) AS AfterCurrentRowAmount,
	ROW_NUMBER() OVER (PARTITION BY Deal ORDER BY Date DESC) AS RowNum
      FROM PDCL
    ) tmptab
)
SELECT *, date_part('day', current_timestamp - final_tbl.RunningOverDue::timestamp) OverDuePeriod
FROM (
SELECT transwrk.Deal, transwrk.AfterCurrentRowAmount,
  CASE
      WHEN transwrk.OverDueDate IS NOT NULL THEN transwrk.OverDueDate
      WHEN transwrk.AfterCurrentRowAmount <= 0 THEN NULL
      ELSE (SELECT max(tmptab_2.OverDueDate)
              FROM transactions tmptab_2
              WHERE transwrk.Deal = tmptab_2.Deal
                AND tmptab_2.Date <= transwrk.Date
            )
      END AS RunningOverDue
FROM transactions transwrk
WHERE transwrk.RowNum = 1
  AND transwrk.AfterCurrentRowAmount <> 0
ORDER BY transwrk.Deal, transwrk.Date) AS final_tbl;
