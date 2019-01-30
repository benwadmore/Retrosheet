CREATE PROCEDURE Staging.Personnel_Read
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		WITH cteDates AS
		(
		SELECT		PersonId,
					LastName,
					FirstName,
					MAX(CASE WHEN PDX.ItemNumber = 3 THEN PDX.Item ELSE NULL END) AS PlayerDebutYear,
					MAX(CASE WHEN PDX.ItemNumber = 1 THEN RIGHT('0' + PDX.Item, 2) ELSE NULL END) AS PlayerDebutMonth,
					MAX(CASE WHEN PDX.ItemNumber = 2 THEN RIGHT('0' + PDX.Item, 2) ELSE NULL END) AS PlayerDebutDay,
					MAX(CASE WHEN MDX.ItemNumber = 3 THEN MDX.Item ELSE NULL END) AS ManagerDebutYear,
					MAX(CASE WHEN MDX.ItemNumber = 1 THEN RIGHT('0' + MDX.Item, 2) ELSE NULL END) AS ManagerDebutMonth,
					MAX(CASE WHEN MDX.ItemNumber = 2 THEN RIGHT('0' + MDX.Item, 2) ELSE NULL END) AS ManagerDebutDay,
					MAX(CASE WHEN CDX.ItemNumber = 3 THEN CDX.Item ELSE NULL END) AS CoachDebutYear,
					MAX(CASE WHEN CDX.ItemNumber = 1 THEN RIGHT('0' + CDX.Item, 2) ELSE NULL END) AS CoachDebutMonth,
					MAX(CASE WHEN CDX.ItemNumber = 2 THEN RIGHT('0' + CDX.Item, 2) ELSE NULL END) AS CoachDebutDay,
					MAX(CASE WHEN UDX.ItemNumber = 3 THEN UDX.Item ELSE NULL END) AS UmpireDebutYear,
					MAX(CASE WHEN UDX.ItemNumber = 1 THEN RIGHT('0' + UDX.Item, 2) ELSE NULL END) AS UmpireDebutMonth,
					MAX(CASE WHEN UDX.ItemNumber = 2 THEN RIGHT('0' + UDX.Item, 2) ELSE NULL END) AS UmpireDebutDay
		FROM		Staging.Personnel P
		OUTER APPLY	Utility.DelimitedSplit8K(P.PlayerDebut, '/') PDX
		OUTER APPLY	Utility.DelimitedSplit8K(P.ManagerDebut, '/') MDX
		OUTER APPLY	Utility.DelimitedSplit8K(P.CoachDebut, '/') CDX
		OUTER APPLY	Utility.DelimitedSplit8K(P.UmpireDebut, '/') UDX
		GROUP BY	PersonId,
					LastName,
					FirstName
		)

		SELECT		PersonId,
					LastName,
					FirstName,
					CASE WHEN PlayerDebutYear IS NOT NULL THEN CAST(PlayerDebutYear + PlayerDebutMonth + PlayerDebutDay AS DATE) ELSE NULL END AS PlayerDebutDate,
					CASE WHEN ManagerDebutYear IS NOT NULL THEN CAST(ManagerDebutYear + ManagerDebutMonth + ManagerDebutDay AS DATE) ELSE NULL END AS ManagerDebutDate,
					CASE WHEN CoachDebutYear IS NOT NULL THEN CAST(CoachDebutYear + CoachDebutMonth + CoachDebutDay AS DATE) ELSE NULL END AS CoachDebutDate,
					CASE WHEN UmpireDebutYear IS NOT NULL THEN CAST(UmpireDebutYear + UmpireDebutMonth + UmpireDebutDay AS DATE) ELSE NULL END AS UmpireDebutDate
		FROM		cteDates
		ORDER BY	PersonId;

	END TRY

	BEGIN CATCH


	END CATCH

END
