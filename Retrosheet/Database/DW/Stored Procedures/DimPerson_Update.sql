CREATE PROCEDURE DW.DimPerson_Update
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;

			UPDATE		DW.DimPerson
			SET			PersonnelCode = PS.PersonnelCode,
						FirstName = PS.FirstName,
						LastName = PS.LastName,
						PlayerDebutDate = PS.PlayerDebutDate,
						ManagerDebutDate = PS.ManagerDebutDate,
						CoachDebutDate = PS.CoachDebutDate,
						UmpireDebutDate = PS.UmpireDebutDate
			FROM		DW.DimPersonStaging PS
			JOIN		DW.DimPerson P ON PS.PersonId = P.PersonId;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END