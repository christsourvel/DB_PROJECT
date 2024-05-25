CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    FirstName NVARCHAR(50),
    LastName NVARCHAR(50),
    DepartmentID INT
);

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName NVARCHAR(50)
);


REATE VIEW EmployeeDepartments AS
SELECT 
    e.EmployeeID,
    e.FirstName,
    e.LastName,
    d.DepartmentName
FROM 
    Employees e
JOIN 
    Departments d ON e.DepartmentID = d.DepartmentID;

CREATE TRIGGER trgInsteadOfInsertOnEmployeeDepartments
ON EmployeeDepartments
INSTEAD OF INSERT
AS
BEGIN
    INSERT INTO Employees (EmployeeID, FirstName, LastName, DepartmentID)
    SELECT 
        EmployeeID, 
        FirstName, 
        LastName, 
        (SELECT DepartmentID FROM Departments WHERE DepartmentName = inserted.DepartmentName)
    FROM inserted;
END;


INSERT INTO EmployeeDepartments (EmployeeID, FirstName, LastName, DepartmentName)
VALUES (1, 'John', 'Doe', 'Sales');



-- Create the view for the chef's personal information
CREATE VIEW ChefPersonalInfo AS
SELECT cook_id, name, surname, tel, birth_date, age, experience, cook_level
FROM cook
WHERE cook_id = specific_chef_id;

-- Create the trigger to allow personal information updates
DELIMITER //

CREATE TRIGGER AllowPersonalInfoUpdate
BEFORE UPDATE ON cook
FOR EACH ROW
BEGIN
    IF OLD.cook_id != specific_chef_id THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'You are not authorized to update this information';
    END IF;
END //

DELIMITER ;
