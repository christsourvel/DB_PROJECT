
# Autharazition
  -- Απενεργοποίηση του safe update mode
  -- SET SQL_SAFE_UPDATES = 0;




  -- Επαναφορά του safe update mode
  -- SET SQL_SAFE_UPDATES = 1;


  
-- create user 'admin'@'%' identified by 'admin';
-- grand all privileges on _ to 'admin'@'%';

-- flush privileges;

-- create user 'cooker1'@'%' identified by 'cooker1';
-- grand insert on recipes to 'cooker1'@'%';
-- grand all privileges on co_re to 'cooker1'@'%';
-- grand all privileges on my_cook to 'cooker1'@'%';

-- flush privileges;




-- Create the admin user and grant all privileges
CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';
GRANT ALL PRIVILEGES ON *.* TO 'admin'@'%';
FLUSH PRIVILEGES;

-- Create the cook1 user and grant specific privileges
CREATE USER 'cook1'@'%' IDENTIFIED BY 'cook1';

-- Grant privileges to insert new recipes
GRANT INSERT ON cook_show.recipe TO 'cook1'@'%';

-- Grant privileges to update recipes that cook1 has cooked
GRANT UPDATE ON cook_show.recipe TO 'cook1'@'%' WITH GRANT OPTION;
CREATE TRIGGER cook1_can_update_cooked_recipes
    BEFORE UPDATE ON cook_show.recipe
    FOR EACH ROW
    BEGIN
        DECLARE can_update BOOLEAN;
        SET can_update = EXISTS(
            SELECT 1
            FROM cook_show.is_cooked_from
            WHERE cook_show.is_cooked_from.cook_id = (SELECT cook_id FROM cook_show.cook WHERE username = 'cook1')
            AND cook_show.is_cooked_from.recipe_id = OLD.recipe_id
        );
        IF NOT can_update THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'You are not authorized to update this recipe';
        END IF;
    END;

FLUSH PRIVILEGES;

-- Modify the cook table to include a username column and populate it with cook_id values
ALTER TABLE cook_show.cook ADD COLUMN username VARCHAR(50) UNIQUE;

UPDATE cook_show.cook SET username = CONCAT('cook', cook_id);

-- Ensure the username column is not null and unique
ALTER TABLE cook_show.cook MODIFY username VARCHAR(50) NOT NULL UNIQUE;
