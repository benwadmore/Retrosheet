CREATE TABLE DW.DimPerson
(
	PersonId			INT IDENTITY(1, 1) NOT NULL,
	PersonnelCode		VARCHAR (8) NOT NULL,
	FirstName			VARCHAR (50) NOT NULL,
    LastName			VARCHAR (50) NOT NULL,
	PlayerDebutDate		DATE NULL,
	ManagerDebutDate	DATE NULL,
	CoachDebutDate		DATE NULL,
	UmpireDebutDate		DATE NULL,
	DateTimeCreated		DATETIME NOT NULL CONSTRAINT DF_DimPerson_DateTimeCreated DEFAULT GETDATE(),
	DateTimeUpdated		DATETIME NOT NULL CONSTRAINT DF_DimPerson_DateTimeUpdated DEFAULT GETDATE(),
	CONSTRAINT PK_DimPerson PRIMARY KEY CLUSTERED (PersonId)
);
GO

CREATE TRIGGER DW.DimPersonUpdate ON DW.DimPerson
AFTER UPDATE  
AS 
BEGIN

	-- Make sure that the trigger only fires if one of the main columns is updated, not just if the updated date is changed
	-- Otherwise the trigger will endlessly loop
	IF	UPDATE(PersonnelCode) OR UPDATE(FirstName) OR UPDATE(LastName) OR UPDATE(PlayerDebutDate) OR 
		UPDATE(ManagerDebutDate) OR UPDATE(CoachDebutDate) OR UPDATE(UmpireDebutDate)
	
		-- Change "updated" date time for any rows that have materially changed
		UPDATE		P
		SET			DateTimeUpdated = GETDATE()
		FROM		DW.DimPerson P
		WHERE		EXISTS	(
							SELECT		1
							FROM		inserted I
							JOIN		deleted D ON I.PersonId = D.PersonId
							WHERE		(
										I.FirstName <> D.FirstName OR
										I.LastName <> D.LastName OR 
										I.PlayerDebutDate <> D.PlayerDebutDate OR
										I.ManagerDebutDate <> D.ManagerDebutDate OR
										I.CoachDebutDate <> D.CoachDebutDate OR
										I.UmpireDebutDate <> D.UmpireDebutDate
										)
							AND			I.PersonId = P.PersonId
							);

END 
GO  