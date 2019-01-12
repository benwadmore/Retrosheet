CREATE TABLE [dbo].[DimPlayer]
(
	[PlayerId]		INT NOT NULL,
	[PersonCode]	VARCHAR (10) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	CONSTRAINT PK_DimPlayer PRIMARY KEY CLUSTERED (PlayerId)
)
