USE cook_show;

-- Disable foreign key checks
SET foreign_key_checks = 0;

-- Truncate existing data
TRUNCATE TABLE recipe_tips;
TRUNCATE TABLE is_tagged;
TRUNCATE TABLE requires;
TRUNCATE TABLE is_a;
TRUNCATE TABLE is_made;
TRUNCATE TABLE consists_of;
TRUNCATE TABLE has;
TRUNCATE TABLE sum_of;
TRUNCATE TABLE belongs_to;
TRUNCATE TABLE specialization;
TRUNCATE TABLE is_cooked_from;
TRUNCATE TABLE participates_in;
TRUNCATE TABLE has_topic;
TRUNCATE TABLE comes_from;
TRUNCATE TABLE score;
-- TRUNCATE TABLE users;
-- TRUNCATE TABLE permissions;
-- TRUNCATE TABLE roles;
TRUNCATE TABLE recipe;
TRUNCATE TABLE tag;
TRUNCATE TABLE utensils;
TRUNCATE TABLE meal_type;
TRUNCATE TABLE steps;
TRUNCATE TABLE label;
TRUNCATE TABLE ingredients;
TRUNCATE TABLE food_groups;
TRUNCATE TABLE topics;
TRUNCATE TABLE cook;
TRUNCATE TABLE episode;
TRUNCATE TABLE nutritional_info;

-- Re-enable foreign key checks
SET foreign_key_checks = 1;

-- Insert data into recipe table
INSERT IGNORE INTO recipe (recipe_id, name, description, difficulty, national_cuisine, number_of_quantities, preparation_time, cooking_time, type, portions, photo_url, photo_description)
VALUES 
(1, 'Tomato Soup', 'A delicious tomato soup.', 2, 'Italian', 1, 10, 30, 'Soup', 4, 'http://example.com/tomato_soup.jpg', 'A bowl of tomato soup.'),
(2, 'Apple Pie', 'A sweet apple pie.', 3, 'French', 1, 20, 45, 'Dessert', 6, 'http://example.com/apple_pie.jpg', 'A slice of apple pie.'),
(3, 'Chicken Curry', 'A spicy chicken curry.', 4, 'Indian', 1, 25, 40, 'Main Course', 4, 'http://example.com/chicken_curry.jpg', 'A bowl of chicken curry.'),
(4, 'Beef Stew', 'A hearty beef stew.', 3, 'American', 1, 15, 120, 'Main Course', 6, 'http://example.com/beef_stew.jpg', 'A pot of beef stew.'),
(5, 'Tacos', 'Delicious Mexican tacos.', 2, 'Mexican', 1, 20, 15, 'Snack', 4, 'http://example.com/tacos.jpg', 'A plate of tacos.'),
(6, 'Sushi', 'Fresh sushi rolls.', 3, 'Japanese', 1, 20, 30, 'Main Course', 2, 'http://example.com/sushi.jpg', 'A platter of sushi rolls.'),
(7, 'Falafel', 'Crispy falafel.', 3, 'Middle Eastern', 1, 15, 20, 'Snack', 5, 'http://example.com/falafel.jpg', 'A plate of falafel.'),
(8, 'Peking Duck', 'A classic Chinese dish.', 4, 'Chinese', 1, 30, 90, 'Main Course', 6, 'http://example.com/peking_duck.jpg', 'A roasted Peking duck.'),
(9, 'Paella', 'A traditional Spanish rice dish.', 3, 'Spanish', 1, 20, 45, 'Main Course', 4, 'http://example.com/paella.jpg', 'A pan of paella.'),
(10, 'Moussaka', 'A Greek eggplant casserole.', 4, 'Greek', 1, 30, 60, 'Main Course', 4, 'http://example.com/moussaka.jpg', 'A serving of moussaka.'),
(11, 'Borscht', 'A traditional Eastern European soup.', 2, 'Russian', 1, 15, 45, 'Soup', 4, 'http://example.com/borscht.jpg', 'A bowl of borscht.'),
(12, 'Sauerbraten', 'A German pot roast.', 4, 'German', 1, 20, 180, 'Main Course', 6, 'http://example.com/sauerbraten.jpg', 'A serving of sauerbraten.'),
(13, 'Kimchi', 'A staple Korean side dish.', 3, 'Korean', 1, 20, 60, 'Side', 4, 'http://example.com/kimchi.jpg', 'A bowl of kimchi.'),
(14, 'Poutine', 'A Canadian dish of fries, cheese curds, and gravy.', 2, 'Canadian', 1, 10, 15, 'Snack', 4, 'http://example.com/poutine.jpg', 'A plate of poutine.'),
(15, 'Feijoada', 'A Brazilian black bean stew.', 4, 'Brazilian', 1, 25, 120, 'Main Course', 6, 'http://example.com/feijoada.jpg', 'A bowl of feijoada.'),
(16, 'Ratatouille', 'A French vegetable stew.', 2, 'French', 1, 20, 40, 'Main Course', 4, 'http://example.com/ratatouille.jpg', 'A plate of ratatouille.'),
(17, 'Shakshuka', 'A North African and Middle Eastern dish of poached eggs in tomato sauce.', 3, 'Middle Eastern', 1, 15, 30, 'Breakfast', 4, 'http://example.com/shakshuka.jpg', 'A pan of shakshuka.'),
(18, 'Pho', 'A Vietnamese noodle soup.', 3, 'Vietnamese', 1, 15, 45, 'Soup', 4, 'http://example.com/pho.jpg', 'A bowl of pho.'),
(19, 'Bibimbap', 'A Korean mixed rice dish.', 4, 'Korean', 1, 20, 30, 'Main Course', 4, 'http://example.com/bibimbap.jpg', 'A bowl of bibimbap.'),
(20, 'Ceviche', 'A Peruvian dish of marinated raw fish.', 3, 'Peruvian', 1, 10, 15, 'Appetizer', 4, 'http://example.com/ceviche.jpg', 'A plate of ceviche.');

