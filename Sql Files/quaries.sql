USE cook_show;

-- 3.1
-- Average Score by Chef

CREATE OR REPLACE VIEW avg_score_chef AS
SELECT c.name AS cook_name, c.surname, AVG(s.final_score) AS average_score
FROM cook c
JOIN score s ON c.cook_id = s.cook_id
GROUP BY c.name, c.surname
ORDER BY average_score DESC;  

-- Average Score by National Cuisine
CREATE OR REPLACE VIEW avg_score_National_Cuisine AS
SELECT 
    r.national_cuisine, 
    AVG(s.final_score) AS average_score
FROM 
    recipe r
JOIN 
    score s ON r.recipe_id = s.recipe_id
GROUP BY 
    r.national_cuisine
ORDER BY 
    average_score DESC;

-- 3.2 
use cook_show;
CREATE OR REPLACE VIEW given_pair_participation AS
WITH pairs AS (
    SELECT DISTINCT e.season, r.national_cuisine
    FROM episode e
    CROSS JOIN recipe r
),


participation AS (
    SELECT DISTINCT
        e.season,
        r.national_cuisine,
        c.cook_id,
        'Participated in episodes' AS cook_status
    FROM episode e
    JOIN participates_in pi ON e.episode_id = pi.episode_id
    JOIN cook c ON pi.cook_id = c.cook_id
    JOIN is_cooked_from icf ON c.cook_id = icf.cook_id
    JOIN recipe r ON icf.recipe_id = r.recipe_id
),


non_participation AS (
    SELECT
        pair.season,
        pair.national_cuisine,
        c.cook_id,
        'Not Participated' AS cook_status
    FROM pairs pair
    CROSS JOIN cook c
    LEFT JOIN (
        SELECT DISTINCT
            e.season,
            r.national_cuisine,
            c.cook_id
        FROM episode e
        JOIN participates_in pi ON e.episode_id = pi.episode_id
        JOIN cook c ON pi.cook_id = c.cook_id
        JOIN is_cooked_from icf ON c.cook_id = icf.cook_id
        JOIN recipe r ON icf.recipe_id = r.recipe_id
    ) participated
    ON pair.season = participated.season
    AND pair.national_cuisine = participated.national_cuisine
    AND c.cook_id = participated.cook_id
    WHERE participated.cook_id IS NULL
),


combined AS (
    SELECT * FROM participation
    UNION ALL
    SELECT * FROM non_participation
)

SELECT
    c.name,
    c.surname,
    co.national_cuisine,
    co.season AS recipe_year,
    co.cook_status
FROM cook c
JOIN combined co ON c.cook_id = co.cook_id
GROUP BY
    c.name,
    c.surname,
    co.national_cuisine,
    co.season,
    co.cook_status
ORDER BY 
    co.national_cuisine,
    co.season;

-- 3.3. 
CREATE OR REPLACE VIEW young_cooks AS
SELECT 
    c.name AS chef_name, 
    c.surname AS chef_surname,
    COUNT(r.recipe_id) AS recipe_count
FROM 
    cook c
JOIN 
    participates_in pi ON c.cook_id = pi.cook_id
JOIN 
    episode e ON pi.episode_id = e.episode_id
JOIN 
    is_cooked_from icf ON c.cook_id = icf.cook_id
JOIN 
    recipe r ON icf.recipe_id = r.recipe_id
WHERE 
    e.season - YEAR(c.birth_date) < 30
GROUP BY 
    c.name, c.surname
ORDER BY 
    recipe_count DESC
LIMIT 10; 

-- 3.4.
CREATE OR REPLACE VIEW i_never_judge AS 
SELECT 
    c.name AS chef_name,
    c.surname AS chef_surname
FROM 
    cook c
WHERE 
    c.cook_id NOT IN (
        SELECT 
            cook_id
        FROM 
            participates_in
        WHERE 
            role = 'judge'
);

