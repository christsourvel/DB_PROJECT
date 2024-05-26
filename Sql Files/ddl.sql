USE cook_show;

SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS recipe_tips;
DROP TABLE IF EXISTS is_tagged;
DROP TABLE IF EXISTS requires;
DROP TABLE IF EXISTS is_a;
DROP TABLE IF EXISTS is_made;
DROP TABLE IF EXISTS consists_of;
DROP TABLE IF EXISTS has_label;
DROP TABLE IF EXISTS belongs_to;
DROP TABLE IF EXISTS specialization;
DROP TABLE IF EXISTS is_cooked_from;
DROP TABLE IF EXISTS participates_in;
DROP TABLE IF EXISTS has_topic;
DROP TABLE IF EXISTS comes_from;
DROP TABLE IF EXISTS score;
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
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS user_roles;

SET FOREIGN_KEY_CHECKS = 1;

CREATE TABLE food_groups (
    food_group_id INTEGER UNSIGNED,
    name VARCHAR(30) NOT NULL,
    description TEXT NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (food_group_id)
);

CREATE TABLE label (
    label_id INTEGER UNSIGNED,
    label_name VARCHAR(50) NOT NULL,
    food_group_id INTEGER UNSIGNED,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (label_id),
    FOREIGN KEY (food_group_id)
        REFERENCES food_groups (food_group_id)
);

CREATE TABLE recipe (
    recipe_id INTEGER UNSIGNED AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    description TEXT NOT NULL,
    difficulty INTEGER NOT NULL,
    national_cuisine VARCHAR(50) NOT NULL,
    preparation_time INTEGER NOT NULL,
    cooking_time INTEGER NOT NULL,
    type VARCHAR(50) NOT NULL,
    portions INT NOT NULL,
    label_id INT UNSIGNED,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (recipe_id),
    FOREIGN KEY (label_id)
        REFERENCES label (label_id),
    CONSTRAINT difficulty_constraint CHECK (difficulty IN (1 , 2, 3, 4, 5)),
    CONSTRAINT portions_constraint CHECK (portions > 0),
    CONSTRAINT preparation_time_constraint CHECK (preparation_time >= 0),
    CONSTRAINT cooking_time_constraint CHECK (cooking_time >= 0),
    CONSTRAINT chk_includes_cuisine CHECK (
        LOCATE('Cuisine', national_cuisine) > 0
    ),
    CONSTRAINT chk_type CHECK (type IN ('cooking', 'pastry', 'Cooking', 'Pastry'))
);

CREATE TABLE recipe_tips (
    recipe_id INTEGER UNSIGNED,
    tips VARCHAR(255),
    PRIMARY KEY (recipe_id , tips),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id)
);

CREATE TABLE tag (
    tag_id INTEGER UNSIGNED,
    tag VARCHAR(50) NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (tag_id)
);

CREATE TABLE is_tagged (
    recipe_id INTEGER UNSIGNED,
    tag_id INTEGER UNSIGNED,
    PRIMARY KEY (recipe_id , tag_id),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    FOREIGN KEY (tag_id)
        REFERENCES tag (tag_id)
);

CREATE TABLE utensils (
    utensil_id INTEGER UNSIGNED NOT NULL,
    name VARCHAR(50) NOT NULL,
    instructions TEXT NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (utensil_id)
);

CREATE TABLE requires (
    recipe_id INTEGER UNSIGNED,
    utensil_id INTEGER UNSIGNED,
    PRIMARY KEY (recipe_id , utensil_id),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    FOREIGN KEY (utensil_id)
        REFERENCES utensils (utensil_id)
);

CREATE TABLE meal_type (
    meal_type_name VARCHAR(50),
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (meal_type_name)
);

CREATE TABLE is_a (
    recipe_id INTEGER UNSIGNED,
    meal_type_name VARCHAR(50),
    PRIMARY KEY (recipe_id , meal_type_name),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    FOREIGN KEY (meal_type_name)
        REFERENCES meal_type (meal_type_name)
);

CREATE TABLE steps (
    steps_id INTEGER UNSIGNED,
    description TEXT NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (steps_id)
);

CREATE TABLE is_made (
    recipe_id INTEGER UNSIGNED,
    steps_id INTEGER UNSIGNED,
    steps_num INTEGER UNSIGNED NOT NULL,
    CONSTRAINT steps_num CHECK (steps_num > 0),
    PRIMARY KEY (recipe_id , steps_id),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    FOREIGN KEY (steps_id)
        REFERENCES steps (steps_id)
);


CREATE TABLE ingredients (
    ingredients_id INTEGER UNSIGNED,
    name VARCHAR(20) NOT NULL,
    quantity INTEGER NOT NULL,
    calories INTEGER NOT NULL,
    carbs_per_100 INTEGER NOT NULL,
    fat_per_100 INTEGER NOT NULL,
    protein_per_100 INTEGER NOT NULL,
    food_group_id INTEGER UNSIGNED NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (ingredients_id),
    FOREIGN KEY (food_group_id)
        REFERENCES food_groups (food_group_id),
    CONSTRAINT quantity CHECK (quantity > 0),
    CONSTRAINT calories CHECK (calories > 0),
    CONSTRAINT carbs_per_100 CHECK (carbs_per_100 >= 0),
    CONSTRAINT fat_per_100 CHECK (fat_per_100 >= 0),
    CONSTRAINT protein_per_100 CHECK (protein_per_100 >= 0)
);