-- Insert additional data into episode
-- Insert data into episode table
INSERT IGNORE INTO episode (episode_id, episode_number, season, photo_url, photo_description) VALUES 
(1, 1, 2023, 'http://example.com/episode1.jpg', 'Episode 1 photo'), 
(2, 2, 2023, 'http://example.com/episode2.jpg', 'Episode 2 photo'), 
(3, 3, 2023, 'http://example.com/episode3.jpg', 'Episode 3 photo'), 
(4, 4, 2024, 'http://example.com/episode4.jpg', 'Episode 4 photo'),
(5, 5, 2024, 'http://example.com/episode5.jpg', 'Episode 5 photo'), 
(6, 6, 2024, 'http://example.com/episode6.jpg', 'Episode 6 photo'), 
(7, 7, 2025, 'http://example.com/episode7.jpg', 'Episode 7 photo'), 
(8, 8, 2025, 'http://example.com/episode8.jpg', 'Episode 8 photo'),
(9, 9, 2025, 'http://example.com/episode9.jpg', 'Episode 9 photo'), 
(10, 10, 2025, 'http://example.com/episode10.jpg', 'Episode 10 photo'), 
(11, 11, 2026, 'http://example.com/episode11.jpg', 'Episode 11 photo'), 
(12, 12, 2026, 'http://example.com/episode12.jpg', 'Episode 12 photo'), 
(13, 13, 2026, 'http://example.com/episode13.jpg', 'Episode 13 photo'), 
(14, 14, 2027, 'http://example.com/episode14.jpg', 'Episode 14 photo'), 
(15, 15, 2027, 'http://example.com/episode15.jpg', 'Episode 15 photo'), 
(16, 16, 2028, 'http://example.com/episode16.jpg', 'Episode 16 photo'), 
(17, 17, 2028, 'http://example.com/episode17.jpg', 'Episode 17 photo'), 
(18, 18, 2029, 'http://example.com/episode18.jpg', 'Episode 18 photo'), 
(19, 19, 2029, 'http://example.com/episode19.jpg', 'Episode 19 photo'), 
(20, 20, 2030, 'http://example.com/episode20.jpg', 'Episode 20 photo'), 
(21, 21, 2030, 'http://example.com/episode21.jpg', 'Episode 21 photo'), 
(22, 22, 2031, 'http://example.com/episode22.jpg', 'Episode 22 photo'), 
(23, 23, 2031, 'http://example.com/episode23.jpg', 'Episode 23 photo'), 
(24, 24, 2031, 'http://example.com/episode24.jpg', 'Episode 24 photo'), 
(25, 25, 2032, 'http://example.com/episode25.jpg', 'Episode 25 photo'), 
(26, 26, 2032, 'http://example.com/episode26.jpg', 'Episode 26 photo'), 
(27, 27, 2033, 'http://example.com/episode27.jpg', 'Episode 27 photo'), 
(28, 28, 2033, 'http://example.com/episode28.jpg', 'Episode 28 photo'), 
(29, 29, 2034, 'http://example.com/episode29.jpg', 'Episode 29 photo'), 
(30, 30, 2034, 'http://example.com/episode30.jpg', 'Episode 30 photo'), 
(31, 31, 2035, 'http://example.com/episode31.jpg', 'Episode 31 photo'), 
(32, 32, 2035, 'http://example.com/episode32.jpg', 'Episode 32 photo'), 
(33, 33, 2036, 'http://example.com/episode33.jpg', 'Episode 33 photo'), 
(34, 34, 2036, 'http://example.com/episode34.jpg', 'Episode 34 photo'), 
(35, 35, 2037, 'http://example.com/episode35.jpg', 'Episode 35 photo'), 
(36, 36, 2037, 'http://example.com/episode36.jpg', 'Episode 36 photo'), 
(37, 37, 2038, 'http://example.com/episode37.jpg', 'Episode 37 photo'), 
(38, 38, 2038, 'http://example.com/episode38.jpg', 'Episode 38 photo'), 
(39, 39, 2039, 'http://example.com/episode39.jpg', 'Episode 39 photo'), 
(40, 40, 2039, 'http://example.com/episode40.jpg', 'Episode 40 photo');

