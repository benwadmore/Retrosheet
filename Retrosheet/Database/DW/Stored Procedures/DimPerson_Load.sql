CREATE PROCEDURE DW.DimPerson_Load
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;
			
			-- Update existing rows
			UPDATE		DW.DimPerson
			SET			FirstName = PS.FirstName,
						LastName = PS.LastName,
						PlayerDebutDate = PS.PlayerDebutDate,
						ManagerDebutDate = PS.ManagerDebutDate,
						CoachDebutDate = PS.CoachDebutDate,
						UmpireDebutDate = PS.UmpireDebutDate
			FROM		DW.DimPersonStaging PS
			JOIN		DW.DimPerson P ON PS.PersonnelCode = P.PersonnelCode
			WHERE		P.FirstName <> PS.FirstName
			OR			P.LastName <> PS.LastName 
			OR			P.PlayerDebutDate <> PS.PlayerDebutDate
			OR			P.ManagerDebutDate <> PS.ManagerDebutDate
			OR			P.CoachDebutDate <> PS.CoachDebutDate
			OR			P.UmpireDebutDate <> PS.UmpireDebutDate;

			-- Insert new rows
			INSERT INTO DW.DimPerson
						(
						PersonnelCode,
						LastName,
						FirstName,
						PlayerDebutDate,
						ManagerDebutDate,
						CoachDebutDate,
						UmpireDebutDate
						)
			SELECT		PersonnelCode,
						LastName,
						FirstName,
						PlayerDebutDate,
						ManagerDebutDate,
						CoachDebutDate,
						UmpireDebutDate
			FROM		DW.DimPersonStaging PS
			WHERE		NOT EXISTS (SELECT 1 FROM DW.DimPerson P WHERE PS.PersonnelCode = P.PersonnelCode);

			-- Drop staging table in DW
			DROP TABLE	DW.DimPersonStaging;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END