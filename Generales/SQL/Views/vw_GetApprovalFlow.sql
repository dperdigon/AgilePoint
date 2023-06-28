SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



/* ================================================================================================================================
Name: dbo.vw_GetApprovalFlow
Description: Get Info Approval Flow from tables WF_MANUAL_WORKITEMS and WF_REG_USERS
Params:
Name				Description


Author: Nemak Team
*****************************************************
Change log
Date			Author						Comments
2019/10/30		Gustavo Alemán Zapata		View creation
2019/10/31		Gustavo Alemán Zapata		Update to get Display_Name from table WF_ACTIVITY_INSTS
2019/12/09		Gustavo Alemán Zapata		Change Left join to WF_REG_USERS, use USER_NAME instead of EMAIL_ADDRESS, and get ASSIGNED_DATE instead of CREATED_DATE
2020/02/06		Gustavo Alemán Zapata		Add left join to TRAGeneralInformation__u tra and TRAGeneralInformation__u ruOriginal, to use full_Name and set like OnBehalf of
2023/06/27		David Perdigón García  		Separate [Task] and [Role] fields
================================================================================================================================ */
ALTER VIEW [dbo].[vw_GetApprovalFlow]
AS

SELECT	
    [Task]              = AI.DISPLAY_NAME,
    [User]              = CASE WHEN TRA.ProcessID__u IS NOT NULL AND MW.USER_ID <> MW.ORIGINAL_USER_ID THEN
                            ISNULL(RU.FULL_NAME, '') + ' on behalf of ' + ISNULL(RUO.FULL_NAME, '')
                        ELSE
                            ISNULL(RU.FULL_NAME, '')
                        END,
    [Email]             = RU.USER_NAME,
    [Role]              = RU.TITLE,
    [Status]            = MW.STATUS,
    [PROC_INST_ID]      = MW.PROC_INST_ID,
    [CREATED_DATE]      = MW.ASSIGNED_DATE,
    [COMPLETED_DATE]    = ISNULL(CONVERT(VARCHAR(20), MW.COMPLETED_DATE, 101) + ' ' + CONVERT(VARCHAR(20), MW.COMPLETED_DATE, 108), CONVERT(VARCHAR(20), MW.CANCELLED_DATE, 101) + ' ' + CONVERT(VARCHAR(20), MW.CANCELLED_DATE, 108))
FROM		dbo.vw_WF_MANUAL_WORKITEMS MW
LEFT JOIN	dbo.vw_WF_REG_USERS RU ON MW.[USER_ID] = RU.USER_NAME
LEFT JOIN	dbo.vw_WF_ACTIVITY_INSTS AI ON AI.ID = MW.ACTIVITY_INST_ID
LEFT JOIN	dbo.vw_WF_REG_USERS RUO ON MW.ORIGINAL_USER_ID = RUO.USER_NAME
LEFT JOIN	AP_Data_Entities_DB.dbo.TRAGeneralInformation__u TRA ON MW.PROC_INST_ID = TRA.ProcessID__u
GO