-- Insert sample data into recipe_tips
INSERT IGNORE INTO recipe_tips (recipe_id, tips) VALUES 
(1, 'Keep refrigerated'), 
(2, 'Serve with ice cream'),
(6, 'Use fresh spices for better taste'),
(7, 'Cook slowly for tender meat'),
(8, 'Serve with guacamole'),
(9, 'Use fresh vegetables for best flavor'),
(10, 'Let it cool before serving'),
(11, 'Use different cheeses for variety');

-- Insert sample data into tag
INSERT IGNORE INTO tag (tag_id, tag, photo_url, photo_description) VALUES 
(1, 'Vegetarian', 'http://example.com/vegetarian.jpg', 'A photo representing vegetarian dishes'), 
(2, 'Vegan', 'http://example.com/vegan.jpg', 'A photo representing vegan dishes'),
(3, 'Gluten-Free', 'http://example.com/gluten_free.jpg', 'A photo representing gluten-free dishes'),
(4, 'Spicy', 'http://example.com/spicy.jpg', 'A photo representing spicy dishes'),
(5, 'Quick', 'http://example.com/quick.jpg', 'A photo representing quick dishes'),
(6, 'Healthy', 'http://example.com/healthy.jpg', 'A photo representing healthy dishes'),
(7, 'Dessert', 'http://example.com/dessert.jpg', 'A photo representing desserts');

-- Insert sample data into is_tagged
INSERT IGNORE INTO is_tagged (recipe_id, tag_id) VALUES 
(1, 1), 
(2, 1),
(6, 4),
(7, 3),
(8, 5),
(9, 6),
(10, 7),
(11, 5);

-- Insert sample data into utensils
INSERT IGNORE INTO utensils (utensil_id, name, instructions, photo_url, photo_description) VALUES 
(1, 'Blender', 'Used for blending ingredients', 'http://example.com/blender.jpg', 'A photo of a blender'), 
(2, 'Knife', 'Used for cutting ingredients', 'http://example.com/knife.jpg', 'A photo of a knife'),
(3, 'Pan', 'Used for frying', 'http://example.com/pan.jpg', 'A photo of a frying pan'),
(4, 'Pot', 'Used for boiling', 'http://example.com/pot.jpg', 'A photo of a pot'),
(5, 'Oven', 'Used for baking', 'http://example.com/oven.jpg', 'A photo of an oven'),
(6, 'Grill', 'Used for grilling', 'http://example.com/grill.jpg', 'A photo of a grill'),
(7, 'Mixing Bowl', 'Used for mixing ingredients', 'http://example.com/mixing_bowl.jpg', 'A photo of a mixing bowl');

