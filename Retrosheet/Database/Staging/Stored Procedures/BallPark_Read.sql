CREATE PROCEDURE Staging.BallPark_Read
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		WITH cteDates AS
		(
		SELECT		ParkId,
					ParkName,
					ParkAka,
					ParkCity,
					ParkState,
					ParkStart,
					ParkEnd,
					MAX(CASE WHEN PSX.ItemNumber = 3 THEN PSX.Item ELSE NULL END) AS ParkStartYear,
					MAX(CASE WHEN PSX.ItemNumber = 1 THEN RIGHT('0' + PSX.Item, 2) ELSE NULL END) AS ParkStartMonth,
					MAX(CASE WHEN PSX.ItemNumber = 2 THEN RIGHT('0' + PSX.Item, 2) ELSE NULL END) AS ParkStartDay,
					MAX(CASE WHEN PEX.ItemNumber = 3 THEN PEX.Item ELSE NULL END) AS ParkEndYear,
					MAX(CASE WHEN PEX.ItemNumber = 1 THEN RIGHT('0' + PEX.Item, 2) ELSE NULL END) AS ParkEndMonth,
					MAX(CASE WHEN PEX.ItemNumber = 2 THEN RIGHT('0' + PEX.Item, 2) ELSE NULL END) AS ParkEndDay
		FROM		Staging.BallPark BP
		OUTER APPLY	Utility.DelimitedSplit8K(BP.ParkStart, '/') PSX
		OUTER APPLY	Utility.DelimitedSplit8K(BP.ParkEnd, '/') PEX
		GROUP BY	ParkId,
					ParkName,
					ParkAka,
					ParkCity,
					ParkState,
					ParkStart,
					ParkEnd
		)

		SELECT		ParkId,
					ParkName,
					ParkAka,
					ParkCity,
					ParkState,
					CASE WHEN ParkStartYear IS NOT NULL THEN CAST(ParkStartYear + ParkStartMonth + ParkStartDay AS DATE) ELSE NULL END AS ParkStartDate,
					CASE WHEN ParkEndYear IS NOT NULL THEN CAST(ParkEndYear + ParkEndMonth + ParkEndDay AS DATE) ELSE NULL END AS ParkEndDate
		FROM		cteDates
		ORDER BY	ParkId;

	END TRY

	BEGIN CATCH


	END CATCH

END
