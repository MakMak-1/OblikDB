/*
1. Функція, що визначає посади, які обіймав працівник протягом певного місяця
*/
CREATE PROCEDURE GetEmployeePositionIDs
    @EmployeeID INT,
    @Year INT,
	@Month INT
AS
BEGIN
	SET NOCOUNT ON;

	DECLARE @InMonthCount INT;

	SELECT @InMonthCount = COUNT(*)
	FROM EmployeePositions
	INNER JOIN Employees ON employeeID = Employees.id
	WHERE Employees.id = @EmployeeID AND YEAR(appointmentDate) = @Year AND MONTH(appointmentDate) = @Month;

	SET @InMonthCount = @InMonthCount + 1;

	SELECT TOP (@InMonthCount) EmployeePositions.id
	FROM EmployeePositions
	INNER JOIN Employees ON employeeID = Employees.id
	WHERE Employees.id = @EmployeeID AND (YEAR(appointmentDate) < @Year OR (YEAR(appointmentDate) = @Year AND MONTH(appointmentDate) <= @Month))
	ORDER BY appointmentDate DESC;
	END;
GO

/*
2. Функція, що обчислює відрядну розцінку виробу
*/
CREATE FUNCTION CalculateProductValue (@ProductID INT, @EmployeePositionID INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @Coefficient DECIMAL(3, 2);
	DECLARE @TimeToMake INT;
	DECLARE @Result MONEY;
   
    SELECT @TimeToMake = timeToMake
	FROM Products
	WHERE Products.id = @ProductID;

	SELECT @Coefficient = coefficient 
	FROM WorkerCategories
	INNER JOIN EmployeePositions ON WorkerCategories.category = workerCategory
	WHERE EmployeePositions.id = @EmployeePositionID;

	SET @Result = @TimeToMake * @Coefficient;

    RETURN @Result;
END;
GO

/*
3. Функція, яка повертає форму оплати працівника 
*/
CREATE FUNCTION GetPaymentForm (@EmployeePositionID INT)
RETURNS VARCHAR(9)
AS
BEGIN
    DECLARE @PaymentFrom VARCHAR(9);
   
    SELECT @PaymentFrom = payment
	FROM Positions 
	INNER JOIN EmployeePositions ON Positions.id = positionID
	WHERE EmployeePositions.id = @EmployeePositionID;

    RETURN @PaymentFrom;
END;
GO

/*
4. Функція, яка обчислює основну частину зарплати відрядної форми оплати за певний місяць для певного робітника
*/
CREATE FUNCTION CalculateVidryadna (@EmployeePositionID INT, @Year INT, @Month INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @Result MONEY;
   
    SELECT @Result = SUM(dbo.CalculateProductValue(productID, @EmployeePositionID) * productAmount)
	FROM EmployeePositions
	INNER JOIN WorkAccounting ON EmployeePositions.id = WorkAccounting.employeePositionID
	WHERE YEAR(workDate) = @Year AND MONTH(workDate) = @Month AND EmployeePositions.id = @EmployeePositionID;

    RETURN @Result;
END;
GO

/*
5. Функція, яка обчислює основну частину зарплати погодинної форми оплати за певний місяць для певного працівника
*/
CREATE FUNCTION CalculatePohodinna (@EmployeePositionID INT, @Year INT, @Month INT)
RETURNS MONEY
AS
BEGIN
    DECLARE @Result MONEY;
	DECLARE @TotalHours INT;
	DECLARE @WageRate MONEY;
   
    SELECT @WageRate = wageRate
	FROM EmployeePositions
	INNER JOIN Positions ON positionID = Positions.id
	WHERE EmployeePositions.id = @EmployeePositionID;

	SELECT @TotalHours = SUM(hoursAmount)
	FROM EmployeePositions
	INNER JOIN Timesheets ON EmployeePositions.id = Timesheets.employeePositionID
	INNER JOIN TimeSpendings ON Timesheets.id = timesheetID
	WHERE dateYear = @Year AND dateMonth = @Month AND EmployeePositions.id = @EmployeePositionID;

	SET @Result = @TotalHours * @WageRate;

    RETURN @Result;
END;
GO

/*
6. Процедура, яка обчислює основну частину зарплати за певний місяць для певного робітника
*/
CREATE PROCEDURE CalculateMain
    @EmployeePositionID INT,
    @Year INT,
	@Month INT,
	@Result MONEY OUTPUT
AS
BEGIN
	DECLARE @PaymentForm VARCHAR(9);
	
	SET @PaymentForm = dbo.GetPaymentForm(@EmployeePositionID);

    IF @PaymentForm = 'vidryadna'
    BEGIN
        SET @Result = 0 + dbo.CalculateVidryadna(@EmployeePositionID, @Year, @Month);
    END
    ELSE
    BEGIN
        SET @Result = 0 + dbo.CalculatePohodinna(@EmployeePositionID, @Year, @Month);
    END
END;
GO

/*
7. Процедура, що рахує відсоток додаткової частини зарплати працівника
*/
CREATE PROCEDURE CalculateAdditional
    @EmployeePositionID INT,
	@Result INT OUTPUT
AS
BEGIN
	DECLARE @BonusPart INT;
	DECLARE @AllowancePart INT;
	
	SET @Result = 0

    SELECT @BonusPart = SUM(precentage)
	FROM EmployeePositions
	INNER JOIN EmployeePositionsBonuses ON EmployeePositions.id = EmployeePositionsBonuses.employeePositionID
	INNER JOIN Bonuses ON EmployeePositionsBonuses.bonusID = Bonuses.id
	WHERE EmployeePositions.id = @EmployeePositionID;

	IF @BonusPart IS NOT NULL
	BEGIN 
		SET @Result = @Result + @BonusPart;
	END

	SELECT @AllowancePart = SUM(precentage)
	FROM EmployeePositions
	INNER JOIN EmployeePositionsAllowances ON EmployeePositions.id = EmployeePositionsAllowances.employeePositionID
	INNER JOIN Allowances ON EmployeePositionsAllowances.allowanceID = Allowances.id
	WHERE EmployeePositions.id = @EmployeePositionID;

	IF @AllowancePart IS NOT NULL
	BEGIN 
		SET @Result = @Result + @AllowancePart;
	END

    RETURN @Result;
END;
GO

/*
8. Процедура, що рахує зарплату за певний місяць для певного робітника
*/
CREATE PROCEDURE CalculateSalary
    @EmployeeID INT,
	@Year INT,
	@Month INT,
	@Result MONEY OUTPUT
AS
BEGIN
	IF NOT EXISTS (SELECT * FROM Employees WHERE id = @EmployeeID)
	BEGIN;
		THROW 50000, 'Employee doesnt exist', 1;
	END;

	SET NOCOUNT ON;

	DECLARE @MainPart MONEY;
	DECLARE @AdditionalPrecentage INT;
	DECLARE @currEmployeePosID INT;

	CREATE TABLE #tmpEmployeePosIDs (id INT);

	INSERT INTO #tmpEmployeePosIDs (id)
	EXEC GetEmployeePositionIDs @EmployeeID = @EmployeeID, @Year = @Year, @Month = @Month;

	DECLARE idCursor CURSOR FOR
	SELECT id FROM #tmpEmployeePosIDs;

	OPEN idCursor;

	FETCH NEXT FROM idCursor INTO @currEmployeePosID;

	SET @Result = 0

	WHILE @@FETCH_STATUS = 0
	BEGIN
		EXEC CalculateMain @EmployeePositionID = @currEmployeePosID, @Year = @Year, @Month = @Month, @Result = @MainPart OUTPUT;
		EXEC CalculateAdditional @EmployeePositionID = @currEmployeePosID, @Result = @AdditionalPrecentage OUTPUT;

		SET @Result = @Result + (@MainPart + @MainPart * @AdditionalPrecentage / 100);

		FETCH NEXT FROM idCursor INTO @currEmployeePosID;
	END;

	CLOSE idCursor;
END;
GO

/*
9. Процедура, що використовується для переведення працівника на іншу посаду
*/
CREATE PROCEDURE MoveEmployee
	@EmployeeID INT,
	@EmployeePositionID INT
AS
BEGIN
	-- Check status
	DECLARE @Status VARCHAR(7);

	SELECT @Status = positionStatus
	FROM EmployeePositions
	WHERE EmployeePositions.id = @EmployeePositionID;

	IF NOT (@Status = 'future')
	BEGIN;
		THROW 51000, 'EmployeePosition status must be future', 1;
	END;

	-- Compare last work date to appointment date
	DECLARE @lastYear INT;
	DECLARE @lastMonth INT;
	DECLARE @lastDay INT;
	DECLARE @lastDate DATE;
	DECLARE @appoitmentDate DATE;

	SELECT @lastYear = MAX(dateYear)
	FROM EmployeePositions
	INNER JOIN Timesheets ON EmployeePositions.id = employeePositionID
	WHERE EmployeePositions.id = @EmployeePositionID;

	SELECT @lastMonth = MAX(dateMonth)
	FROM EmployeePositions
	INNER JOIN Timesheets ON EmployeePositions.id = employeePositionID
	WHERE EmployeePositions.id = @EmployeePositionID AND dateYear = @lastYear;

	SELECT @lastDay = MAX(dateDay)
	FROM EmployeePositions
	INNER JOIN Timesheets ON EmployeePositions.id = employeePositionID
	INNER JOIN TimeSpendings ON Timesheets.id = timesheetID
	WHERE EmployeePositions.id = @EmployeePositionID AND dateYear = @lastYear AND dateMonth = @lastMonth;

	SET @lastDate = DATEFROMPARTS(@lastYear, @lastMonth, @lastDay)

	SELECT @appoitmentDate = appointmentDate
	FROM EmployeePositions
	WHERE EmployeePositions.id = @EmployeePositionID;

	IF (@appoitmentDate <= @lastDate)
	BEGIN;
		THROW 52000, 'Appoitment date cant be before last work date', 1;
	END;

	-- Change status on current to past
	DECLARE @currPositionID INT;

	SELECT @currPositionID = EmployeePositions.id 
	FROM EmployeePositions
	INNER JOIN Employees ON employeeID = Employees.id
	WHERE Employees.id = @EmployeeID AND positionStatus = 'current';

	IF EXISTS (SELECT * FROM EmployeePositions WHERE id = @currPositionID)
	BEGIN
		UPDATE EmployeePositions
		SET positionStatus = 'past'
		WHERE id = @currPositionID;
	END;

	-- Change status on future to current
	UPDATE EmployeePositions
	SET positionStatus = 'current'
	WHERE id = @EmployeePositionID;

	-- Set employeeID on position
	UPDATE EmployeePositions
	SET employeeID = @EmployeeID
	WHERE id = @EmployeePositionID;
END;
GO

/*
10. Процедура, що видаляє табелі, в зберіганні яких немає потреби (більше 1 року)
*/
CREATE PROCEDURE DeleteOldTimesheets
AS
BEGIN
	DECLARE @TotalMonths INT;

	SET @TotalMonths = (YEAR(GETDATE()) - 1) * 12 + MONTH(GETDATE());

	DELETE FROM Timesheets
	WHERE @TotalMonths - ((dateYear - 1) * 12 + dateMonth) > 12;
END;
GO