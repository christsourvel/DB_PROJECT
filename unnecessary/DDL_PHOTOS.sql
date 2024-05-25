use cook_show;
DROP TABLE IF EXISTS recipe_tips;
DROP TABLE IF EXISTS is_tagged;
DROP TABLE IF EXISTS requires;
DROP TABLE IF EXISTS is_a;
DROP TABLE IF EXISTS is_made;
DROP TABLE IF EXISTS consists_of;
DROP TABLE IF EXISTS has;
DROP TABLE IF EXISTS sum_of;
DROP TABLE IF EXISTS belongs_to;
DROP TABLE IF EXISTS specialization;
DROP TABLE IF EXISTS is_cooked_from;
DROP TABLE IF EXISTS participates_in;
DROP TABLE IF EXISTS has_topic;
DROP TABLE IF EXISTS comes_from;
DROP TABLE IF EXISTS score;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS permissions;
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS recipe;
DROP TABLE IF EXISTS tag;
DROP TABLE IF EXISTS utensils;
DROP TABLE IF EXISTS meal_type;
DROP TABLE IF EXISTS steps;
DROP TABLE IF EXISTS label;
DROP TABLE IF EXISTS ingredients;
DROP TABLE IF EXISTS food_groups;
DROP TABLE IF EXISTS topics;
DROP TABLE IF EXISTS cook;
DROP TABLE IF EXISTS episode;
DROP TABLE IF EXISTS nutritional_info;

CREATE TABLE recipe (
  recipe_id integer,
  name varchar(100) NOT NULL,
  description TEXT NOT NULL,
  difficulty integer NOT NULL,
  national_cuisine varchar(20) NOT NULL,
  number_of_quantities integer NOT NULL,
  preparation_time integer NOT NULL,
  cooking_time integer NOT NULL,
  type varchar(50) NOT NULL,
  portions int NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(recipe_id),
  CONSTRAINT difficulty_constraint CHECK (difficulty IN (1, 2, 3, 4, 5)),
  CONSTRAINT portions_constraint CHECK (portions > 0),
  CONSTRAINT preparation_time_constraint CHECK (preparation_time > 0),
  CONSTRAINT cooking_time_constraint CHECK (cooking_time > 0)
);

CREATE TABLE recipe_tips (
  recipe_id integer, 
  tips VARCHAR(255),
  PRIMARY KEY(recipe_id, tips),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
);

CREATE TABLE tag (
  tag_id integer, 
  tag varchar(50) NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(tag_id)
);

