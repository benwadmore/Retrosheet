CREATE PROCEDURE DW.DimPosition_Load
AS
BEGIN
	
	SET NOCOUNT ON;
	
	BEGIN TRY

		BEGIN TRANSACTION;
			
			INSERT INTO	DW.DimPosition
						(
						PositionNumber,
						PositionName
						)
			SELECT		PositionNumber,
						PositionName
			FROM		(
						VALUES (1, 'Pitcher'), (2, 'Catcher'), (3, 'First Base'), (4, 'Second Base'), (5, 'Third Base'), 
						(6, 'Shortstop'), (7, 'Left Field'), (8, 'Center Field'), (9, 'Right Field'), (10, 'Designated Hitter')
						) AS P (PositionNumber, PositionName)
			WHERE		NOT EXISTS (SELECT 1 FROM DW.DimPosition DW WHERE P.PositionNumber = DW.PositionNumber AND P.PositionName = DW.PositionName); 

		COMMIT TRANSACTION;

	END TRY

	BEGIN CATCH

		ROLLBACK TRANSACTION;

	END CATCH

END