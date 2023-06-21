SELECT 
	CAST(A.DocumentID__u AS VARCHAR) 'DocumentID',		
	A.DocumentID__u 'Document',
	A.ProjectDescription__u 'Project Description',
	A.PartNumber__u 'Part Number',
	A.WorkID__u 'Work ID',
	A.WorkName__u 'Work Name',
	A.WorkDescription__u 'Work Description',
	CONVERT(VARCHAR(20), A.CompletedBy__u, 120) 'Completed By',
	A.EngineerID__u 'Engineer',
	A.EngineerName__u 'Engineer Name',
	CONVERT(VARCHAR(20), A.PromisedDate__u, 120) 'Promised Date',
	E.PROC_INST_NAME 'Title',
	A.RequestorName__u 'Requestor',
	CONVERT(VARCHAR(20), E.STARTED_DATE, 120) 'Request Creation Date',
	D.FULL_NAME 'Approver',
	A.StatusName__u 'Status Name',
	CONVERT(VARCHAR(20), B.ASSIGNED_DATE, 120) 'Date And Time',
	(
		SELECT CAST(C.CREATED_DATE AS VARCHAR(30)) + ' ' + REPLACE(C.Comments__u, CHAR(10),'') + CHAR(10)
		FROM GBLHistory__u C
		WHERE C.DocumentID__u = A.DocumentID__u 
		AND C.ApplicationID__u = A.ApplicationID__u 
		AND C.UserName__u = B.USER_ID
		FOR XML PATH('')
	) 'Comments',
	CONVERT(VARCHAR(20), E.STARTED_DATE, 120) 'Request Creation Date Hidden',
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
		WHERE C.DocumentID__u = A.DocumentID__u 
		AND C.ApplicationID__u = A.ApplicationID__u 
		AND C.UserName__u = B.USER_ID
		FOR XML PATH('')
	) 'DateComments',
	CONVERT(VARCHAR(20), B.COMPLETED_DATE, 120) 'Task End Date',
	ISNULL(A.EMCC1__u, 0.0000) 'EMCC1',
	ISNULL(A.EMCC2__u, 0.0000) 'EMCC2',
	ISNULL(A.EMCC3__u, 0.0000) 'EMCC3',
	ISNULL(A.EMCC4__u, 0.0000) 'EMCC4',
	ISNULL(A.EMCC5__u, 0.0000) 'EMCC5',
	ISNULL(A.EMCC6__u, 0.0000) 'EMCC6',
	ISNULL(A.EMCC7__u, 0.0000) 'EMCC7',
	ISNULL(A.EMCC8__u, 0.0000) 'EMCC8',
	ISNULL(A.EMCC9__u, 0.0000) 'EMCC9',
	ISNULL(A.EMCC10__u, 0.0000) 'EMCC10',
	ISNULL(A.EMCC11__u, 0.0000) 'EMCC11',
	ISNULL(A.EMCC12__u, 0.0000) 'EMCC12',
	ISNULL(A.EMCC13__u, 0.0000) 'EMCC13',
	ISNULL(A.EMCC14__u, 0.0000) 'EMCC14',
	ISNULL(A.EMCC15__u, 0.0000) 'EMCC15',
	ISNULL(A.EMCC16__u, 0.0000) 'EMCC16',
	ISNULL(A.EMCC17__u, 0.0000) 'EMCC17',
	ISNULL(A.EMCC18__u, 0.0000) 'EMCC18',
	ISNULL(A.EMCC19__u, 0.0000) 'EMCC19',
	ISNULL(A.EMCC20__u, 0.0000) 'EMCC20'
FROM EWOFormData__u A
INNER JOIN [APDB].[dbo].WF_MANUAL_WORKITEMS B ON B.PROC_INST_ID = A.ProcessID__u
LEFT JOIN APDB.dbo.WF_REG_USERS D ON B.[USER_ID] = D.USER_NAME
INNER JOIN APDB.dbo.WF_PROC_INSTS E ON E.PROC_INST_ID = A.ProcessID__u 
WHERE B.[Status] <> 'Cancelled'
AND DocumentID__u = 14464