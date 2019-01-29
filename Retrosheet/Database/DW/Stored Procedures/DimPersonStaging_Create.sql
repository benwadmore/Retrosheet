CREATE PROCEDURE DW.DimPersonStaging_Create
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;

			DROP TABLE IF EXISTS DW.DimPersonStaging;

			CREATE TABLE DW.DimPersonStaging(
				PersonId int NOT NULL,
				PersonnelCode varchar(8) NOT NULL,
				FirstName varchar(50) NOT NULL,
				LastName varchar(50) NOT NULL,
				PlayerDebutDate date NULL,
				ManagerDebutDate date NULL,
				CoachDebutDate date NULL,
				UmpireDebutDate date NULL
			) ON [PRIMARY];

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END