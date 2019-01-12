CREATE TABLE [DW].[DimPlayer]
(
	[PlayerId]		INT IDENTITY(1, 1) NOT NULL,
	[PersonCode]	VARCHAR (8) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	[DebutDate]		DATE NOT NULL,
	CONSTRAINT PK_DimPlayer PRIMARY KEY CLUSTERED (PlayerId)
)