-- 3.5. 
CREATE OR REPLACE VIEW same_number_of_judges_in_one_year AS
SELECT combined_cooks.cook_id, c.name, c.surname, combined_cooks.seasons
FROM (
  SELECT p1.cook_id AS cook_id, CONCAT(MIN(e1.season), ',', MAX(e2.season)) AS seasons
  FROM participates_in p1
  JOIN participates_in p2 ON p1.episode_id = p2.episode_id
                          AND p1.cook_id < p2.cook_id
  JOIN (
    SELECT pi.cook_id, COUNT(*) AS episode_count
    FROM participates_in pi
    JOIN episode e ON pi.episode_id = e.episode_id
    GROUP BY pi.cook_id
    HAVING COUNT(*) > 3
  ) ep1 ON p1.cook_id = ep1.cook_id
  JOIN (
    SELECT pi.cook_id, COUNT(*) AS episode_count
    FROM participates_in pi
    JOIN episode e ON pi.episode_id = e.episode_id
    GROUP BY pi.cook_id
    HAVING COUNT(*) > 3
  ) ep2 ON p2.cook_id = ep2.cook_id
  JOIN episode e1 ON p1.episode_id = e1.episode_id
  JOIN episode e2 ON p2.episode_id = e2.episode_id
  WHERE ABS(e1.season - e2.season) <= 1
  GROUP BY p1.cook_id, p2.cook_id

  UNION

  SELECT p2.cook_id AS cook_id, CONCAT(MIN(e1.season), ',', MAX(e2.season)) AS seasons
  FROM participates_in p1
  JOIN participates_in p2 ON p1.episode_id = p2.episode_id
                          AND p1.cook_id < p2.cook_id
  JOIN (
    SELECT pi.cook_id, COUNT(*) AS episode_count
    FROM participates_in pi
    JOIN episode e ON pi.episode_id = e.episode_id
    GROUP BY pi.cook_id
    HAVING COUNT(*) > 3
  ) ep1 ON p1.cook_id = ep1.cook_id
  JOIN (
    SELECT pi.cook_id, COUNT(*) AS episode_count
    FROM participates_in pi
    JOIN episode e ON pi.episode_id = e.episode_id
    GROUP BY pi.cook_id
    HAVING COUNT(*) > 3
  ) ep2 ON p2.cook_id = ep2.cook_id
  JOIN episode e1 ON p1.episode_id = e1.episode_id
  JOIN episode e2 ON p2.episode_id = e2.episode_id
  WHERE ABS(e1.season - e2.season) <= 1
  GROUP BY p1.cook_id, p2.cook_id
) AS combined_cooks
JOIN cook c ON combined_cooks.cook_id = c.cook_id
ORDER BY combined_cooks.cook_id;

-- 3.6.
CREATE OR REPLACE VIEW most_common_pairs AS
SELECT 
  T1.tag AS Tag1, 
  T2.tag AS Tag2, 
  COUNT(*) AS EpisodeCount
FROM 
  is_tagged IT1
  JOIN is_tagged IT2 ON IT1.recipe_id = IT2.recipe_id
  JOIN recipe R ON IT1.recipe_id = R.recipe_id
  JOIN score S ON R.recipe_id = S.recipe_id
  JOIN episode E ON S.episode_id = E.episode_id
  JOIN tag T1 ON IT1.tag_id = T1.tag_id
  JOIN tag T2 ON IT2.tag_id = T2.tag_id
WHERE 
  IT1.tag_id < IT2.tag_id
GROUP BY 
  T1.tag, T2.tag
  ORDER BY 
  EpisodeCount desc
LIMIT 3;

-- 3.7.
CREATE OR REPLACE VIEW five_times_less_than_most AS
WITH ChefParticipation AS (
    SELECT 
        cook_id, 
        COUNT(*) AS participation_count
    FROM 
        participates_in
    WHERE
        role = 'chef'
    GROUP BY 
        cook_id
),
MaxParticipation AS (
    SELECT 
        MAX(participation_count) AS max_count
    FROM 
        ChefParticipation
)
SELECT 
    c.name AS chef_name,
    c.surname AS chef_surname
FROM 
    ChefParticipation cp
JOIN 
    cook c ON cp.cook_id = c.cook_id
WHERE 
    cp.participation_count <= (
        SELECT max_count - 5 FROM MaxParticipation
    );

-- 3.8.
CREATE OR REPLACE VIEW most_utensils_num AS
SELECT 
    e.episode_id, 
    COUNT(r.utensil_id) AS equipment_count
FROM 
    episode e
JOIN 
    requires r ON e.episode_id = r.recipe_id
GROUP BY 
    e.episode_id
ORDER BY 
    equipment_count DESC
LIMIT 1;

-- 3.9
CREATE OR avg_carbohudrates AS
SELECT
    e.season,
    AVG(i.carbs_per_100) AS avg_carbohydrates
FROM
    episode e
JOIN
    participates_in pi ON e.episode_id = pi.episode_id
