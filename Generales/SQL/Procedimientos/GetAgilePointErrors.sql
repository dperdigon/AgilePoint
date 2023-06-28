
DROP PROCEDURE [dbo].[GetAgilePointErrors]
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAgilePointErrors]
	-- Add the parameters for the stored procedure here
	@AppName nvarchar(100),
	@WorkFlowID int,
	@res nvarchar(1000) OUTPUT
	AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

declare @errormessage nvarchar(50);
declare @value1 nvarchar(12);
declare @value2 nvarchar(10);
declare @value3 nvarchar(10);

declare errorlog_cursor CURSOR FOR
SELECT ErrorMessage__u, Value1__u, Value2__u, Value3__u
FROM [AP_Data_Entities_DB].[dbo].[AgilePointErrorLogs__u]
WHERE Application__u = @AppName AND WorkFlowID__u = @WorkFlowID

OPEN errorlog_cursor 

FETCH NEXT FROM errorlog_cursor INTO @errorMessage,@value1,@value2,@value3
SET @res='';
WHILE @@FETCH_STATUS = 0
BEGIN
	SET @res = @res + LEFT(@errormessage + SPACE(50),50) + ':' + LEFT(@value1 + SPACE(12),12) + ':' + @value2 + ':' + @value3 + Char(13)
	FETCH NEXT FROM errorlog_cursor INTO @errorMessage,@value1,@value2,@value3
END
CLOSE errorlog_cursor;
DEALLOCATE errorlog_cursor;


END
GO