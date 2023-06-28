
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
    @TitleValue1 NVARCHAR(100) NULL,
    @TitleValue2 NVARCHAR(100) NULL,
    @TitleValue3 NVARCHAR(100) NULL,
    @TitleValue4 NVARCHAR(100) NULL,
	@res NVARCHAR(1024) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @errormessage NVARCHAR(50);
    DECLARE @value1 NVARCHAR(100);
    DECLARE @value2 NVARCHAR(100);
    DECLARE @value3 NVARCHAR(100);
    DECLARE @value4 NVARCHAR(100);

    DECLARE errorlog_cursor CURSOR FOR
    SELECT 
        ErrorMessage__u, 
        Value1__u, 
        Value2__u, 
        Value3__u,
        Value4__u
    FROM [dbo].[AgilePointErrorLogs__u]
    WHERE Application__u = @AppName 
    AND WorkFlowID__u = @WorkFlowID

    SET @res = '';
    SET @res = @res + '<table style="width: 100%;border-collapse: collapse;">';
    SET @res = @res + '     <thead>';
    SET @res = @res + '         <tr>';

    IF ISNULL(@TitleValue1, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue1 + '</th>';
    END

    IF ISNULL(@TitleValue2, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue2 + '</th>';
    END

    IF ISNULL(@TitleValue3, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue3 + '</th>';
    END
    
    IF ISNULL(@TitleValue4, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue4 + '</th>';
    END

    SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">Mensaje</th>';
    SET @res = @res + '         </tr>';
    SET @res = @res + '     </thead>';
    SET @res = @res + '     <tbody>';
    
    OPEN errorlog_cursor 
    FETCH NEXT FROM errorlog_cursor INTO @errorMessage, @value1, @value2, @value3, @value4
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @res = @res + '     <tr>';

        IF ISNULL(@TitleValue1, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value1 + '</td>';
        END

        IF ISNULL(@TitleValue2, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value2 + '</td>';
        END

        IF ISNULL(@TitleValue3, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value3 + '</td>';
        END

        IF ISNULL(@TitleValue4, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value4 + '</td>';
        END

        SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' + @errormessage + '</td>';
        SET @res = @res + '     </tr>';

        FETCH NEXT FROM errorlog_cursor INTO @errorMessage, @value1, @value2, @value3, @value4
    END
    CLOSE errorlog_cursor;
    DEALLOCATE errorlog_cursor;
    SET @res = @res + '     </tbody>';
    SET @res = @res + '</table>';
END
GO