SELECT a.contest_id,
  a.hacker_id,
  a.name,
  IFNULL(SUM(total_submissions), 0) AS total_submissions,
  IFNULL(SUM(total_accepted_submissions), 0) AS total_accepted_submissions,
  IFNULL(SUM(total_views), 0) AS total_views,
  IFNULL(SUM(total_unique_views), 0) AS total_unique_views
  FROM contests a
  LEFT JOIN colleges b ON a.contest_id = b.contest_id
  LEFT JOIN challenges c ON b.college_id = c.college_id
  LEFT JOIN (
    SELECT challenge_id,
      SUM(total_submissions) AS total_submissions,
      SUM(total_accepted_submissions) AS total_accepted_submissions
    FROM submission_stats
    GROUP BY challenge_id
  ) d ON c.challenge_id = d.challenge_id
  LEFT JOIN (
    SELECT challenge_id,
      SUM(total_views) AS total_views,
      SUM(total_unique_views) AS total_unique_views
    FROM view_stats
    GROUP BY challenge_id
  ) e ON c.challenge_id = e.challenge_id
GROUP BY a.contest_id,
  a.hacker_id,
  a.name
HAVING SUM(total_submissions) != 0
  OR SUM(total_accepted_submissions) != 0
  OR SUM(total_views) != 0
  OR SUM(total_unique_views) != 0;