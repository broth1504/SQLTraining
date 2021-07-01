PRINT 'DB Instance: ' + @@SERVERNAME
PRINT 'Timestamp:   ' + CONVERT(VARCHAR, GETDATE())
PRINT 'User:		' + SUSER_NAME()
PRINT 'Workitem 880151'

USE [Premdat]
GO

if not exists (select* from [Premdat].[dbo].[CyberCompDefaultCarriers] where State = 'IN' and AgencyGroup = '' and DateEff = '2015-01-01 00:00:00')
	BEgin
		PRint 'workitem 880151 - script was bypassed'
	End
Else

	Begin
		Begin Transaction

		BEGIN TRY
			DECLARE @MustRollBack BIT = 0;

			UPDATE [Premdat].[dbo].[CyberCompDefaultCarriers]
			SET DateExp = '8/31/2021 00:00:00'
			WHERE State = 'IN'
			AND AgencyGroup = ''
			AND DateEff = '2015-01-01 00:00:00'

			IF @@ROWCOUNT <> 1
				SET @MustRollBack = 1;

			INSERT INTO [Premdat].[dbo].[CyberCompDefaultCarriers] (State, Carrier, Tier1, Tier2, Tier3, DateEff, DateExp, Note, AgencyGroup, Tier4, Tier5, TerritoryName, UwTierRestriction)
			VALUES ('IN', NULL, 38, 7, 1, '9/1/2021', NULL, '9/1/2021 B.Roth Updating tiers for IN', '', NULL, NULL, '', NULL);

			IF @@ROWCOUNT <> 1
				SET @MustRollBack = 1;

			IF @MustRollBack = 1
				BEGIN
					ROLLBACK TRANSACTION;
					PRINT 'failure - ROLLBACK - unexpected row count';
				END
			ELSE
				BEGIN
					COMMIT TRANSACTION;
					PRINT 'success - COMMIT';
				END
		END TRY
		BEGIN CATCH
			IF (@@TRANCOUNT > 0)
				ROLLBACK TRANSACTION;
			DECLARE @ErrorMessage NVARCHAR(MAX);
			SELECT @ErrorMessage = @@SERVERNAME +
					' - error - ROLLBACK ' +
					ERROR_MESSAGE() +
					' :: Number ' +
					CONVERT(VARCHAR(50), ERROR_NUMBER()) +
					', Severity ' +
					CONVERT(VARCHAR(5), ERROR_SEVERITY()) +
					', State ' +
					CONVERT(VARCHAR(5), ERROR_STATE()) +
					', Line ' +
					CONVERT(VARCHAR(5), ERROR_LINE());
			PRINT @ErrorMessage;
		END CATCH
	End