USE oblikDB

-- kadrovik
CREATE USER kadrovik FOR LOGIN kadrovik;

GRANT SELECT ON Organizations TO kadrovik;
GRANT SELECT ON Departments TO kadrovik;
GRANT SELECT ON Managers TO kadrovik;
GRANT SELECT, INSERT, UPDATE, DELETE ON Employees TO kadrovik;
GRANT SELECT, INSERT, UPDATE, DELETE ON Documents TO kadrovik;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmployeePositions TO kadrovik;
GRANT SELECT ON Bonuses TO kadrovik;
GRANT SELECT ON Allowances TO kadrovik;
GRANT SELECT ON WorkerCategories TO kadrovik;
GRANT SELECT, INSERT, UPDATE, DELETE ON WorkAccounting TO kadrovik;
GRANT SELECT, INSERT, UPDATE, DELETE ON Timesheets TO kadrovik;
GRANT SELECT, INSERT, UPDATE, DELETE ON TimeSpendings TO kadrovik;
GRANT SELECT ON PositionsView TO kadrovik;
GRANT SELECT ON ProductsView TO kadrovik;
GRANT EXECUTE ON DeleteOldTimesheets TO kadrovik;
GO

-- nachalnik
CREATE USER nachalnik FOR LOGIN nachalnik;

GRANT SELECT ON Organizations TO nachalnik;
GRANT SELECT ON Departments TO nachalnik;
GRANT SELECT ON Managers TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON Employees TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON Documents TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmployeePositions TO nachalnik;
GRANT SELECT ON Bonuses TO nachalnik;
GRANT SELECT ON Allowances TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmployeePositionsBonuses TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON EmployeePositionsAllowances TO nachalnik;
GRANT SELECT ON WorkerCategories TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON WorkAccounting TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON Timesheets TO nachalnik;
GRANT SELECT, INSERT, UPDATE, DELETE ON TimeSpendings TO nachalnik;
GRANT SELECT ON Positions TO nachalnik;
GRANT SELECT ON Products TO nachalnik;
GRANT EXECUTE ON DeleteOldTimesheets TO nachalnik;
GRANT EXECUTE ON MoveEmployee TO nachalnik;
GRANT EXECUTE ON CalculateSalary TO nachalnik;
GO

-- administrator
CREATE USER administrator FOR LOGIN administrator;

ALTER ROLE db_owner ADD MEMBER administrator;
GO