-- Insert sample data into requires
INSERT IGNORE INTO requires (recipe_id, utensil_id) VALUES 
(1, 1), 
(1, 2), 
(2, 2),
(6, 2), 
(6, 3),
(7, 4), 
(8, 3),
(9, 2),
(10, 7),
(10, 5),
(11, 6);

-- Insert sample data into meal_type
INSERT IGNORE INTO meal_type (meal_type_name, photo_url, photo_description) VALUES 
('Breakfast', 'http://example.com/breakfast.jpg', 'A photo of a breakfast meal'), 
('Lunch', 'http://example.com/lunch.jpg', 'A photo of a lunch meal'),
('Dinner', 'http://example.com/dinner.jpg', 'A photo of a dinner meal'), 
('Snack', 'http://example.com/snack.jpg', 'A photo of a snack'), 
('Dessert', 'http://example.com/dessert.jpg', 'A photo of a dessert'),
('Main Course', 'http://example.com/main_course.jpg', 'A photo of a main course meal');

-- Insert sample data into is_a
INSERT IGNORE INTO is_a (recipe_id, meal_type_name) VALUES 
(1, 'Lunch'), 
(2, 'Breakfast'),
(6, 'Dinner'), 
(7, 'Dinner'), 
(8, 'Snack'),
(9, 'Dinner'),
(10, 'Dessert'),
(11, 'Snack');

INSERT IGNORE INTO steps (steps_id, steps_num, description, photo_url, photo_description) VALUES 
(1, 1, 'Chop tomatoes', 'http://example.com/tomatoes_chopping.jpg', 'Photo of chopping tomatoes'), 
(2, 2, 'Boil tomatoes', 'http://example.com/tomatoes_boiling.jpg', 'Photo of boiling tomatoes'),
(3, 1, 'Slice apples', 'http://example.com/apples_slicing.jpg', 'Photo of slicing apples'), 
(4, 2, 'Bake apples', 'http://example.com/apples_baking.jpg', 'Photo of baking apples'),
(5, 1, 'Chop chicken', 'http://example.com/chicken_chopping.jpg', 'Photo of chopping chicken'), 
(6, 2, 'Cook chicken with spices', 'http://example.com/chicken_cooking.jpg', 'Photo of cooking chicken with spices'),
(7, 1, 'Prepare beef', 'http://example.com/beef_preparation.jpg', 'Photo of preparing beef'), 
(8, 2, 'Cook beef slowly in pot', 'http://example.com/beef_cooking.jpg', 'Photo of cooking beef slowly in pot'),
(9, 1, 'Prepare taco filling', 'http://example.com/taco_filling_preparation.jpg', 'Photo of preparing taco filling'), 
(10, 2, 'Fill taco shells', 'http://example.com/taco_filling.jpg', 'Photo of filling taco shells'),
(11, 1, 'Chop vegetables', 'http://example.com/vegetables_chopping.jpg', 'Photo of chopping vegetables'), 
(12, 2, 'Stir fry vegetables in pan', 'http://example.com/vegetables_stirfry.jpg', 'Photo of stir frying vegetables in pan'),
(13, 1, 'Mix cake batter', 'http://example.com/cake_batter_mixing.jpg', 'Photo of mixing cake batter'), 
(14, 2, 'Bake cake', 'http://example.com/cake_baking.jpg', 'Photo of baking cake'),
(15, 1, 'Butter bread', 'http://example.com/bread_buttering.jpg', 'Photo of buttering bread'), 
(16, 2, 'Grill sandwich', 'http://example.com/sandwich_grilling.jpg', 'Photo of grilling sandwich');

-- Insert sample data into is_made
INSERT IGNORE INTO is_made (recipe_id, steps_id) VALUES 
(1, 1), 
(1, 2), 
(2, 3), 
(2, 4),
(6, 5), 
(6, 6),
(7, 7), 
(7, 8), 
(8, 9), 
(8, 10),
(9, 11), 
(9, 12),
(10, 13), 
(10, 14),
(11, 15), 
(11, 16);

