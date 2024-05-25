--Dynamic Calories
DELIMITER //
DROP TRIGGER IF EXISTS calculate_calories_per_serving;
CREATE TRIGGER calculate_calories_per_serving
AFTER INSERT ON consists_of
FOR EACH ROW
BEGIN
    DECLARE total_calories_per_100 INT;
    DECLARE num_portions INT;

    -- Calculate the sum of (calories * quantity / 100) for the recipe
    SELECT SUM(i.calories * (i.quantity / 100))
    INTO total_calories_per_100
    FROM ingredients i
    JOIN consists_of c ON i.ingredients_id = c.ingredients_id
    WHERE c.recipe_id = NEW.recipe_id;

    -- Get the number of portions for the recipe
    SELECT portions
    INTO num_portions
    FROM recipe
    WHERE recipe_id = NEW.recipe_id;

    -- Calculate the calories_per_serving
    UPDATE nutritional_info ni
    JOIN has h ON ni.nutritional_info_id = h.nutritional_info_id
    SET ni.calories_per_serving = total_calories_per_100 / num_portions
    WHERE h.recipe_id = NEW.recipe_id;
END//



-- Verify the result
SELECT r.name, ni.calories_per_serving
FROM recipe r
JOIN has h ON r.recipe_id = h.recipe_id
JOIN nutritional_info ni ON h.nutritional_info_id = ni.nutritional_info_id