USE oblikDB
GO

CREATE VIEW PositionsView
AS
SELECT id, positionName, category, payment
FROM Positions;
GO

CREATE VIEW ProductsView
AS
SELECT id, productName
FROM Products;
GO

CREATE VIEW CurrentPositions
AS
SELECT *
FROM EmployeePositions
WHERE positionStatus = 'current'
GO

SELECT *
FROM CurrentPositions