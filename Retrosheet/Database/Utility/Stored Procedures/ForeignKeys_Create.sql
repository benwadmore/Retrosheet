CREATE PROCEDURE Utility.ForeignKeys_Create
AS
BEGIN
	
	SET NOCOUNT ON;
	SET XACT_ABORT ON;
	
	BEGIN TRY

		CREATE TABLE #ForeignKeysToCreate (
			Id INT IDENTITY (1, 1) NOT NULL PRIMARY KEY,
			ForeignKeyDDL NVARCHAR(2000) NOT NULL
		);

		INSERT INTO #ForeignKeysToCreate (ForeignKeyDDL)
		SELECT		'ALTER TABLE ' + FK.ForeignKeyFromSchema + '.' + FK.ForeignKeyFromTable + ' ADD CONSTRAINT FK_' + FK.ForeignKeyFromTable + '_' + FK.ForeignKeyToTable + ' FOREIGN KEY (' + FK.ForeignKeyFromColumn + ') REFERENCES ' + FK.ForeignKeyToSchema + '.' + FK.ForeignKeyToTable + '(' + FK.ForeignKeyToColumn + ');'
		FROM		Utility.ForeignKey FK
		WHERE		NOT EXISTS	(
								SELECT		*
								FROM		sys.foreign_keys SFK
								WHERE		SFK.[name] = ('FK_' + FK.ForeignKeyFromTable + '_' + FK.ForeignKeyToTable)
								);

		DECLARE @Counter INT = 1,
				@MaxCounter INT = (SELECT MAX(Id) FROM #ForeignKeysToCreate),
				@ForeignKeyDDL NVARCHAR(2000);

		BEGIN TRANSACTION;

			WHILE @Counter <= @MaxCounter
			BEGIN

				SELECT		@ForeignKeyDDL = ForeignKeyDDL
				FROM		#ForeignKeysToCreate
				WHERE		Id = @Counter;

				EXEC sp_executesql @ForeignKeyDDL;

				SET @Counter = @Counter + 1;

			END

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END
