USE oblikDB;
GO

CREATE TABLE Organizations
(
	id INT IDENTITY(1, 1) NOT NULL,
	orgName VARCHAR(50) NOT NULL,
	city VARCHAR(30),
	street VARCHAR(30),
	buildingNumber INT,
	activityType VARCHAR(30),
	ownershipForm VARCHAR (30),
	CONSTRAINT PK_Organizations PRIMARY KEY (id),
	CONSTRAINT CK_Organizations_buildingNumber CHECK (buildingNumber > 0)
)

CREATE TABLE Managers
(
	id INT IDENTITY(1, 1) NOT NULL,
	orgID INT NOT NULL,
	employeeID INT UNIQUE,
	CONSTRAINT PK_Managers PRIMARY KEY (id),
	CONSTRAINT FK_Managers_Organizations FOREIGN KEY (orgID) REFERENCES Organizations (id) ON DELETE CASCADE,
)

CREATE TABLE Departments
(
	id INT IDENTITY(1, 1) NOT NULL,
	managerID INT NOT NULL,
	departmentName VARCHAR(50) NOT NULL, 
	CONSTRAINT PK_Departments PRIMARY KEY (id),
	CONSTRAINT FK_Departments_Managers FOREIGN KEY (managerID) REFERENCES Managers (id) ON DELETE CASCADE,
)

CREATE TABLE Employees
(
	id INT IDENTITY(1, 1) NOT NULL,
	employeeName VARCHAR(30) NOT NULL,
	surname VARCHAR(30) NOT NULL,
	middlename VARCHAR(30),
	sex VARCHAR(1) DEFAULT '-',
	education VARCHAR(30),
	birthDate DATE,
	specialty VARCHAR(30),
	qualification VARCHAR(30),
	CONSTRAINT PK_Employees PRIMARY KEY (id),
	CONSTRAINT CK_Employees_sex CHECK (sex IN ('-', 'M', 'F')),
)
ALTER TABLE Managers 
ADD CONSTRAINT FK_Managers_Employees FOREIGN KEY (employeeID) REFERENCES Employees (id) ON DELETE NO ACTION;

CREATE TABLE Documents
(
	id INT IDENTITY(1, 1) NOT NULL,
	employeeID INT NOT NULL,
	documentType VARCHAR(30) NOT NULL,
	document VARBINARY(MAX),
	CONSTRAINT PK_Documents PRIMARY KEY (id),
	CONSTRAINT FK_Documents_Employees FOREIGN KEY (employeeID) REFERENCES Employees (id) ON DELETE CASCADE,
)

CREATE TABLE EmployeePositions 
(
	id INT IDENTITY(1, 1) NOT NULL,
	appointmentDate DATE NOT NULL,
	annualLeave INT NOT NULL,
	positionID INT NOT NULL,
	workerCategory INT,
	departmentID INT,
	positionStatus VARCHAR(7) DEFAULT 'future', 
	employeeID INT,
	CONSTRAINT PK_EmployeePositions PRIMARY KEY (id), 
	CONSTRAINT CK_EmployeePositions_annualLeave CHECK (annualLeave BETWEEN 24 AND 59), 
	CONSTRAINT FK_EmployeePositions_Departments FOREIGN KEY (departmentID) REFERENCES Departments (id) ON DELETE CASCADE, 
	CONSTRAINT CK_EmployeePositions_positionStatus CHECK (positionStatus IN ('current', 'past', 'future')), 
	CONSTRAINT FK_EmployeePositions_Employees FOREIGN KEY (employeeID) REFERENCES Employees (id) ON DELETE CASCADE 
)

CREATE TABLE Positions
(
	id INT IDENTITY(1, 1) NOT NULL,
	positionName VARCHAR(50) NOT NULL,
	wageRate MONEY,
	category VARCHAR(10) NOT NULL,
	payment VARCHAR(9) NOT NULL,
	CONSTRAINT PK_Positions PRIMARY KEY (id),
	CONSTRAINT CK_Positions_wageRate CHECK (wageRate > 0),
	CONSTRAINT CK_Positions_category CHECK (category IN ('kerivnyk', 'fahivets', 'slujbovets', 'robitnik')),
	CONSTRAINT CK_Positions_payment CHECK (payment IN ('pohodinna', 'vidryadna'))
)
ALTER TABLE EmployeePositions
ADD CONSTRAINT FK_EmployeePositions_Positions FOREIGN KEY (positionID) REFERENCES Positions (id) ON DELETE NO ACTION; 


CREATE TABLE WorkerCategories
(
	category INT NOT NULL,
	coefficient DECIMAL(3, 2) NOT NULL
	CONSTRAINT PK_WorkerCategories PRIMARY KEY (category),
	CONSTRAINT CK_WorkerCategories_category CHECK (category > 0),
	CONSTRAINT CK_WorkerCategories_coefficient CHECK (coefficient >= 1)
)
ALTER TABLE EmployeePositions
ADD CONSTRAINT FK_EmployeePositions_WorkerCategories FOREIGN KEY (workerCategory) REFERENCES WorkerCategories (category) ON DELETE CASCADE; 

