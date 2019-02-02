CREATE TABLE DW.DimBallPark
(
	BallParkId INT IDENTITY(1, 1) NOT NULL,
	BallParkCode VARCHAR(5) NOT NULL,
	BallParkName VARCHAR(50) NULL,
	BallParkAlsoKnownAs VARCHAR(50) NULL,
	BallParkCity VARCHAR(50) NULL,
	BallParkState VARCHAR(50) NULL,
	BallParkStartDate DATE NULL,
	BallParkEndDate DATE NULL,
	DateTimeCreated	DATETIME NOT NULL CONSTRAINT DF_DimBallPark_DateTimeCreated DEFAULT GETDATE(),
	DateTimeUpdated	DATETIME NOT NULL CONSTRAINT DF_DimBallPark_DateTimeUpdated DEFAULT GETDATE(),
	CONSTRAINT PK_DimBallPark PRIMARY KEY CLUSTERED (BallParkId)
);
GO

CREATE TRIGGER DW.DimBallParkUpdate ON DW.DimBallPark
AFTER UPDATE  
AS 
BEGIN

	-- Make sure that the trigger only fires if one of the main columns is updated, not just if the updated date is changed
	-- Otherwise the trigger will endlessly loop
	IF	UPDATE(BallParkCode) OR UPDATE(BallParkName) OR UPDATE(BallParkAlsoKnownAs) OR UPDATE(BallParkCity) OR 
		UPDATE(BallParkState) OR UPDATE(BallParkStartDate) OR UPDATE(BallParkEndDate)
	
		-- Change "updated" date time for any rows that have materially changed
		UPDATE		BP
		SET			DateTimeUpdated = GETDATE()
		FROM		DW.DimBallPark BP
		WHERE		EXISTS	(
							SELECT		1
							FROM		inserted I
							JOIN		deleted D ON I.BallParkId = D.BallParkId
							WHERE		(
										I.BallParkCode <> D.BallParkCode OR
										I.BallParkName <> D.BallParkName OR 
										I.BallParkAlsoKnownAs <> D.BallParkAlsoKnownAs OR
										I.BallParkCity <> D.BallParkCity OR
										I.BallParkState <> D.BallParkStartDate OR
										I.BallParkEndDate <> D.BallParkEndDate
										)
							AND			I.BallParkId = BP.BallParkId
							);

END 
GO  
