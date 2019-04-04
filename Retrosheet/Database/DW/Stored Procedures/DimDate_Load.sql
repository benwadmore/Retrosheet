CREATE PROCEDURE DW.DimDate_Load
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		SET DATEFIRST 1;

		CREATE TABLE #Dates
		(
			DateId DATE NOT NULL,
			DayOfWeekNumber TINYINT NOT NULL,
			DayOfWeekName VARCHAR(10) NOT NULL,
			CalendarWeekName VARCHAR(10) NOT NULL,
			CalendarMonthName VARCHAR(10) NOT NULL,
			CalendarYearName VARCHAR(10) NOT NULL,
			PRIMARY KEY CLUSTERED (DateId)
		);

		WITH	cteTally (n) AS
				(
					-- 100000 rows
					SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1
					FROM (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) a(n)
					CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) b(n)
					CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) c(n)
					CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) d(n)
					CROSS JOIN (VALUES(0),(0),(0),(0),(0),(0),(0),(0),(0),(0)) e(n)
				),
				cteDates (DateId) AS
				(
					SELECT	DATEADD(DAY, n, '18710101')
					FROM	cteTally
				)
			
		INSERT INTO #Dates
					(
					DateId,
					DayOfWeekNumber,
					DayOfWeekName,
					CalendarWeekName,
					CalendarMonthName,
					CalendarYearName
					)
		SELECT		D.DateId,
					DATEPART(WEEKDAY, D.DateId) AS DayOfWeekNumber,
					DATENAME(WEEKDAY, D.DateId) AS DayOfWeekName,
					DATEPART(ISOWK, D.DateId) AS CalendarWeekName,
					DATENAME(MONTH, D.DateId) AS CalendarMonthName,
					DATENAME(YEAR, D.DateId) AS CalendarYearName
		FROM		cteDates D
		WHERE		D.DateId < DATEADD(YEAR, 2, DATEADD(YEAR, DATEDIFF(YEAR, 0, GETDATE()), 0)); -- Limit to end of next year

		BEGIN TRANSACTION;

			UPDATE		DW.DimDate
			SET			DayOfWeekNumber = D.DayOfWeekNumber,
						DayOfWeekName = D.DayOfWeekName,
						CalendarWeekName = D.CalendarWeekName,
						CalendarMonthName = D.CalendarMonthName,
						CalendarYearName = D.CalendarYearName
			FROM		#Dates D
			JOIN		DW.DimDate DW ON D.DateId = DW.DateId;
			
			INSERT INTO DW.DimDate
						(
						DateId,
						DayOfWeekNumber,
						DayOfWeekName,
						CalendarWeekName,
						CalendarMonthName,
						CalendarYearName
						)
			SELECT		D.DateId,
						DATEPART(WEEKDAY, D.DateId) AS DayOfWeekNumber,
						DATENAME(WEEKDAY, D.DateId) AS DayOfWeekName,
						DATEPART(ISOWK, D.DateId) AS CalendarWeekName,
						DATENAME(MONTH, D.DateId) AS CalendarMonthName,
						DATENAME(YEAR, D.DateId) AS CalendarYearName
			FROM		#Dates
			WHERE		NOT EXISTS (SELECT 1 FROM DW.DimDate WHERE D.DateId = DateId);

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END