JOIN
    cook c ON pi.cook_id = c.cook_id
JOIN
    is_cooked_from icf ON c.cook_id = icf.cook_id
JOIN
    recipe r ON icf.recipe_id = r.recipe_id
JOIN
    consists_of co ON r.recipe_id = co.recipe_id
JOIN
    ingredients i ON co.ingredients_id = i.ingredients_id
GROUP BY
    e.season
LIMIT 1000;

-- 3.10.
CREATE OR REPLACE VIEW Consecutive_years AS 
WITH YearlyParticipations AS (
    SELECT 
        r.national_cuisine, 
        e.season AS year, 
        COUNT(DISTINCT e.episode_id) AS participation_count
    FROM 
        recipe r
    JOIN 
        score s ON r.recipe_id = s.recipe_id
    JOIN 
        episode e ON s.episode_id = e.episode_id
    GROUP BY 
        r.national_cuisine, e.season
    HAVING 
        COUNT(DISTINCT e.episode_id) >= 3
),
ConsecutiveYearPairs AS (
    SELECT 
        yp1.national_cuisine, 
        yp1.year AS year1, 
        yp2.year AS year2, 
        yp1.participation_count AS year1_count, 
        yp2.participation_count AS year2_count
    FROM 
        YearlyParticipations yp1
    JOIN 
        YearlyParticipations yp2 ON yp1.national_cuisine = yp2.national_cuisine AND yp1.year = yp2.year - 1
)
SELECT 
    national_cuisine, 
    year1, 
    year2, 
    year1_count, 
    year2_count
FROM 
    ConsecutiveYearPairs
WHERE 
    year1_count = year2_count;

-- 3.11
CREATE OR REPLACE VIEW top_judges AS
SELECT 
    cj.name AS judge_name,
    cc.name AS chef_name,
    SUM(cf.score) AS total_score
FROM 
    score s
JOIN 
    comes_from cf ON s.score_triple_id = cf.score_triple_id
JOIN 
    participates_in pi_judge ON cf.cook_id = pi_judge.cook_id AND pi_judge.role = 'judge'
JOIN 
    participates_in pi_chef ON s.cook_id = pi_chef.cook_id AND pi_chef.role = 'chef'
JOIN 
    cook cj ON pi_judge.cook_id = cj.cook_id
JOIN 
    cook cc ON s.cook_id = cc.cook_id
GROUP BY 
    cj.name, cc.name
ORDER BY 
    total_score DESC
LIMIT 5;

-- 3.12
CREATE OR REPLACE VIEW hardest_episode AS
SELECT
    e.season,
    e.episode_id,
    AVG(r.difficulty) AS avg_difficulty
FROM
    episode e
JOIN
    participates_in pi ON e.episode_id = pi.episode_id
JOIN
    cook c ON pi.cook_id = c.cook_id
JOIN
    is_cooked_from icf ON c.cook_id = icf.cook_id
JOIN
    recipe r ON icf.recipe_id = r.recipe_id
GROUP BY
    e.season, e.episode_id
ORDER BY
    avg_difficulty DESC
LIMIT 1;

-- 3.13.
CREATE OR REPLACE VIEW least_pro_episode AS
SELECT 
    e.episode_id, 
    SUM(c.experience) AS total_experience
FROM 
    episode e
JOIN 
    participates_in pi ON e.episode_id = pi.episode_id
JOIN 
    cook c ON pi.cook_id = c.cook_id
GROUP BY 
    e.episode_id
ORDER BY 
    total_experience ASC
LIMIT 1;

-- 3.14.
CREATE OR REPLACE VIEW  most_used_thematic AS
SELECT 
    t.topic_name, 
    COUNT(ht.episode_id) AS appearance_count
FROM 
    topics t
JOIN 
    has_topic ht ON t.topic_name = ht.topic_name
GROUP BY 
    t.topic_name
ORDER BY 
    appearance_count DESC
LIMIT 1;

-- 3.15
CREATE OR REPLACE VIEW np_food_groups AS
SELECT 
    fg.name AS food_group
FROM 
    food_groups fg
WHERE 
    fg.food_group_id NOT IN (
        SELECT DISTINCT 
            i.food_group_id
        FROM 
            ingredients i
        JOIN 
            consists_of co ON i.ingredients_id = co.ingredients_id
        JOIN 
            recipe r ON co.recipe_id = r.recipe_id
    );
