SELECT 
    student_id,
    track_name,
    date_enrolled,
    date_completed,
    student_track_id,
    track_completed,
    days_for_completion,
    CASE
        WHEN days_for_completion = 0 THEN 'Same day'
        WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
        WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
        WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
        WHEN days_for_completion >= 366 THEN '366+ days'
    END AS completion_bucket
FROM
(SELECT student_id, track_name, date_enrolled, date_completed,
ROW_NUMBER() OVER (ORDER BY student_id, track_name DESC) AS student_track_id,
IF (date_completed IS NULL, 0,1) AS track_completed,
DATEDIFF(date_completed, date_enrolled)AS days_for_completion
FROM career_track_student_enrollments
JOIN career_track_info ON career_track_student_enrollments.track_id = career_track_info.track_id) a;
