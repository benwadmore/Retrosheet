CREATE TABLE [dbo].[DimCoach]
(
	[CoachId]		INT NOT NULL,
	[PersonnelCode]	VARCHAR (10) NULL,
	[FirstName]		VARCHAR (50) NULL,
    [LastName]		VARCHAR (50) NULL,
	CONSTRAINT PK_DimCoach PRIMARY KEY CLUSTERED (CoachId)
)
