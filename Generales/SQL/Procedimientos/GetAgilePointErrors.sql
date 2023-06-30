DROP PROCEDURE [dbo].[GetAgilePointErrors]
GO
/****** Object:  StoredProcedure [dbo].[GetAgilePointErrors]    Script Date: 30/06/2023 12:38:58 a. m. ******/
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
	@TitleValue5 NVARCHAR(100) NULL,
    @TitleValue6 NVARCHAR(100) NULL,
    @TitleValue7 NVARCHAR(100) NULL,
    @TitleValue8 NVARCHAR(100) NULL,
	@TitleValue9 NVARCHAR(100) NULL,
    @TitleValue10 NVARCHAR(100) NULL,
	@res VARCHAR(MAX) OUTPUT
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @errormessage NVARCHAR(50);
    DECLARE @value1 NVARCHAR(100);
    DECLARE @value2 NVARCHAR(100);
    DECLARE @value3 NVARCHAR(100);
    DECLARE @value4 NVARCHAR(100);
	DECLARE @value5 NVARCHAR(100);
    DECLARE @value6 NVARCHAR(100);
    DECLARE @value7 NVARCHAR(100);
    DECLARE @value8 NVARCHAR(100);
	DECLARE @value9 NVARCHAR(100);
    DECLARE @value10 NVARCHAR(100);

    DECLARE errorlog_cursor CURSOR FOR
    SELECT 
        ErrorMessage__u, 
        Value1__u, 
        Value2__u, 
        Value3__u,
        Value4__u,
		Value5__u, 
        Value6__u, 
        Value7__u,
        Value8__u,
		Value9__u, 
        Value10__u
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
	    
    IF ISNULL(@TitleValue5, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue5 + '</th>';
    END
	    
    IF ISNULL(@TitleValue6, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue6 + '</th>';
    END
	    
    IF ISNULL(@TitleValue7, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue7 + '</th>';
    END
	    
    IF ISNULL(@TitleValue8, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue8 + '</th>';
    END
	    
    IF ISNULL(@TitleValue9, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue9 + '</th>';
    END
	    
    IF ISNULL(@TitleValue10, '') <> '' BEGIN
        SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">' + @TitleValue10 + '</th>';
    END

    SET @res = @res + '             <th style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;color: #96979D;background-color: #F9F9F9;border-top: 3px solid #0072c6 !important;">Mensaje</th>';
    SET @res = @res + '         </tr>';
    SET @res = @res + '     </thead>';
    SET @res = @res + '     <tbody>';
    
    OPEN errorlog_cursor 
    FETCH NEXT FROM errorlog_cursor INTO @errorMessage, @value1, @value2, @value3, @value4, @value5, @value6, @value7, @value8, @value9, @value10
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
		
        IF ISNULL(@TitleValue5, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value5 + '</td>';
        END
		
        IF ISNULL(@TitleValue6, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value6 + '</td>';
        END
		
        IF ISNULL(@TitleValue7, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value7 + '</td>';
        END
		
        IF ISNULL(@TitleValue8, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value8 + '</td>';
        END
		
        IF ISNULL(@TitleValue9, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value9 + '</td>';
        END
		
        IF ISNULL(@TitleValue10, '') <> '' BEGIN
            SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' +  @value10 + '</td>';
        END

        SET @res = @res + '         <td style="padding: 8px;text-align: left;border: 1px solid #DDDDDD;">' + @errormessage + '</td>';
        SET @res = @res + '     </tr>';

        FETCH NEXT FROM errorlog_cursor INTO @errorMessage, @value1, @value2, @value3, @value4, @value5, @value6, @value7, @value8, @value9, @value10
    END
    CLOSE errorlog_cursor;
    DEALLOCATE errorlog_cursor;
    SET @res = @res + '     </tbody>';
    SET @res = @res + '</table>';
END