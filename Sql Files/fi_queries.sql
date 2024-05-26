-- 3.6 , 3.8 force indexes

-- 3.6
CREATE INDEX idx_is_tagged_recipe_id_tag_id ON is_tagged (recipe_id, tag_id);
CREATE INDEX idx_score_recipe_id_episode_id ON score (recipe_id, episode_id);

SELECT
  T1.tag AS Tag1,
  T2.tag AS Tag2,
  COUNT(*) AS EpisodeCount
FROM
  is_tagged IT1 FORCE INDEX (idx_is_tagged_recipe_id_tag_id)
  JOIN is_tagged IT2 FORCE INDEX (idx_is_tagged_recipe_id_tag_id) ON IT1.recipe_id = IT2.recipe_id
  JOIN recipe R FORCE INDEX (PRIMARY) ON IT1.recipe_id = R.recipe_id
  JOIN score S FORCE INDEX (idx_score_recipe_id_episode_id) ON R.recipe_id = S.recipe_id
  JOIN episode E FORCE INDEX (PRIMARY) ON S.episode_id = E.episode_id
  JOIN tag T1 FORCE INDEX (PRIMARY) ON IT1.tag_id = T1.tag_id
  JOIN tag T2 FORCE INDEX (PRIMARY) ON IT2.tag_id = T2.tag_id
WHERE
  IT1.tag_id < IT2.tag_id
GROUP BY
  T1.tag, T2.tag
ORDER BY
  EpisodeCount DESC
LIMIT 3;

-- 3.8
SET profiling = 1;
CREATE INDEX idx_recipe_utensil ON requires (recipe_id, utensil_id);
EXPLAIN SELECT
    e.episode_id,
    COUNT(r.utensil_id) AS equipment_count
FROM
    episode e FORCE INDEX (PRIMARY)
JOIN
    requires r FORCE INDEX (idx_recipe_utensil) ON e.episode_id = r.recipe_id
GROUP BY
    e.episode_id
ORDER BY
    equipment_count DESC
LIMIT 1;
SHOW PROFILES;


