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
================================================================================================================================ */
CREATE VIEW [dbo].[vw_GetApprovalFlow]
AS

select		case when tra.ProcessID__u is not null and mw.USER_ID <> mw.ORIGINAL_USER_ID then
				isNull(ru.FULL_NAME, '') + ' on behalf of ' + isNull(ruOriginal.FULL_NAME, '')
			else
				isNull(ru.FULL_NAME, '')
			end [User]
			,ai.DISPLAY_NAME as [Role]
			,mw.[STATUS] as [Status]
			,mw.PROC_INST_ID
			,mw.ASSIGNED_DATE CREATED_DATE

from		dbo.vw_WF_MANUAL_WORKITEMS mw
left join	dbo.vw_WF_REG_USERS ru on mw.[USER_ID] = ru.USER_NAME
left join	dbo.vw_WF_ACTIVITY_INSTS ai on ai.ID = mw.ACTIVITY_INST_ID
left JOIN	dbo.vw_WF_REG_USERS ruOriginal on mw.ORIGINAL_USER_ID = ruOriginal.USER_NAME
left join	UAT_AP_DataEntities_DB.dbo.TRAGeneralInformation__u tra on mw.PROC_INST_ID = tra.ProcessID__u
GO