-- Insert sample data into food_groups
INSERT IGNORE INTO food_groups (food_group_id, name, description, photo_url, photo_description) VALUES 
(1, 'Vegetables', 'Group of vegetables', 'http://example.com/vegetables.jpg', 'Photo of vegetables'), 
(2, 'Fruits', 'Group of fruits', 'http://example.com/fruits.jpg', 'Photo of fruits'),
(3, 'Meat', 'Group of meats', 'http://example.com/meat.jpg', 'Photo of meat'), 
(4, 'Grains', 'Group of grains', 'http://example.com/grains.jpg', 'Photo of grains'),
(5, 'Dairy', 'Group of dairy products', 'http://example.com/dairy.jpg', 'Photo of dairy products'),
(6, 'Sweets', 'Group of sweets', 'http://example.com/sweets.jpg', 'Photo of sweets'),
(7, 'Nuts', 'Group of nuts', 'http://example.com/nuts.jpg', 'Photo of nuts'),
(8, 'Seafood', 'Group of seafood', 'http://example.com/seafood.jpg', 'Photo of seafood');

INSERT IGNORE INTO ingredients (ingredients_id, name, quantity, calories, carbs_per_100, fat_per_100, protein_per_100, food_group_id, photo_url, photo_description)
VALUES 
(1, 'Tomato', 500, 100, 18, 0, 2, 1, 'http://example.com/tomato.jpg', 'Photo of tomato'), 
(2, 'Apple', 300, 150, 52, 0, 0, 2, 'http://example.com/apple.jpg', 'Photo of apple'),
(3, 'Chicken', 400, 250, 0, 10, 20, 3, 'http://example.com/chicken.jpg', 'Photo of chicken'), 
(4, 'Beef', 600, 500, 0, 20, 30, 3, 'http://example.com/beef.jpg', 'Photo of beef'),
(5, 'Taco Shell', 100, 200, 60, 10, 4, 4, 'http://example.com/tacoshell.jpg', 'Photo of taco shell'),
(6, 'Broccoli', 200, 50, 10, 0, 3, 1, 'http://example.com/broccoli.jpg', 'Photo of broccoli'),
(7, 'Chocolate', 200, 300, 70, 20, 5, 6, 'http://example.com/chocolate.jpg', 'Photo of chocolate'),
(8, 'Cheese', 100, 400, 2, 30, 25, 5, 'http://example.com/cheese.jpg', 'Photo of cheese');

-- Insert sample data into consists_of
INSERT IGNORE INTO consists_of (recipe_id, ingredients_id) VALUES 
(1, 1), 
(2, 2),
(6, 3), 
(7, 4), 
(8, 5),
(9, 6),
(10, 7),
(11, 8);

-- Insert sample data into nutritional_info
INSERT IGNORE INTO nutritional_info (nutritional_info_id, fat_per_serving, protein_per_serving, carbs_per_serving, calories_per_serving)
VALUES 
(1, 2, 3, 18, 100), 
(2, 0, 0, 52, 150),
(3, 10, 20, 0, 250), 
(4, 20, 30, 0, 500), 
(5, 10, 4, 60, 200),
(6, 0, 3, 10, 50),
(7, 20, 5, 70, 300),
(8, 30, 25, 2, 400);

-- Insert sample data into has
INSERT IGNORE INTO has (recipe_id, nutritional_info_id) VALUES 
(1, 1), 
(2, 2),
(6, 3), 
(7, 4), 
(8, 5),
(9, 6),
(10, 7),
(11, 8);

-- Insert sample data into sum_of
INSERT IGNORE INTO sum_of (nutritional_info_id, ingredients_id) VALUES 
(1, 1), 
(2, 2),
(3, 3), 
(4, 4), 
(5, 5),
(6, 6),
(7, 7),
(8, 8);

