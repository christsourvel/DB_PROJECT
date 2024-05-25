--1st trigger
DROP TRIGGER IF EXISTS check_tag_limit;
DELIMITER //

CREATE TRIGGER check_tag_limit
BEFORE INSERT ON is_tagged
FOR EACH ROW
BEGIN
  DECLARE tag_count INT;

  -- Count the number of tags already associated with the recipe
  SELECT COUNT(*)
  INTO tag_count
  FROM is_tagged
  WHERE recipe_id = NEW.recipe_id;

  -- Check if adding the new tag would exceed the limit
  IF tag_count >= 3 THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Cannot add more than 3 tags to a recipe';
  END IF;
END;
// 

    

DELIMITER ;

-- Create trigger calories
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

-- CANT PARTICIPATE 4 TIMES IN A ROW
DELIMITER $$

CREATE TRIGGER check_chef_participation
BEFORE INSERT ON participates_in
FOR EACH ROW
BEGIN
    DECLARE last_episode1 INT;
    DECLARE last_episode2 INT;
    DECLARE last_episode3 INT;

    -- Get the last three episodes the chef participated in
    SELECT episode_id INTO last_episode1
    FROM participates_in
    WHERE cook_id = NEW.cook_id
    ORDER BY episode_id DESC
    LIMIT 1;

    SELECT episode_id INTO last_episode2
    FROM participates_in
    WHERE cook_id = NEW.cook_id
    ORDER BY episode_id DESC
    LIMIT 1, 1;

    SELECT episode_id INTO last_episode3
    FROM participates_in
    WHERE cook_id = NEW.cook_id
    ORDER BY episode_id DESC
    LIMIT 2, 1;

    -- Check if the chef participated in the last three episodes consecutively
    IF last_episode1 IS NOT NULL AND last_episode2 IS NOT NULL AND last_episode3 IS NOT NULL THEN
        IF (SELECT season FROM episode WHERE episode_id = last_episode1) = (SELECT season FROM episode WHERE episode_id = last_episode2)
        AND (SELECT season FROM episode WHERE episode_id = last_episode2) = (SELECT season FROM episode WHERE episode_id = last_episode3)
        AND (SELECT season FROM episode WHERE episode_id = last_episode1) = (SELECT season FROM episode WHERE episode_id = NEW.episode_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chef cannot participate in four consecutive episodes';
        END IF;
    END IF;
END $$

DELIMITER ;


--(3) Basic Ingredients Check
DELIMITER //
DROP TRIGGER IF EXISTS enforce_one_basic_ingredient;
CREATE TRIGGER enforce_one_basic_ingredient
BEFORE INSERT ON consists_of
FOR EACH 
BEGIN
    IF NEW.basic_ingredient = TRUE THEN
        -- Check for existing 'basic' ingredient for the same recipe
        IF EXISTS (SELECT 1 FROM consists_of 
                   WHERE recipe_id = NEW.recipe_id AND basic_ingredient = TRUE) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: Only one basic ingredient allowed per recipe';
        END IF;
    END IF;
END;
//
DELIMITER ;

--Serially Test Trigger
DELIMITER $$
DROP TRIGGER IF EXISTS check_steps_order;
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

--DML DATA FOR TESTING
-- Insert a sample recipe
INSERT INTO recipe (recipe_id, name, description, difficulty, national_cuisine, number_of_quantities, preparation_time, cooking_time, type, portions)
VALUES (2000, 'Grilled Chicken Salad', 'Fresh salad with grilled chicken and veggies', 2, 'American', 8, 20, 15, 'Main Course', 2);

-- Insert sample steps for the recipe in a non-serial order
INSERT INTO steps (steps_id, steps_num, description)
VALUES (4, 2, 'Grill the chicken');

INSERT INTO steps (steps_id, steps_num, description)
VALUES (5, 3, 'Prepare the salad');

INSERT INTO steps (steps_id, steps_num, description)
VALUES (6, 1, 'Marinate the chicken');

-- Associate the steps with the recipe in the non-serial order
INSERT INTO is_made (recipe_id, steps_id) VALUES (2000, 4); -- Should raise an exception
INSERT INTO is_made (recipe_id, steps_id) VALUES (2000, 5); -- Should raise an exception
INSERT INTO is_made (recipe_id, steps_id) VALUES (2000, 6); -- Should raise an exception

-- (4) calculation of cook age
DELIMITER //
DROP TRIGGER IF EXISTS calculate_cook_age;
CREATE TRIGGER calculate_cook_age BEFORE INSERT ON cook
FOR EACH ROW
BEGIN
    IF NEW.birth_date IS NOT NULL THEN
        SET NEW.age = TIMESTAMPDIFF(YEAR, NEW.birth_date, CURDATE());
    END IF;
END//


DELIMITER //

