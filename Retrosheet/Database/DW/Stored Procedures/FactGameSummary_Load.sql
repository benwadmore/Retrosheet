CREATE PROCEDURE DW.FactGameSummary_Load
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;

		select * from DW.FactGameSummary

		-- USE A CROSS APPLY TO DW.DimTeam, using game date and actual franchise code, to work out the correct version of the team to put as home and visiting team ids
		SELECT		BP.BallParkId,
					GL.GameDate AS DateId,
					GNOD.GameNumberOnDateId,
					VTX.TeamId AS VisitingTeamId,
					GL.VisitingTeamGameNumber,
					HTX.TeamId AS HomeTeamId,
					GL.HomeTeamGameNumber
		FROM		Staging.GameLog GL
		JOIN		DW.DimBallPark BP ON GL.ParkId = BP.BallParkName
		JOIN		DW.DimGameNumberOnDate GNOD ON GL.GameNumberOnDate = GNOD.GameNumberOnDateCode
		CROSS APPLY (
					SELECT		TOP 1
								VT.TeamId
					FROM		DW.DimTeam VT
					WHERE		GL.VisitingTeam = VT.ActualFranchiseCode
					AND			CAST(GL.GameDate AS DATE) BETWEEN VT.FirstGameDate AND VT.LastGameDate
					) VTX
		CROSS APPLY (
					SELECT		TOP 1
								HT.TeamId
					FROM		DW.DimTeam HT
					WHERE		GL.HomeTeam = HT.ActualFranchiseCode
					AND			CAST(GL.GameDate AS DATE) BETWEEN HT.FirstGameDate AND HT.LastGameDate
					) HTX	

			-- Update existing rows

			-- Insert new rows

			-- Drop staging table in DW
			DROP TABLE	DW.FactGameSummaryStaging;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END