-- Insert sample data into topics
INSERT IGNORE INTO topics (topic_name, topic_desc, photo_url, photo_description) VALUES 
('Holiday Special', 'Special recipes for holidays', 'http://example.com/holiday_special.jpg', 'Photo of holiday special recipes'), 
('Quick Meals', 'Recipes that are quick to prepare', 'http://example.com/quick_meals.jpg', 'Photo of quick meals'),
('Healthy Eating', 'Recipes for a healthy lifestyle', 'http://example.com/healthy_eating.jpg', 'Photo of healthy eating'), 
('Comfort Food', 'Recipes that provide comfort and warmth', 'http://example.com/comfort_food.jpg', 'Photo of comfort food'),
('Party Snacks', 'Snacks perfect for parties', 'http://example.com/party_snacks.jpg', 'Photo of party snacks');

-- Insert sample data into belongs_to
INSERT IGNORE INTO belongs_to (recipe_id, topic_name) VALUES 
(1, 'Holiday Special'), 
(2, 'Quick Meals'),
(6, 'Healthy Eating'), 
(7, 'Comfort Food'), 
(8, 'Party Snacks'),
(9, 'Healthy Eating'),
(10, 'Comfort Food'),
(11, 'Quick Meals');

INSERT IGNORE INTO cook (cook_id, name, surname, tel, birth_date, age, experience, cook_level, photo_url, photo_description)
VALUES 
(1, 'John', 'Doe', '1234567890', '1985-05-20', 38, 15, 'chef', 'http://example.com/john_doe.jpg', 'Photo of John Doe'), 
(2, 'Jane', 'Smith', '0987654321', '1990-08-15', 33, 10, 'sous-chef', 'http://example.com/jane_smith.jpg', 'Photo of Jane Smith'),
(3, 'Alice', 'Johnson', '5551234567', '1995-10-05', 28, 8, 'b-cook', 'http://example.com/alice_johnson.jpg', 'Photo of Alice Johnson'), 
(4, 'Bob', 'Brown', '5559876543', '1980-01-22', 44, 20, 'a-cook', 'http://example.com/bob_brown.jpg', 'Photo of Bob Brown'),
(5, 'Charlie', 'Davis', '5555555555', '1999-07-12', 24, 4, 'c-cook', 'http://example.com/charlie_davis.jpg', 'Photo of Charlie Davis'),
(6, 'Emily', 'Clark', '5551112222', '1988-03-15', 36, 12, 'chef', 'http://example.com/emily_clark.jpg', 'Photo of Emily Clark'),
(7, 'Frank', 'Miller', '5553334444', '1975-12-05', 48, 25, 'chef', 'http://example.com/frank_miller.jpg', 'Photo of Frank Miller'),
(8, 'Grace', 'Hall', '5554445555', '1982-11-10', 41, 18, 'sous-chef', 'http://example.com/grace_hall.jpg', 'Photo of Grace Hall'),
(9, 'Henry', 'Wilson', '5556667777', '1980-02-22', 44, 20, 'a-cook', 'http://example.com/henry_wilson.jpg', 'Photo of Henry Wilson'),
(10, 'Ivy', 'Lee', '5557778888', '1994-04-04', 30, 6, 'b-cook', 'http://example.com/ivy_lee.jpg', 'Photo of Ivy Lee'),
(11, 'Jack', 'Taylor', '5558889999', '1986-11-22', 37, 12, 'chef', 'http://example.com/jack_taylor.jpg', 'Photo of Jack Taylor'),
(12, 'Olivia', 'Moore', '5552223333', '1991-02-13', 33, 11, 'sous-chef', 'http://example.com/olivia_moore.jpg', 'Photo of Olivia Moore'),
(13, 'Liam', 'White', '5554446666', '1983-09-25', 40, 18, 'a-cook', 'http://example.com/liam_white.jpg', 'Photo of Liam White'),
(14, 'Sophia', 'Harris', '5556667778', '1987-12-14', 36, 14, 'c-cook', 'http://example.com/sophia_harris.jpg', 'Photo of Sophia Harris'),
(15, 'Noah', 'Martinez', '5559991111', '1996-06-30', 27, 7, 'chef', 'http://example.com/noah_martinez.jpg', 'Photo of Noah Martinez'),
(16, 'Emma', 'Thompson', '5553335555', '1984-07-07', 39, 16, 'sous-chef', 'http://example.com/emma_thompson.jpg', 'Photo of Emma Thompson'),
(17, 'James', 'Garcia', '5557774444', '1990-01-15', 34, 12, 'a-cook', 'http://example.com/james_garcia.jpg', 'Photo of James Garcia'),
(18, 'Ava', 'Martinez', '5555558888', '1992-03-19', 32, 10, 'b-cook', 'http://example.com/ava_martinez.jpg', 'Photo of Ava Martinez'),
(19, 'William', 'Martinez', '5552224444', '1985-08-22', 38, 15, 'chef', 'http://example.com/william_martinez.jpg', 'Photo of William Martinez'),
(20, 'Mia', 'Gonzalez', '5551119999', '1988-09-18', 35, 13, 'sous-chef', 'http://example.com/mia_gonzalez.jpg', 'Photo of Mia Gonzalez');

