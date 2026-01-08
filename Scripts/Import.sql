USE oblikDB
GO

BULK INSERT Organizations
FROM '<path!!!>\Data\Organizations.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);


BULK INSERT Positions
FROM '<path!!!>\Data\Positions.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	KEEPNULLS,
    FIRSTROW = 2
);


BULK INSERT WorkerCategories
FROM '<path!!!>\Data\WorkerCategories.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Employees
FROM '<path!!!>\Data\Employees.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
); 

BULK INSERT EmployeePositions
FROM '<path!!!>\Data\EmployeePositions.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	KEEPNULLS,
    FIRSTROW = 2
);

BULK INSERT Departments
FROM '<path!!!>\Data\Departments.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Managers
FROM '<path!!!>\Data\Managers.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Documents
FROM '<path!!!>\Data\Documents.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
	KEEPNULLS,
    FIRSTROW = 2
);

BULK INSERT Bonuses
FROM '<path!!!>\Data\Bonuses.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Allowances
FROM '<path!!!>\Data\Allowances.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT EmployeePositionsBonuses
FROM '<path!!!>\Data\EmployeePositionsBonuses.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT EmployeePositionsAllowances
FROM '<path!!!>\Data\EmployeePositionsAllowances.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Products
FROM '<path!!!>\Data\Products.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT WorkAccounting
FROM '<path!!!>\Data\WorkAccounting.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT Timesheets
FROM '<path!!!>\Data\Timesheets.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);

BULK INSERT TimeSpendings
FROM '<path!!!>\Data\TimeSpendings.csv'
WITH (
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
    FIRSTROW = 2
);
