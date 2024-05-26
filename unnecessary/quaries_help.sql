--Συνδέει label συνταγής με basic ingedients
INSERT INTO has_label (label_id, recipe_id)
SELECT l.label_id, r.recipe_id
FROM recipe r
JOIN consists_of co ON r.recipe_id = co.recipe_id AND co.basic_ingredient = true
JOIN ingredients i ON co.ingredients_id = i.ingredients_id
JOIN food_groups fg ON i.food_group_id = fg.food_group_id
JOIN label l ON fg.food_group_id = l.food_group_id;  


---DML TO CHECK IT OUT
-- Insert sample data into the food_groups table
INSERT INTO food_groups (food_group_id, name, description)
VALUES
    (1, 'Plant-based', 'Food derived from plants'),
    (2, 'Animal-based', 'Food derived from animals');

-- Insert sample data into the ingredients table
INSERT INTO ingredients (ingredients_id, name, quantity, calories, carbs_per_100, fat_per_100, protein_per_100, food_group_id)
VALUES
    (1, 'Tofu', 500, 200, 2, 10, 20, 1),
    (2, 'Chicken Breast', 300, 400, 0, 5, 25, 2);

-- Insert sample data into the recipe table
INSERT INTO recipe (recipe_id, name, description, difficulty, national_cuisine, number_of_quantities, preparation_time, cooking_time, type, portions)
VALUES
    (100, 'Tofu Stir Fry', 'A delicious tofu stir fry.', 2, 'Asian', 10, 15, 20, 'Main Course', 2),
    (101, 'Grilled Chicken', 'A simple grilled chicken.', 1, 'American', 5, 10, 30, 'Main Course', 4);

-- Insert sample data into the consists_of table with basic_ingredient
INSERT INTO consists_of (recipe_id, ingredients_id, basic_ingredient)
VALUES
    (100, 1, TRUE),  -- Tofu is the basic ingredient for Tofu Stir Fry
    (101, 2, TRUE);  -- Chicken Breast is the basic ingredient for Grilled Chicken

-- Insert sample data into the label table
INSERT INTO label (label_id, label_name, food_group_id)
VALUES
    (1, 'Vegetarian', 1),  -- Plant-based
    (2, 'Non-Vegetarian', 2);  -- Animal-based