-- Insert sample data into specialization
INSERT IGNORE INTO specialization (cook_id, specialization, photo_url, photo_description) VALUES 
(1, 'Italian', 'http://example.com/italian_cuisine.jpg', 'Italian Cuisine'),
(2, 'French', 'http://example.com/french_cuisine.jpg', 'French Cuisine'),
(3, 'Indian', 'http://example.com/indian_cuisine.jpg', 'Indian Cuisine'),
(4, 'American', 'http://example.com/american_cuisine.jpg', 'American Cuisine'),
(5, 'Mexican', 'http://example.com/mexican_cuisine.jpg', 'Mexican Cuisine'),
(6, 'Chinese', 'http://example.com/chinese_cuisine.jpg', 'Chinese Cuisine'),
(7, 'Desserts', 'http://example.com/desserts.jpg', 'Desserts');

-- Assign recipes to each chef for each episode, ensuring no consecutive assignment for more than 3 episodes
INSERT IGNORE INTO is_cooked_from (cook_id, recipe_id) VALUES 
(1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
(1, 11), (2, 12), (3, 13), (4, 14), (5, 15), (6, 16), (7, 17), (8, 18), (9, 19), (10, 20),
(11, 21), (12, 22), (13, 23), (14, 24), (15, 25), (16, 26), (17, 27), (18, 28), (19, 29), (20, 30),
(11, 1), (12, 2), (13, 3), (14, 4), (15, 5), (16, 6), (17, 7), (18, 8), (19, 9), (20, 10),
(1, 21), (2, 22), (3, 23), (4, 24), (5, 25), (6, 26), (7, 27), (8, 28), (9, 29), (10, 30),
(11, 11), (12, 12), (13, 13), (14, 14), (15, 15), (16, 16), (17, 17), (18, 18), (19, 19), (20, 20);

-- Ensure participation, ensuring no consecutive participation for more than 3 episodes
-- Also, ensure that some chefs have significantly fewer participations
INSERT IGNORE INTO participates_in (cook_id, episode_id, role) VALUES 
(1, 1, 'chef'), (1, 2, 'chef'), (1, 3, 'chef'), (1, 4, 'chef'), (1, 5, 'chef'), (1, 6, 'chef'), (1, 7, 'chef'), (1, 8, 'chef'), (1, 9, 'chef'), (1, 10, 'chef'),
(2, 11, 'chef'), (2, 12, 'chef'), (2, 13, 'chef'), (2, 14, 'chef'), (2, 15, 'chef'), 
(3, 16, 'chef'), (3, 17, 'chef'), (3, 18, 'chef'), 
(4, 19, 'chef'), (4, 20, 'chef'), (4, 21, 'chef'),
(5, 22, 'chef'), (5, 23, 'chef'), 
(6, 24, 'chef'), (6, 25, 'chef'), 
(7, 26, 'chef'), 
(8, 27, 'chef'),
(9, 28, 'chef'), 
(10, 29, 'chef'), 
(11, 30, 'chef'),
(12, 31, 'chef'), 
(13, 32, 'chef'),
(14, 33, 'chef'), 
(15, 34, 'chef'),
(16, 35, 'chef'),
(17, 36, 'chef');

-- Assign judges, ensuring no consecutive participation for more than 3 episodes
INSERT IGNORE INTO participates_in (cook_id, episode_id, role) VALUES 
(1, 37, 'judge'), (1, 38, 'judge'), (1, 39, 'judge'),
(2, 40, 'judge'), (2, 41, 'judge'), (2, 42, 'judge'),
(3, 43, 'judge'), (3, 44, 'judge'), (3, 45, 'judge'),
(4, 46, 'judge'), (4, 47, 'judge'), (4, 48, 'judge'),
(5, 49, 'judge'), (1, 50, 'judge');

-- Insert sample data into has_topic
INSERT IGNORE INTO has_topic (episode_id, topic_name) VALUES 
(1, 'Holiday Special'), 
(2, 'Quick Meals'),
(3, 'Healthy Eating'), 
(4, 'Comfort Food'), 
(5, 'Party Snacks'),
(6, 'Healthy Eating'),
(7, 'Comfort Food'),
(8, 'Party Snacks'),
(9, 'Holiday Special'),
(10, 'Quick Meals'),
(11, 'Healthy Eating');

-- Insert scores
INSERT IGNORE INTO score (score_triple_id, cook_id, episode_id, final_score, recipe_id)
VALUES 
(1, 1, 1, 4, 1), 
(2, 1, 2, 5, 2),
(3, 1, 3, 3, 3), 
(4, 2, 4, 4, 4), 
(5, 2, 5, 5, 5),
(6, 2, 6, 4, 6),
(7, 3, 7, 5, 7),
(8, 3, 8, 3, 8),
(9, 3, 9, 4, 9), 
(10, 4, 10, 5, 10),

(11, 4, 11, 4, 11), 
(12, 4, 12, 5, 12),
(13, 5, 13, 3, 13), 
(14, 5, 14, 4, 14), 
(15, 5, 15, 5, 15),
(16, 6, 16, 4, 16),
(17, 6, 17, 5, 17),
(18, 6, 18, 3, 18),
(19, 7, 19, 4, 19), 
(20, 7, 20, 5, 20),

(21, 7, 21, 4, 1), 
(22, 8, 22, 5, 2),
(23, 8, 23, 3, 3), 
(24, 8, 24, 4, 4), 
(25, 9, 25, 5, 5),
(26, 9, 26, 4, 6),
(27, 9, 27, 5, 7),
(28, 10, 28, 3, 8),
(29, 10, 29, 4, 9), 
(30, 10, 30, 5, 10),

(31, 11, 31, 4, 11), 
(32, 11, 32, 5, 12),
(33, 11, 33, 3, 13), 
(34, 12, 34, 4, 14), 
(35, 12, 35, 5, 15),
(36, 12, 36, 4, 16),
(37, 13, 37, 5, 17),
(38, 13, 38, 3, 18),
(39, 13, 39, 4, 19), 
(40, 14, 40, 5, 20),

(41, 14, 41, 4, 1), 
(42, 14, 42, 5, 2),
(43, 15, 43, 3, 3), 
(44, 15, 44, 4, 4), 
(45, 15, 45, 5, 5),
(46, 16, 46, 4, 6),
(47, 16, 47, 5, 7),
(48, 16, 48, 3, 8),
(49, 17, 49, 4, 9), 
(50, 17, 50, 5, 10);

-- Insert sample data into comes_from
INSERT IGNORE INTO comes_from (score_triple_id, cook_id, score) VALUES 
(1, 1, 4), 
(2, 2, 5),
(3, 3, 3), 
(4, 4, 4), 
(5, 5, 5),
(6, 6, 4),
(7, 7, 5),
(8, 4, 3),
(9, 1, 4), 
(10, 1, 5),
(11, 1, 4), 
(12, 1, 5);

-- Insert sample data into label
INSERT IGNORE INTO label (label_id, label_name, food_group_id, photo_url, photo_description) VALUES 
(1, 'Organic', 1, 'http://example.com/organic.jpg', 'Organic label photo'), 
(2, 'Non-GMO', 2, 'http://example.com/non-gmo.jpg', 'Non-GMO label photo'),
(3, 'Grass-fed', 3, 'http://example.com/grass-fed.jpg', 'Grass-fed label photo'), 
(4, 'Whole grain', 4, 'http://example.com/whole-grain.jpg', 'Whole grain label photo'), 
(5, 'Low-fat', 5, 'http://example.com/low-fat.jpg', 'Low-fat label photo'),
(6, 'Dark Chocolate', 6, 'http://example.com/dark-chocolate.jpg', 'Dark Chocolate label photo');

