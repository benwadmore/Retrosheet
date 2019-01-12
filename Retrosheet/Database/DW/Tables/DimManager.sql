CREATE TABLE [DW].[DimManager]
(
	[ManagerId]		INT IDENTITY(1, 1) NOT NULL,
	[PersonnelCode]	VARCHAR (8) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	[DebutDate]		DATE NOT NULL,
	CONSTRAINT PK_DimManager PRIMARY KEY CLUSTERED (ManagerId)
)
