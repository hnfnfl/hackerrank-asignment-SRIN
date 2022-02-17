SELECT submission_date,
  (
    SELECT COUNT(DISTINCT hacker_id)
    FROM submissions B
    WHERE B.submission_date = A.submission_date
      AND (
        SELECT COUNT(DISTINCT C.submission_date)
        FROM submissions C
        WHERE C.hacker_id = B.hacker_id
          AND C.submission_date < A.submission_date
      ) = dateDIFF(A.submission_date, '2016-03-01')
  ) AS unique_hacker,
  (
    SELECT hacker_id
    FROM submissions
    WHERE submission_date = A.submission_date
    GROUP BY hacker_id
    ORDER BY COUNT(submission_id) DESC,
      hacker_id
    LIMIT 1
  ) AS top_hacker,
  (
    SELECT name
    FROM hackers
    WHERE hacker_id = top_hacker
  ) AS top_hacker_name
FROM submissions A
GROUP BY submission_date;