CREATE TABLE is_tagged (
  recipe_id integer,
  tag_id integer,
  PRIMARY KEY(recipe_id, tag_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (tag_id) REFERENCES tag(tag_id)
);

CREATE TABLE utensils (
  utensil_id integer NOT NULL,
  name varchar(50) NOT NULL,
  instructions TEXT NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(utensil_id)
);

CREATE TABLE requires (
  recipe_id integer,
  utensil_id integer,
  PRIMARY KEY(recipe_id, utensil_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (utensil_id) REFERENCES utensils(utensil_id)
);

CREATE TABLE meal_type (
  meal_type_name varchar(50),
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(meal_type_name)
);

CREATE TABLE is_a (
  recipe_id integer,
  meal_type_name varchar(50),
  PRIMARY KEY(recipe_id, meal_type_name),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (meal_type_name) REFERENCES meal_type(meal_type_name)
);

CREATE TABLE steps (
  steps_id integer,
  steps_num integer NOT NULL,
  description TEXT NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(steps_id),
  CONSTRAINT steps_num CHECK (steps_num > 0)
);

CREATE TABLE is_made (
  recipe_id integer,
  steps_id integer,
  PRIMARY KEY(recipe_id, steps_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (steps_id) REFERENCES steps(steps_id)
);

CREATE TABLE food_groups (
  food_group_id integer,
  name varchar (30) NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  description text NOT NULL,
  PRIMARY KEY(food_group_id)
);

CREATE TABLE ingredients (
  ingredients_id integer,
  name varchar(20) NOT NULL,
  quantity integer NOT NULL,
  calories integer NOT NULL,
  carbs_per_100 integer NOT NULL,
  fat_per_100 integer NOT NULL,
  protein_per_100 integer NOT NULL,
  food_group_id integer NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(ingredients_id),
  FOREIGN KEY (food_group_id) REFERENCES food_groups(food_group_id),
  CONSTRAINT quantity CHECK (quantity > 0),
  CONSTRAINT calories CHECK (calories > 0),
  CONSTRAINT carbs_per_100 CHECK (carbs_per_100 >= 0),
  CONSTRAINT fat_per_100 CHECK (fat_per_100 >= 0),
  CONSTRAINT protein_per_100 CHECK (protein_per_100 >= 0)
);

CREATE TABLE consists_of (
  recipe_id integer,
  ingredients_id integer,
  PRIMARY KEY(recipe_id, ingredients_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (ingredients_id) REFERENCES ingredients(ingredients_id)
);

CREATE TABLE nutritional_info (
  nutritional_info_id integer,
  fat_per_serving integer NOT NULL,
  protein_per_serving integer NOT NULL,
  carbs_per_serving integer NOT NULL,
  calories_per_serving integer NOT NULL,
  PRIMARY KEY(nutritional_info_id),
  CONSTRAINT calories_per_serving CHECK (calories_per_serving > 0),
  CONSTRAINT carbs_per_serving CHECK (carbs_per_serving >= 0),
  CONSTRAINT fat_per_serving CHECK (fat_per_serving >= 0),
  CONSTRAINT protein_per_serving CHECK (protein_per_serving >= 0)
);

CREATE TABLE has (
  recipe_id integer,
  nutritional_info_id integer,
  PRIMARY KEY(recipe_id, nutritional_info_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (nutritional_info_id) REFERENCES nutritional_info(nutritional_info_id)
);

CREATE TABLE sum_of (
  nutritional_info_id integer ,
  ingredients_id integer,
  PRIMARY KEY (nutritional_info_id, ingredients_id),
  FOREIGN KEY (nutritional_info_id) REFERENCES nutritional_info(nutritional_info_id),
  FOREIGN KEY (ingredients_id) REFERENCES ingredients(ingredients_id)
);

CREATE TABLE topics (
  topic_name varchar (50),
  topic_desc TEXT NOT NULL,
  PRIMARY KEY (topic_name)
);

CREATE TABLE belongs_to (
  recipe_id integer,
  topic_name varchar(50),
  PRIMARY KEY(recipe_id, topic_name),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  FOREIGN KEY (topic_name) REFERENCES topics(topic_name)
);

CREATE TABLE cook (
  cook_id integer,
  name varchar(25) NOT NULL,
  surname varchar(25) NOT NULL,
  tel varchar(20) NOT NULL,
  birth_date DATE,
  age integer UNSIGNED,
  experience integer NOT NULL,
  cook_level varchar(30) NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY (cook_id),
  CONSTRAINT cook_level_constraint CHECK (cook_level IN ('a-cook', 'b-cook', 'c-cook', 'chef', 'sous-chef'))
);

CREATE TABLE specialization (
  cook_id integer,
  specialization varchar(100),
  PRIMARY KEY(cook_id, specialization),
  FOREIGN KEY (cook_id) REFERENCES cook(cook_id)
);

CREATE TABLE is_cooked_from (
  cook_id integer,
  recipe_id integer,
  PRIMARY KEY(cook_id,recipe_id),
  FOREIGN KEY (cook_id) REFERENCES cook(cook_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id)
);

CREATE TABLE episode (
  episode_id integer,
  episode_number integer NOT NULL,
  season integer NOT NULL,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY(episode_id)
);

CREATE TABLE participates_in (
  cook_id integer, 
  episode_id integer, 
  role varchar(20),
  PRIMARY KEY (cook_id, episode_id),
  FOREIGN KEY (cook_id) REFERENCES cook(cook_id),
  FOREIGN KEY (episode_id) REFERENCES episode(episode_id)
);

CREATE TABLE has_topic (
  episode_id integer ,
  topic_name varchar(50) ,
  PRIMARY KEY (episode_id, topic_name),
  FOREIGN KEY (episode_id) REFERENCES episode(episode_id),
  FOREIGN KEY (topic_name) REFERENCES topics(topic_name)
);

CREATE TABLE score (
  score_triple_id integer,
  cook_id integer,
  episode_id integer,
  final_score integer NOT NULL,
  recipe_id integer,
  PRIMARY KEY (score_triple_id),
  FOREIGN KEY (cook_id) REFERENCES cook(cook_id),
  FOREIGN KEY (recipe_id) REFERENCES recipe(recipe_id),
  CONSTRAINT final_score_constraint CHECK (final_score IN (1, 2, 3, 4, 5))
);

CREATE TABLE comes_from (
  score_triple_id integer,
  cook_id integer,
  score integer NOT NULL,
  PRIMARY KEY (score_triple_id, cook_id),
  FOREIGN KEY (score_triple_id) REFERENCES score(score_triple_id),
  FOREIGN KEY (cook_id) REFERENCES cook(cook_id),
  CONSTRAINT score_constraint CHECK (score IN (1, 2, 3, 4, 5))
);

CREATE TABLE label (
  label_id integer,
  label_name varchar(50) NOT NULL,
  food_group_id integer,
  photo_url TEXT NOT NULL, 
  photo_description TEXT NOT NULL,
  PRIMARY KEY (label_id),
  FOREIGN KEY (food_group_id) REFERENCES food_groups(food_group_id)
);
