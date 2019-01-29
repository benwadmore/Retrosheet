CREATE TABLE DW.DimPerson
(
	PersonId			INT IDENTITY(1, 1) NOT NULL,
	PersonnelCode		VARCHAR (8) NOT NULL,
	FirstName			VARCHAR (50) NOT NULL,
    LastName			VARCHAR (50) NOT NULL,
	PlayerDebutDate	DATE NULL,
	ManagerDebutDate	DATE NULL,
	CoachDebutDate	DATE NULL,
	UmpireDebutDate	DATE NULL,
	CONSTRAINT PK_DimPerson PRIMARY KEY CLUSTERED (PersonId)
);