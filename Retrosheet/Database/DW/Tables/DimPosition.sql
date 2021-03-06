﻿CREATE TABLE DW.DimPosition
(
	PositionId INT IDENTITY(1, 1) NOT NULL,
	PositionNumber TINYINT NOT NULL,
	PositionName VARCHAR(20) NOT NULL,
	DateTimeCreated	DATETIME NOT NULL CONSTRAINT DF_DimPosition_DateTimeCreated DEFAULT GETDATE(),
	DateTimeUpdated	DATETIME NOT NULL CONSTRAINT DF_DimPosition_DateTimeUpdated DEFAULT GETDATE(),
	CONSTRAINT PK_DimPosition PRIMARY KEY CLUSTERED (PositionId)
)
