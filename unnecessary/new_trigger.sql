--done
DELIMITER //

DROP TRIGGER IF EXISTS update_recipe_label;
CREATE TRIGGER update_recipe_label
AFTER INSERT ON consists_of
FOR EACH ROW
BEGIN
    DECLARE v_label_id INT;

    
    IF NEW.basic_ingredient = true THEN
        
        SELECT l.label_id
        INTO v_label_id
        FROM ingredients i
        JOIN food_groups fg ON i.food_group_id = fg.food_group_id
        JOIN label l ON fg.food_group_id = l.food_group_id
        WHERE i.ingredients_id = NEW.ingredients_id
        LIMIT 1;

        
        IF v_label_id IS NOT NULL THEN
            UPDATE recipe
            SET label_id = v_label_id
            WHERE recipe_id = NEW.recipe_id;
        END IF;
    END IF;
END$$

DELIMITER // 



UPDATE recipe r
INNER JOIN (
    SELECT recipe_id, MAX(l.label_id) AS label_id
    FROM consists_of co
    JOIN ingredients i ON co.ingredients_id = i.ingredients_id
    JOIN label l ON l.food_group_id = i.food_group_id
    WHERE co.basic_ingredient = 1
    GROUP BY recipe_id
) t ON r.recipe_id = t.recipe_id
SET r.label_id = t.label_id;