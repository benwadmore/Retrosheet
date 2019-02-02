CREATE PROCEDURE DW.DimBallPark_Load
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;
			
			-- Update existing rows
			UPDATE		DW.DimBallPark
			SET			BallParkCode = BPS.BallParkCode,
						BallParkName = BPS.BallParkName,
						BallParkAlsoKnownAs = BPS.BallParkAlsoKnownAs,
						BallParkCity = BPS.BallParkCity,
						BallParkState = BPS.BallParkState,
						BallParkStartDate = BPS.BallParkStartDate,
						BallParkEndDate = BPS.BallParkEndDate
			FROM		DW.DimBallParkStaging BPS
			JOIN		DW.DimBallPark BP ON BPS.BallParkCode = BP.BallParkCode
			WHERE		BP.BallParkCode <> BPS.BallParkCode
			OR			BP.BallParkName <> BPS.BallParkName 
			OR			BP.BallParkAlsoKnownAs <> BPS.BallParkAlsoKnownAs
			OR			BP.BallParkCity <> BPS.BallParkCity
			OR			BP.BallParkState <> BPS.BallParkState
			OR			BP.BallParkStartDate <> BPS.BallParkStartDate
			OR			BP.BallParkEndDate <> BPS.BallParkEndDate;

			-- Insert new rows
			INSERT INTO DW.DimBallPark
						(
						BallParkCode,
						BallParkName,
						BallParkAlsoKnownAs,
						BallParkCity,
						BallParkState,
						BallParkStartDate,
						BallParkEndDate
						)
			SELECT		BallParkCode,
						BallParkName,
						BallParkAlsoKnownAs,
						BallParkCity,
						BallParkState,
						BallParkStartDate,
						BallParkEndDate
			FROM		DW.DimBallParkStaging BPS
			WHERE		NOT EXISTS (SELECT 1 FROM DW.DimBallPark BP WHERE BPS.BallParkCode = BP.BallParkCode);

			-- Drop staging table in DW
			DROP TABLE	DW.DimBallParkStaging;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END