CREATE TABLE Bonuses
(
	id INT IDENTITY(1, 1) NOT NULL,
	bonusType VARCHAR(200) NOT NULL,
	precentage INT NOT NULL,
	CONSTRAINT PK_Bonuses PRIMARY KEY (id),
	CONSTRAINT CK_Bonuses_precentage CHECK (precentage BETWEEN 0 AND 100),
)

CREATE TABLE EmployeePositionsBonuses 
(
	employeePositionID INT NOT NULL, 
	bonusID INT NOT NULL,
	CONSTRAINT PK_EmployeePositionsBonuses PRIMARY KEY (employeePositionID, bonusID), 
	CONSTRAINT FK_EmployeePositionsBonuses_EmployeePositions FOREIGN KEY (employeePositionID) REFERENCES EmployeePositions (id) ON DELETE CASCADE, 
	CONSTRAINT FK_EmployeePositionsBonuses_Bonuses FOREIGN KEY (bonusID) REFERENCES Bonuses (id) ON DELETE CASCADE 
)

CREATE TABLE Allowances
(
	id INT IDENTITY(1, 1) NOT NULL,
	allowanceType VARCHAR(200) NOT NULL,
	precentage INT NOT NULL,
	CONSTRAINT PK_Allowances PRIMARY KEY (id),
	CONSTRAINT CK_Allowances_precentage CHECK (precentage BETWEEN 0 AND 100),
)

CREATE TABLE EmployeePositionsAllowances
(
	employeePositionID INT NOT NULL, 
	allowanceID INT NOT NULL,
	CONSTRAINT PK_EmployeePositionsAllowances PRIMARY KEY (employeePositionID, allowanceID), 
	CONSTRAINT FK_EmployeePositionsAllowances_EmployeePositions FOREIGN KEY (employeePositionID) REFERENCES EmployeePositions (id) ON DELETE CASCADE, 
	CONSTRAINT FK_EmployeePositionsAllowances_Allowances FOREIGN KEY (allowanceID) REFERENCES Allowances (id) ON DELETE CASCADE 
)

CREATE TABLE Timesheets
(
	id INT IDENTITY(1, 1) NOT NULL,
	dateYear INT NOT NULL,
	dateMonth INT NOT NULL,
	employeePositionID INT NOT NULL, 
	CONSTRAINT PK_Timesheets PRIMARY KEY (id),
	CONSTRAINT CK_Timesheets_dateYear CHECK (dateYear > 0),
	CONSTRAINT CK_Timesheets_dateMonth CHECK (dateMonth BETWEEN 1 AND 12),
	CONSTRAINT FK_Timesheets_EmployeePositions FOREIGN KEY (employeePositionID) REFERENCES EmployeePositions (id) ON DELETE NO ACTION 
)

CREATE TABLE TimeSpendings
(
	id INT IDENTITY(1, 1) NOT NULL,
	dateDay INT NOT NULL,
	hoursAmount INT NOT NULL,
	spendingType VARCHAR(2) NOT NULL,
	timesheetID INT NOT NULL,
	CONSTRAINT PK_TimeSpendings PRIMARY KEY (id),
	CONSTRAINT CK_TimeSpendings_dateDay CHECK (dateDay BETWEEN 1 AND 31),
	CONSTRAINT CK_TimeSpendings_hoursAmount CHECK (hoursAmount BETWEEN 0 AND 24),
	CONSTRAINT FK_TimeSpendings_Timesheets FOREIGN KEY (timesheetID) REFERENCES Timesheets (id) ON DELETE CASCADE
)

CREATE TABLE Products
(
	id INT IDENTITY(1, 1) NOT NULL,
	productName VARCHAR(30) NOT NULL,
	timeToMake INT NOT NULL,
	CONSTRAINT PK_Products PRIMARY KEY (id),
	CONSTRAINT CK_Products_timeToMake CHECK (timeToMake > 0),
)

CREATE TABLE WorkAccounting
(
	id INT IDENTITY(1, 1) NOT NULL,
	productID INT NOT NULL,
	productAmount INT NOT NULL,
	employeePositionID INT NOT NULL, 
	workDate DATE NOT NULL,
	CONSTRAINT PK_WorkAccounting PRIMARY KEY (id),
	CONSTRAINT CK_WorkAccounting_productAmount CHECK (productAmount > 0),
	CONSTRAINT FK_WorkAccounting_Products FOREIGN KEY (productID) REFERENCES Products (id) ON DELETE CASCADE,
	CONSTRAINT FK_WorkAccounting_EmployeePositions FOREIGN KEY (employeePositionID) REFERENCES EmployeePositions (id) ON DELETE CASCADE 
)