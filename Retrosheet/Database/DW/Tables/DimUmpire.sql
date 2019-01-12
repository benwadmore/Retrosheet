CREATE TABLE [dbo].[DimUmpire]
(
	[UmpireId]		INT NOT NULL,
	[PersonnelCode]	VARCHAR (10) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	CONSTRAINT PK_DimUmpire PRIMARY KEY CLUSTERED (UmpireId)
)
