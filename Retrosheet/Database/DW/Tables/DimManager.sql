CREATE TABLE [dbo].[DimManager]
(
	[ManagerId]		INT NOT NULL,
	[PersonnelCode]	VARCHAR (10) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	CONSTRAINT PK_DimManager PRIMARY KEY CLUSTERED (ManagerId)
)
