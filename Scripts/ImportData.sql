USE oblikDB
GO

DELETE FROM Timesheets;
DBCC CHECKIDENT ('Timesheets', RESEED, 0);
GO
DELETE FROM Organizations;
DBCC CHECKIDENT ('Organizations', RESEED, 0);
GO
DELETE FROM Employees;
DBCC CHECKIDENT ('Employees', RESEED, 0);
GO
DELETE FROM Positions;
DBCC CHECKIDENT ('Positions', RESEED, 0);
GO
DELETE FROM WorkerCategories;
GO
DBCC CHECKIDENT ('EmployeePositions', RESEED, 0);
DBCC CHECKIDENT ('Departments', RESEED, 0);
DBCC CHECKIDENT ('Managers', RESEED, 0);
DBCC CHECKIDENT ('Documents', RESEED, 0);
DELETE FROM Bonuses;
DBCC CHECKIDENT ('Bonuses', RESEED, 0);
GO
DELETE FROM Allowances;
DBCC CHECKIDENT ('Allowances', RESEED, 0);
GO
DELETE FROM Products;
DBCC CHECKIDENT ('Products', RESEED, 0);
DBCC CHECKIDENT ('WorkAccounting', RESEED, 0);
DBCC CHECKIDENT ('TimeSpendings', RESEED, 0);
GO

BULK INSERT Organizations
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Organizations.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


BULK INSERT Positions
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Positions.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	KEEPNULLS,
    FIRSTROW = 2
);


BULK INSERT WorkerCategories
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\WorkerCategories.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Employees
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Employees.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
); 

BULK INSERT EmployeePositions
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\EmployeePositions.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	KEEPNULLS,
    FIRSTROW = 2
);

BULK INSERT Departments
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Departments.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Managers
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Managers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Documents
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Documents.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	KEEPNULLS,
    FIRSTROW = 2
);

BULK INSERT Bonuses
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Bonuses.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Allowances
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Allowances.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT EmployeePositionsBonuses
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\EmployeePositionsBonuses.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT EmployeePositionsAllowances
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\EmployeePositionsAllowances.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Products
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Products.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT WorkAccounting
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\WorkAccounting.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Timesheets
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\Timesheets.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT TimeSpendings
FROM 'D:\Documents\study\3_semester\БД\Курсова\Data\TimeSpendings.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
