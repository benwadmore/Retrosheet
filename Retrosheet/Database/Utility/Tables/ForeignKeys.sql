﻿CREATE TABLE Utility.ForeignKey
(
	ForeignKeyId INT IDENTITY(1, 1) NOT NULL,
	ForeignKeyFromSchema NVARCHAR(128) NOT NULL,
	ForeignKeyFromTable NVARCHAR(128) NOT NULL,
	ForeignKeyFromColumn NVARCHAR(128) NOT NULL,
	ForeignKeyToSchema NVARCHAR(128) NOT NULL,
	ForeignKeyToTable NVARCHAR(128) NOT NULL,
	ForeignKeyToColumn NVARCHAR(128) NOT NULL,
	CONSTRAINT PK_ForeignKey PRIMARY KEY CLUSTERED (ForeignKeyId)
)