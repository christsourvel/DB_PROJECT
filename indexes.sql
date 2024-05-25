-- Indexes to be created
CREATE INDEX idx_cook_name_surname ON cook(name, surname);
CREATE INDEX idx_score_cook_id ON score(cook_id);
CREATE INDEX idx_score_recipe_id ON score(recipe_id);
CREATE INDEX idx_recipe_national_cuisine ON recipe(national_cuisine);
CREATE INDEX idx_recipe_id ON recipe(recipe_id); -- assuming this is for the 'requires' table in one of the queries
CREATE INDEX idx_episode_season ON episode(season);
CREATE INDEX idx_cook_experience ON cook(experience);
CREATE INDEX idx_score_final_score ON score(final_score);
CREATE INDEX idx_participates_in_role ON participates_in(role);
