-- Create trigger
DELIMITER //

DROP TRIGGER IF EXISTS calculate_calories_per_serving//

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
    SET ni.calories_per_serving = total_calories_per_100 / num_portions
    WHERE ni.recipe_id = NEW.recipe_id;
END//

DELIMITER ;

-- Verify the result
SELECT r.name, ni.calories_per_serving
FROM recipe r
JOIN nutritional_info ni ON r.recipe_id = ni.recipe_id
WHERE r.recipe_id = 1;