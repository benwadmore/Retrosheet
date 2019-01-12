CREATE TABLE [DW].[DimCoach]
(
	[CoachId]		INT IDENTITY(1, 1) NOT NULL,
	[PersonnelCode]	VARCHAR (8) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	[DebutDate]		DATE NOT NULL,
	CONSTRAINT PK_DimCoach PRIMARY KEY CLUSTERED (CoachId)
)
