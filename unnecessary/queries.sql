***********************QUERY 1*********************************
************average by chef*********************************

  
  SELECT
  c.name AS cook_name,
  c.surname,
  AVG(s.final_score) AS average_score
FROM
  cook c
  JOIN score s ON c.cook_id = s.cook_id
GROUP BY
  c.name, c.surname
ORDER BY
  c.name, c.surname;



************************1b**********************

SELECT
  r.national_cuisine,
  AVG(s.final_score) AS average_score
FROM
  recipe r
  JOIN is_cooked_from icf ON r.recipe_id = icf.recipe_id
  JOIN score s ON s.recipe_id = r.recipe_id
GROUP BY
  r.national_cuisine
ORDER BY***not nes
  r.national_cuisine;

***********************QUERY2*********************************
********CHANGE TO BE MADE TO EPISODE TABLE  *******
SELECT
  c.cook_id,
  c.name,
  c.surname
FROM
  cook c
  JOIN is_cooked_from icf ON c.cook_id = icf.cook_id
  JOIN recipe r ON icf.recipe_id = r.recipe_id
  JOIN score s ON s.recipe_id = r.recipe_id AND s.cook_id = c.cook_id
  JOIN episode e ON s.episode_id = e.episode_id
WHERE
  r.national_cuisine = 'Italian'
  AND EXTRACT(YEAR FROM e.episode_date) = 2023
ORDER BY
  c.name, c.surname;


OR TO BE DISCUSSED 

SELECT
  c.cook_id,
  c.name,
  c.surname
FROM
  cook c
  JOIN is_cooked_from icf ON c.cook_id = icf.cook_id
  JOIN recipe r ON icf.recipe_id = r.recipe_id
WHERE
  r.national_cuisine = 'Italian'  
ORDER BY
  c.name, c.surname;

SELECT
  c.cook_id,
  c.name,
  c.surname
FROM
  cook c
  JOIN is_cooked_from icf ON c.cook_id = icf.cook_id
  JOIN recipe r ON icf.recipe_id = r.recipe_id
WHERE
  r.national_cuisine = 'Italian'  
ORDER BY
  c.name, c.surname;

***********************QUERY3*********************************

CREATE OR REPLACE VIEW YoungCooks AS
SELECT
  c.name AS CookName,
  COUNT(0) AS NumRecipes
FROM
  cook c
  JOIN is_cooked_from icf ON c.cook_id = icf.cook_id
WHERE
  c.age < 30  
GROUP BY
  c.cook_id
HAVING
  COUNT(0) = (
    SELECT
      COUNT(0)
    FROM
      cook c_inner
      JOIN is_cooked_from icf_inner ON c_inner.cook_id = icf_inner.cook_id
    WHERE
      c_inner.age < 30
    GROUP BY
      c_inner.cook_id
    ORDER BY
      COUNT(0) DESC
    LIMIT
      1
  );

***********************QUERY4*********************************
