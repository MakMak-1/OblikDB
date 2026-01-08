USE oblikDB
GO

/*
Табель має зберігатися на підприємстві принаймні один рік
*/
CREATE TRIGGER OnDelete_Timesheet
ON Timesheets
INSTEAD OF DELETE
AS
BEGIN
	DECLARE @Year INT;
	DECLARE @Month INT;
	DECLARE @ID INT;
	DECLARE @MonthDiff INT;

	SELECT @Year = dateYear, @ID = id, @Month = dateMonth
	FROM deleted;

	SET @MonthDiff = ((YEAR(GETDATE()) - 1) * 12 + MONTH(GETDATE())) - ((@Year - 1) * 12 + @Month);

	IF (@MonthDiff < 12)
	BEGIN;
		THROW 50001, 'Timesheet must be at least 1 year old', 1;
	END;

	DELETE FROM Timesheets
	WHERE id = @ID;
END;
GO

/*
Працівник може не відноситися тільки до відділу якщо він є керівником
Future може бути тільки один, вставляти можна тільки future
*/
CREATE TRIGGER OnInsert_EmplyeePosition
ON EmployeePositions
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @DepartmentID INT;
	DECLARE @EmployeeID INT;
	DECLARE @Status VARCHAR(7);


	SELECT @DepartmentID = departmentID, @EmployeeID = employeeID, @Status = positionStatus
	FROM inserted;

	IF NOT (@Status = 'future')
	BEGIN;
		THROW 56000, 'Inserted position status must only be future', 1;
	END;

	IF EXISTS (SELECT * FROM EmployeePositions WHERE employeeID = @EmployeeID AND positionStatus = 'future')
	BEGIN;
		THROW 57000, 'There is already a future position', 1;
	END;

	IF (@DepartmentID IS NULL)
	BEGIN
		DECLARE @PositionID INT;
		DECLARE @Category VARCHAR(10);

		SELECT @PositionID = positionID
		FROM inserted;

		SELECT @Category = category
		FROM Positions
		WHERE Positions.id = @PositionID;

		IF NOT (@Category = 'kerivnyk')
		BEGIN;
			THROW 53000, 'Employee, who is not kerivnyk, must belong to a department.', 1;
		END;
	END;

	INSERT INTO EmployeePositions (appointmentDate, annualLeave, positionID, workerCategory, departmentID, positionStatus, employeeID)
	SELECT appointmentDate, annualLeave, positionID, workerCategory, departmentID, positionStatus, employeeID FROM inserted;
END;
GO

--Не можна змінювати статус
CREATE TRIGGER OnUpdate_EmplyeePosition
ON EmployeePositions
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @DepartmentID INT;
	DECLARE @OldStatus VARCHAR(7);
	DECLARE @NewStatus VARCHAR(7);

	SELECT @OldStatus = positionStatus
	FROM deleted;

	SELECT @DepartmentID = departmentID, @NewStatus = positionStatus
	FROM inserted;

	IF NOT (@OldStatus = @NewStatus)
	BEGIN;
		THROW 57000, 'Status is immutable', 1;
	END;

	IF (@DepartmentID IS NULL)
	BEGIN
		DECLARE @PositionID INT;
		DECLARE @Category VARCHAR(10);

		SELECT @PositionID = positionID
		FROM inserted;

		SELECT @Category = category
		FROM Positions
		WHERE Positions.id = @PositionID;

		IF NOT (@Category = 'kerivnyk')
		BEGIN;
			THROW 53000, 'Employee, who is not kerivnyk, must belong to a department.', 1;
		END;
	END;

	UPDATE EmployeePositions
	SET appointmentDate = i.appointmentDate, annualLeave = i.annualLeave, positionID = i.positionID, workerCategory = i.workerCategory, departmentID = i.departmentID, positionStatus = i.positionStatus, employeeID = i.employeeID
	FROM inserted AS i
	WHERE EmployeePositions.id = i.id;
END;
GO

/*
Облік виконаних робіт ведеться тільки для відрядної форми
*/
CREATE TRIGGER OnInsert_WorkAccounting
ON WorkAccounting
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @EmployeePositionID INT;
	DECLARE @PaymentForm VARCHAR(9);

	SELECT @EmployeePositionID = employeePositionID
	FROM inserted;

	SELECT @PaymentForm = payment
	FROM EmployeePositions
	INNER JOIN Positions ON positionID = Positions.id
	WHERE EmployeePositions.id = @EmployeePositionID;

	IF NOT (@PaymentForm = 'vidryadna')
	BEGIN;
		THROW 54000, 'Cant keep work accouting for employee with pohodinna payment form', 1;
	END;

	INSERT INTO WorkAccounting (productID, productAmount, employeePositionID, workDate)
	SELECT productID, productAmount, employeePositionID, workDate FROM inserted;
END;
GO

CREATE TRIGGER OnUpdate_WorkAccounting
ON WorkAccounting
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @EmployeePositionID INT;
	DECLARE @PaymentForm VARCHAR(9);

	SELECT @EmployeePositionID = employeePositionID
	FROM inserted;

	SELECT @PaymentForm = payment
	FROM EmployeePositions
	INNER JOIN Positions ON positionID = Positions.id
	WHERE EmployeePositions.id = @EmployeePositionID;

	IF NOT (@PaymentForm = 'vidryadna')
	BEGIN;
		THROW 54000, 'Cant keep work accouting for employee with pohodinna payment form', 1;
	END;

	UPDATE WorkAccounting
	SET productID = i.productID, productAmount = i.productAmount, employeePositionID = i.employeePositionID, workDate = i.workDate
	FROM inserted AS i
	WHERE WorkAccounting.id = i.id;
