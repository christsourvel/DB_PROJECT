-- Query
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

-- Trigers
DELIMITER //
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

DELIMITER //

DELIMITER //
CREATE TRIGGER calculate_cook_age BEFORE INSERT ON cook
FOR EACH ROW
BEGIN
    IF NEW.birth_date IS NOT NULL THEN
        SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.birth_date, CURDATE());
    END IF;
END//
DELIMITER //


DELIMITER //

CREATE TRIGGER check_tag_limit
BEFORE INSERT ON is_tagged
FOR EACH ROW
BEGIN
  DECLARE tag_count INT;


  SELECT COUNT(*)
  INTO tag_count
  FROM is_tagged
  WHERE recipe_id = NEW.recipe_id;


  IF tag_count >= 3 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot add more than 3 tags to a recipe';
  END IF;
END;
// DELIMITER ;

DELIMITER $$

CREATE TRIGGER check_chef_participation
BEFORE INSERT ON participates_in
FOR EACH ROW
BEGIN
    DECLARE last_episode1 INT;
    DECLARE last_episode2 INT;
    DECLARE last_episode3 INT;

    SELECT episode_id INTO last_episode1
    FROM participates_in
    WHERE cook_id = NEW.cook_id
    ORDER BY episode_id DESC
    LIMIT 1;
DELIMITER //

CREATE TRIGGER enforce_one_basic_ingredient
BEFORE INSERT ON consists_of
FOR EACH ROW
BEGIN
    -- Check for existing 'basic' ingredient for the same recipe
    IF NEW.basic_ingredient = TRUE AND EXISTS (
        SELECT 1 
        FROM consists_of
        WHERE recipe_id = NEW.recipe_id AND basic_ingredient = TRUE
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Only one basic ingredient allowed per recipe';
    END IF;
END;
//

DELIMITER ;

*/


DELIMITER $$

CREATE TRIGGER check_steps_order
BEFORE INSERT ON is_made
FOR EACH ROW
BEGIN
    DECLARE last_step_num INT;
    SELECT MAX(steps_num) INTO last_step_num
    FROM is_made
    WHERE recipe_id = NEW.recipe_id;

    IF last_step_num IS NOT NULL THEN
        IF NEW.steps_num != last_step_num + 1 THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Steps not inserted serially for recipe';
        END IF;
    END IF;
END$$
DELIMITER ;


