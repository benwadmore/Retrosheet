﻿CREATE PROCEDURE DW.DimBallParkStaging_Create
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;

			DROP TABLE IF EXISTS DW.DimBallParkStaging;

			CREATE TABLE DW.DimBallParkStaging (
				BallParkCode VARCHAR(5) NOT NULL,
				BallParkName VARCHAR(50) NULL,
				BallParkAlsoKnownAs VARCHAR(50) NULL,
				BallParkCity VARCHAR(50) NULL,
				BallParkState VARCHAR(50) NULL,
				BallParkStartDate DATE NULL,
				BallParkEndDate DATE NULL
			);

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END