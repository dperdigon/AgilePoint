
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
	@AppName NVARCHAR(100),
	@WorkFlowID INT,
	@res NVARCHAR(1000) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @errormessage NVARCHAR(50);
    DECLARE @value1 NVARCHAR(12);
    DECLARE @value2 NVARCHAR(10);
    DECLARE @value3 NVARCHAR(10);

    DECLARE errorlog_cursor CURSOR FOR
    SELECT 
        ErrorMessage__u, 
        Value1__u, 
        Value2__u, 
        Value3__u
    FROM [dbo].[AgilePointErrorLogs__u]
    WHERE Application__u = @AppName 
    AND WorkFlowID__u = @WorkFlowID

    SET @res = '';
    SET @res = @res + '<table>';
    SET @res = @res + '     <thead>';
    SET @res = @res + '         <tr>';
    SET @res = @res + '             <th>Mensaje</th>';
    SET @res = @res + '             <th>&nbsp;</th>';
    SET @res = @res + '             <th>&nbsp;</th>';
    SET @res = @res + '             <th>&nbsp;</th>';
    SET @res = @res + '         </tr>';
    SET @res = @res + '     </thead>';
    SET @res = @res + '     <tbody>';
    
    OPEN errorlog_cursor 
    FETCH NEXT FROM errorlog_cursor INTO @errorMessage, @value1, @value2, @value3
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @res = @res + '     <tr>';
        SET @res = @res + '         <td>' + @errormessage + '</td>';
        SET @res = @res + '         <td>' +  @value1 + '</td>';
        SET @res = @res + '         <td>' +  @value2 + '</td>';
        SET @res = @res + '         <td>' +  @value3 + '</td>';
        SET @res = @res + '     </tr>';

        FETCH NEXT FROM errorlog_cursor INTO @errorMessage, @value1, @value2, @value3
    END
    CLOSE errorlog_cursor;
    DEALLOCATE errorlog_cursor;
    SET @res = @res + '     </tbody>';
    SET @res = @res + '</table>';
END
GO