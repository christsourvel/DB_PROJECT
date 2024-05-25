-- Step 1: Drop the user if it exists
DROP USER IF EXISTS 'limited_user'@'localhost';

-- Step 2: Create the user with the updated password
CREATE USER 'limited_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';

DROP VIEW IF EXISTS Personal_Info;
-- Step 3: Create a view containing only the rows where cook_id = 1
CREATE VIEW Personal_Info AS SELECT * FROM cook WHERE cook_id = 1;


DROP VIEW IF EXISTS Cooked_Recipes;
CREATE VIEW Cooked_Recipes AS 
SELECT r.*
FROM recipe r
JOIN is_cooked_from icf ON r.recipe_id = icf.recipe_id
WHERE icf.cook_id = 1;

-- Step 4: Grant SELECT access to the limited_cook_view for the limited_user
GRANT SELECT ON cook_show.Personal_Info TO 'limited_user'@'localhost';

-- Step 5: Grant INSERT, UPDATE, DELETE privileges on the limited_cook_view to the limited_user
GRANT  UPDATE ON cook_show.Personal_Info TO 'limited_user'@'localhost';

-- Step 4: Grant SELECT access to the limited_cook_view for the limited_user
GRANT SELECT ON cook_show.Cooked_Recipes TO 'limited_user'@'localhost';

-- Step 5: Grant INSERT, UPDATE, DELETE privileges on the limited_cook_view to the limited_user
GRANT INSERT, UPDATE ON cook_show.Cooked_Recipes TO 'limited_user'@'localhost';
GRANT INSERT on cook_show.recipe TO 'limited_user'@'localhost';

-- Step 10: Create a BEFORE INSERT trigger to generate the next available recipe_id
DELIMITER //
CREATE TRIGGER generate_recipe_id_trigger
BEFORE INSERT ON recipe
FOR EACH ROW
BEGIN
    DECLARE next_recipe_id INT;

    -- Get the maximum recipe_id from the recipe table and increment it by 1
    SELECT COALESCE(MAX(recipe_id), 0) + 1 INTO next_recipe_id FROM recipe;

    -- Set the new recipe_id for the inserted row
    SET NEW.recipe_id = next_recipe_id;
END;
//
DELIMITER ;