CREATE TABLE consists_of (
    recipe_id INTEGER UNSIGNED,
    ingredients_id INTEGER UNSIGNED,
    basic_ingredient BOOLEAN NOT NULL,
    PRIMARY KEY (recipe_id , ingredients_id),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    FOREIGN KEY (ingredients_id)
        REFERENCES ingredients (ingredients_id)
);

CREATE TABLE nutritional_info (
    nutritional_info_id INTEGER UNSIGNED,
    recipe_id INTEGER UNSIGNED,
    fat_per_serving INTEGER NOT NULL,
    protein_per_serving INTEGER NOT NULL,
    carbs_per_serving INTEGER NOT NULL,
    calories_per_serving INTEGER,
    PRIMARY KEY (nutritional_info_id),
    CONSTRAINT calories_per_serving CHECK (calories_per_serving > 0),
    CONSTRAINT carbs_per_serving CHECK (carbs_per_serving >= 0),
    CONSTRAINT fat_per_serving CHECK (fat_per_serving >= 0),
    CONSTRAINT protein_per_serving CHECK (protein_per_serving >= 0),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id)
);

CREATE TABLE topics (
    topic_name VARCHAR(50),
    topic_desc TEXT NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (topic_name)
);

CREATE TABLE belongs_to (
    recipe_id INTEGER UNSIGNED,
    topic_name VARCHAR(50),
    PRIMARY KEY (recipe_id , topic_name),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    FOREIGN KEY (topic_name)
        REFERENCES topics (topic_name)
);

CREATE TABLE cook (
    cook_id INTEGER UNSIGNED,
    name VARCHAR(25) NOT NULL,
    surname VARCHAR(25) NOT NULL,
    tel VARCHAR(20) NOT NULL,
    birth_date DATE,
    age INTEGER UNSIGNED,
    experience INTEGER NOT NULL,
    cook_level VARCHAR(30) NOT NULL,
    photo_url TEXT NOT NULL, 
    photo_description TEXT NOT NULL,
    PRIMARY KEY (cook_id),
    CONSTRAINT cook_level_constraint CHECK (cook_level IN ('a-cook' , 'b-cook', 'c-cook', 'chef', 'sous-chef'))
);

CREATE TABLE specialization (
    cook_id INTEGER UNSIGNED,
    specialization VARCHAR(100),
    PRIMARY KEY (cook_id , specialization),
    FOREIGN KEY (cook_id)
        REFERENCES cook (cook_id)
);

CREATE TABLE is_cooked_from (
    cook_id INTEGER UNSIGNED,
    recipe_id INTEGER UNSIGNED,
    PRIMARY KEY (cook_id , recipe_id),
    FOREIGN KEY (cook_id)
        REFERENCES cook (cook_id),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id)
);

CREATE TABLE episode (
    episode_id INTEGER UNSIGNED AUTO_INCREMENT,
    episode_number INTEGER NOT NULL,
    season INTEGER NOT NULL,
    photo_url TEXT , 
    photo_description TEXT,
    PRIMARY KEY (episode_id)
);

CREATE TABLE participates_in (
    cook_id INTEGER UNSIGNED,
    episode_id INTEGER UNSIGNED,
    role VARCHAR(20),
    PRIMARY KEY (cook_id , episode_id),
    FOREIGN KEY (cook_id)
        REFERENCES cook (cook_id),
    FOREIGN KEY (episode_id)
        REFERENCES episode (episode_id)
);

CREATE TABLE has_topic (
    episode_id INTEGER UNSIGNED,
    topic_name VARCHAR(50),
    PRIMARY KEY (episode_id , topic_name),
    FOREIGN KEY (episode_id)
        REFERENCES episode (episode_id),
    FOREIGN KEY (topic_name)
        REFERENCES topics (topic_name)
);

CREATE TABLE score (
    score_triple_id INTEGER UNSIGNED AUTO_INCREMENT,
    cook_id INTEGER UNSIGNED,
    episode_id INTEGER UNSIGNED,
    final_score INTEGER NOT NULL,
    recipe_id INTEGER UNSIGNED,
    PRIMARY KEY (score_triple_id),
    FOREIGN KEY (cook_id)
        REFERENCES cook (cook_id),
    FOREIGN KEY (recipe_id)
        REFERENCES recipe (recipe_id),
    CONSTRAINT final_score_constraint CHECK (final_score IN (3 , 4, 5, 6, 7, 8, 9, 10, 11,12, 13, 14,15))
);

CREATE TABLE comes_from (
    score_triple_id INTEGER UNSIGNED,
    cook_id INTEGER UNSIGNED,
    score INTEGER UNSIGNED NOT NULL,
    PRIMARY KEY (score_triple_id , cook_id),
    FOREIGN KEY (score_triple_id)
        REFERENCES score (score_triple_id),
    FOREIGN KEY (cook_id)
        REFERENCES cook (cook_id),
    CONSTRAINT score_constraint CHECK (score IN (1 , 2, 3, 4, 5))
);

CREATE TABLE roles (
    role_id INT AUTO_INCREMENT PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL
);

CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'cook') NOT NULL
);






