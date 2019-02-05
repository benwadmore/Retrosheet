CREATE PROCEDURE Staging.Franchise_Read
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		WITH cteDates AS
		(
		SELECT		CurrentFranchiseId,
					ActualFranchiseId,
					League,
					Division,
					[Location],
					Nickname,
					AlternateNicknames,
					FirstGameDate,
					LastGameDate,
					City,
					[State],
					MAX(CASE WHEN FGX.ItemNumber = 3 THEN FGX.Item ELSE NULL END) AS FirstGameYear,
					MAX(CASE WHEN FGX.ItemNumber = 1 THEN RIGHT('0' + FGX.Item, 2) ELSE NULL END) AS FirstGameMonth,
					MAX(CASE WHEN FGX.ItemNumber = 2 THEN RIGHT('0' + FGX.Item, 2) ELSE NULL END) AS FirstGameDay,
					MAX(CASE WHEN LGX.ItemNumber = 3 THEN LGX.Item ELSE NULL END) AS LastGameYear,
					MAX(CASE WHEN LGX.ItemNumber = 1 THEN RIGHT('0' + LGX.Item, 2) ELSE NULL END) AS LastGameMonth,
					MAX(CASE WHEN LGX.ItemNumber = 2 THEN RIGHT('0' + LGX.Item, 2) ELSE NULL END) AS LastGameDay
		FROM		Staging.Franchise F
		OUTER APPLY	Utility.DelimitedSplit8K(F.FirstGameDate, '/') FGX
		OUTER APPLY	Utility.DelimitedSplit8K(F.LastGameDate, '/') LGX
		GROUP BY	CurrentFranchiseId,
					ActualFranchiseId,
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

		SELECT		CurrentFranchiseId,
					ActualFranchiseId,
					League,
					Division,
					[Location],
					Nickname,
					AlternateNicknames,
					City,
					[State],
					CASE WHEN FirstGameYear IS NOT NULL THEN CAST(FirstGameYear + FirstGameMonth + FirstGameDay AS DATE) ELSE NULL END AS FirstGameDate,
					CASE WHEN LastGameYear IS NOT NULL THEN CAST(LastGameYear + LastGameMonth + LastGameDay AS DATE) ELSE NULL END AS LastGameDate
		FROM		cteDates
		ORDER BY	CurrentFranchiseId,
					FirstGameDate,
					LastGameDate;

	END TRY

	BEGIN CATCH


	END CATCH

END
