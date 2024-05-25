-- Step 1: Drop the user if it exists
DROP USER IF EXISTS 'limited_user'@'localhost';

-- Step 2: Create the user with the updated password
CREATE USER 'limited_user'@'localhost' IDENTIFIED BY 'StrongPassword123!';

DROP VIEW IF EXISTS Personal_Info;
-- Step 3: Create a view containing only the rows where cook_id = 1
CREATE VIEW Personal_Info AS SELECT * FROM cook WHERE cook_id = 1;

-- Step 4: Grant SELECT access to the limited_cook_view for the limited_user
GRANT SELECT ON cook_show.Personal_Info TO 'limited_user'@'localhost';

-- Step 5: Grant INSERT, UPDATE, DELETE privileges on the limited_cook_view to the limited_user
GRANT  UPDATE ON cook_show.Personal_Info TO 'limited_user'@'localhost';

