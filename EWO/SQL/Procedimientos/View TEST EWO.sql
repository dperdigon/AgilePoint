SELECT 
	CAST(A.DocumentID__u AS VARCHAR) 'DocumentID',		
	A.DocumentID__u 'Document',
	A.ProjectDescription__u 'Project Description',
	A.PartNumber__u 'Part Number',
	A.WorkID__u 'Work ID',
	A.WorkName__u 'Work Name',
	A.WorkDescription__u 'Work Description',
	CAST(A.CompletedBy__u AS DATETIME) 'Completed By',
	A.EngineerID__u 'Engineer',
	A.EngineerName__u 'Engineer Name',
	CAST(A.PromisedDate__u AS DATETIME) 'Promised Date',
	E.PROC_INST_NAME 'Title',
	A.RequestorName__u 'Requestor',
	CAST(E.STARTED_DATE AS DATETIME) 'Request Creation Date',
	D.FULL_NAME 'Approver',
	A.StatusName__u 'Status Name',
	(
		SELECT CAST(C.CREATED_DATE AS VARCHAR(30)) + ' ' + REPLACE(C.Comments__u, CHAR(10),'') + CHAR(10)
		FROM GBLHistory__u C
		WHERE C.DocumentID__u = A.DocumentID__u and C.ApplicationID__u = A.ApplicationID__u AND C.UserName__u = B.USER_ID
		FOR XML PATH('')
	) 'Comments',
	CAST(CONVERT(VARCHAR, E.STARTED_DATE, 102) AS DATETIME) 'Request Creation Date Hidden',
	B.ASSIGNED_DATE 'Date And Time',
	(
		CASE 
			WHEN B.[Status] = 'Overdue' THEN 'Assigned' 
			ELSE B.[Status] 
		END
	) 'Approver Status',
	A.ProcessID__u,
	(
		SELECT CAST(MAX(C.CREATED_DATE) AS VARCHAR(30)) 
		FROM GBLHistory__u C
		WHERE C.DocumentID__u = A.DocumentID__u and C.ApplicationID__u = A.ApplicationID__u AND C.UserName__u = B.USER_ID
		FOR XML PATH('')
	) 'DateComments'
FROM EWOFormData__u A
INNER JOIN [APDB].[dbo].WF_MANUAL_WORKITEMS B ON B.PROC_INST_ID = A.ProcessID__u
LEFT JOIN APDB.dbo.WF_REG_USERS D ON B.[USER_ID] = D.USER_NAME
INNER JOIN APDB.dbo.WF_PROC_INSTS E ON E.PROC_INST_ID = A.ProcessID__u 
WHERE B.[Status] <> 'Cancelled'