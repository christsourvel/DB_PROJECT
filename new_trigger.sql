DELIMITER //

DROP TRIGGER IF EXISTS update_recipe_label;
CREATE TRIGGER update_recipe_label
AFTER INSERT ON consists_of
FOR EACH ROW
BEGIN
    DECLARE v_label_id INT;

    -- Check if the inserted row has basic_ingredient = true
    IF NEW.basic_ingredient = true THEN
        -- Find the corresponding label_id
        SELECT l.label_id
        INTO v_label_id
        FROM ingredients i
        JOIN food_groups fg ON i.food_group_id = fg.food_group_id
        JOIN label l ON fg.food_group_id = l.food_group_id
        WHERE i.ingredients_id = NEW.ingredients_id
        LIMIT 1;

        -- If a label_id is found, update the recipe table
        IF v_label_id IS NOT NULL THEN
            UPDATE recipe
            SET label_id = v_label_id
            WHERE recipe_id = NEW.recipe_id;
        END IF;
    END IF;
END$$

DELIMITER // 