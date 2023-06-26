SELECT
	CAST(A.DocumentID__u AS VARCHAR) 'DocumentID',		
	A.DocumentID__u 'Document',
	A.ProjectDescription__u 'Project Description',
	A.PartNumber__u 'Part Number',
	A.WorkID__u 'Work ID',
	A.WorkName__u 'Work Name',
	A.WorkDescription__u 'Work Description',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, A.CompletedBy__u), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, A.CompletedBy__u), 108) 'Completed By',
	A.EngineerID__u 'Engineer',
	A.EngineerName__u 'Engineer Name',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, A.PromisedDate__u), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, A.PromisedDate__u), 108) 'Promised Date',
	E.PROC_INST_NAME 'Title',
	A.RequestorName__u 'Requestor',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, E.STARTED_DATE), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, E.STARTED_DATE), 108) 'Request Creation Date',
	CASE
		WHEN B.NAME = 'Start' THEN 'Requestor' 
		WHEN B.NAME = 'ApproveReject1' THEN 'Approval Managers'
		WHEN B.NAME = 'ApproveRejectResponsible' THEN 'Engineering Responsible'
		WHEN B.NAME = 'Review' THEN 'Last Stage'
	END AS 'Task',
	D.FULL_NAME 'Approver',
	D.EMAIL_ADDRESS,
	A.StatusName__u 'Status Name',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, B.ASSIGNED_DATE), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, B.ASSIGNED_DATE), 108) 'Date And Time',
	CONVERT(DATETIME, E.STARTED_DATE) 'Request Creation Date Hidden',
	(
		CASE 
			WHEN B.[Status] = 'Overdue' THEN 'Assigned' 
			ELSE B.[Status] 
		END
	) 'Approver Status',
	A.ProcessID__u
FROM EWOFormData__u A
INNER JOIN [APDB].[dbo].WF_MANUAL_WORKITEMS B ON B.PROC_INST_ID = A.ProcessID__u
LEFT JOIN APDB.dbo.WF_REG_USERS D ON B.[USER_ID] = D.USER_NAME
INNER JOIN APDB.dbo.WF_PROC_INSTS E ON E.PROC_INST_ID = A.ProcessID__u 
LEFT JOIN GBLComment__u C ON C.EwoRequest__u = A.DocumentID__u AND LOWER(C.CREATED_BY) = LOWER(D.EMAIL_ADDRESS)