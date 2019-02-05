CREATE PROCEDURE DW.DimTeam_Load
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;
			
			-- Update existing rows
			UPDATE		DW.DimTeam
			SET			League = TS.League,
						Division = TS.Division,
						[Location] = TS.[Location],
						Nickname = TS.Nickname,
						AlternateNicknames = TS.AlternateNicknames,
						LastGameDate = TS.LastGameDate,
						City = TS.City,
						[State] = TS.[State]
			FROM		DW.DimTeamStaging TS
			JOIN		DW.DimTeam T ON  TS.CurrentFranchiseCode = T.CurrentFranchiseCode
									 AND TS.ActualFranchiseCode = T.ActualFranchiseCode
									 AND TS.FirstGameDate = T.FirstGameDate
			WHERE		T.League <> TS.League
			OR			T.Division <> TS.Division
			OR			T.[Location] <> TS.[Location]
			OR			T.Nickname <> TS.Nickname
			OR			T.AlternateNicknames <> TS.AlternateNicknames
			OR			T.LastGameDate <> TS.LastGameDate
			OR			T.City <> TS.City
			OR			T.[State] <> TS.[State];

			-- Insert new rows
			INSERT INTO DW.DimTeam
						(
						CurrentFranchiseCode,
						ActualFranchiseCode,
						League,
						Division,
						[Location],
						Nickname,
						AlternateNicknames,
						FirstGameDate,
						LastGameDate,
						City,
						[State]
						)
			SELECT		CurrentFranchiseCode,
						ActualFranchiseCode,
						League,
						Division,
						[Location],
						Nickname,
						AlternateNicknames,
						FirstGameDate,
						LastGameDate,
						City,
						[State]
			FROM		DW.DimTeamStaging TS
			WHERE		NOT EXISTS (SELECT 1 FROM DW.DimTeam T WHERE TS.CurrentFranchiseCode = T.CurrentFranchiseCode AND TS.ActualFranchiseCode = T.ActualFranchiseCode AND TS.FirstGameDate = T.FirstGameDate);

			-- Drop staging table in DW
			DROP TABLE	DW.DimTeamStaging;

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END