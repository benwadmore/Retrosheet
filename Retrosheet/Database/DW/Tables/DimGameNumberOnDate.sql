CREATE TABLE [DW].[DimGameNumberOnDate]
(
	[GameNumberOnDateId] INT IDENTITY(1, 1) NOT NULL,
	[GameNumberOnDateCode] CHAR(1) NOT NULL,
	[GameNumberOnDateName] VARCHAR(50) NOT NULL,
	CONSTRAINT PK_DimGameNumberOnDate PRIMARY KEY CLUSTERED (GameNumberOnDateId)
) ON [PRIMARY];