END;
GO

/*
Кількість відпусткних днів працівника не повинна перевищувати дозволеної
*/
CREATE TRIGGER OnInsert_TimeSpendings
ON TimeSpendings
INSTEAD OF INSERT
AS 
BEGIN
	DECLARE @TimesheetID INT;
	DECLARE @Year INT;
	DECLARE @AnnualLeave INT;
	DECLARE @LeaveCount INT;
	DECLARE @EmployeePositionID INT;

	SELECT @TimesheetID = timesheetID
	FROM inserted;

	SELECT @AnnualLeave = annualLeave, @Year = dateYear, @EmployeePositionID = EmployeePositions.id
	FROM Timesheets
	INNER JOIN EmployeePositions ON employeePositionID = EmployeePositions.id
	WHERE Timesheets.id = @TimesheetID;

	SELECT @LeaveCount = COUNT(*)
	FROM Timesheets
	INNER JOIN TimeSpendings ON Timesheets.id = timesheetID
	WHERE employeePositionID = @EmployeePositionID AND dateYear = @Year AND spendingType = 'B'

	IF (@LeaveCount >= @AnnualLeave)
	BEGIN;
		THROW 55000, 'Employee cant have another leave', 1;
	END;

	INSERT INTO TimeSpendings (dateDay, hoursAmount, spendingType, timesheetID)
	SELECT dateDay, hoursAmount, spendingType, timesheetID FROM inserted;
END;
GO

CREATE TRIGGER OnUpdate_TimeSpendings
ON TimeSpendings
INSTEAD OF UPDATE
AS 
BEGIN
	DECLARE @TimesheetID INT;
	DECLARE @Year INT;
	DECLARE @AnnualLeave INT;
	DECLARE @LeaveCount INT;
	DECLARE @EmployeePositionID INT;

	SELECT @TimesheetID = timesheetID
	FROM inserted;

	SELECT @AnnualLeave = annualLeave, @Year = dateYear, @EmployeePositionID = EmployeePositions.id
	FROM Timesheets
	INNER JOIN EmployeePositions ON employeePositionID = EmployeePositions.id
	WHERE Timesheets.id = @TimesheetID;

	SELECT @LeaveCount = COUNT(*)
	FROM Timesheets
	INNER JOIN TimeSpendings ON Timesheets.id = timesheetID
	WHERE employeePositionID = @EmployeePositionID AND dateYear = @Year AND spendingType = 'B'

	IF (@LeaveCount >= @AnnualLeave)
	BEGIN;
		THROW 55000, 'Employee cant have another leave', 1;
	END;

	INSERT INTO TimeSpendings (dateDay, hoursAmount, spendingType, timesheetID)
	SELECT dateDay, hoursAmount, spendingType, timesheetID FROM inserted;

	UPDATE TimeSpendings
	SET dateDay = i.dateDay, hoursAmount = i.hoursAmount, spendingType = i.spendingType, timesheetID = i.timesheetID
	FROM inserted AS i
	WHERE TimeSpendings.id = i.id;
END;
GO

/*
Тарифна ставка може мати null значення тільки за відрядної форми оплати
*/
CREATE TRIGGER OnInsert_Positions
ON Positions
INSTEAD OF INSERT
AS
BEGIN
	DECLARE @PaymentForm VARCHAR(9);
	DECLARE @WageRate MONEY;

	SELECT @PaymentForm = payment, @WageRate = wageRate
	FROM inserted;

	IF (@WageRate IS NULL AND @PaymentForm = 'pohodinna')
	BEGIN;
		THROW 58000, 'Wage rate must not be NULL if payment form is pohodinna', 1;
	END;

	IF (@WageRate IS NOT NULL AND @PaymentForm = 'vidryadna')
	BEGIN;
		THROW 59000, 'Wage rate must be NULL if payment form is vidryadna', 1;
	END;

	INSERT INTO Positions (positionName, wageRate, category, payment)
	SELECT positionName, wageRate, category, payment FROM inserted;
END;
GO

CREATE TRIGGER OnUpdate_Positions
ON Positions
INSTEAD OF UPDATE
AS
BEGIN
	DECLARE @PaymentForm VARCHAR(9);
	DECLARE @WageRate MONEY;

	SELECT @PaymentForm = payment, @WageRate = wageRate
	FROM inserted;

	IF (@WageRate IS NULL AND @PaymentForm = 'pohodinna')
	BEGIN;
		THROW 58000, 'Wage rate must not be NULL if payment form is pohodinna', 1;
	END;

	IF (@WageRate IS NOT NULL AND @PaymentForm = 'vidryadna')
	BEGIN;
		THROW 59000, 'Wage rate must be NULL if payment form is vidryadna', 1;
	END;

	UPDATE Positions
	SET positionName = i.positionName, wageRate = i.wageRate, category = i.category, payment = i.payment
	FROM inserted AS i
	WHERE Positions.id = i.id;
END;