SELECT TOP 1000
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
	B.PROC_INST_NAME 'Title',
	A.RequestorName__u 'Requestor',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, B.STARTED_DATE), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, B.STARTED_DATE), 108) 'Request Creation Date',
	B.DISPLAY_NAME AS 'Task',
	B.FULL_NAME 'Approver',
	B.EMAIL_ADDRESS,
	A.StatusName__u 'Status Name',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, B.ASSIGNED_DATE), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, B.ASSIGNED_DATE), 108) 'Date And Time',
	CONVERT(DATETIME, B.STARTED_DATE) 'Request Creation Date Hidden',
	(
		CASE 
			WHEN B.STATUS = 'Overdue' THEN 'Assigned' 
			ELSE B.STATUS 
		END
	) 'Approver Status',
	CASE
		WHEN B.DISPLAY_NAME = 'Requestor' AND B.STATUS = 'Cancelled' THEN 'Requestor cancellation (withdrawal)'
		WHEN B.DISPLAY_NAME = 'Approval Managers' AND B2.DISPLAY_NAME = 'Requestor' THEN 'Manager returns to requestor (reject)'
		WHEN B.DISPLAY_NAME = 'Approval Managers' AND B.STATUS = 'Cancelled' THEN 'Manager rejection of EWO (cancel)'
		WHEN B.DISPLAY_NAME = 'Engineering Responsible' AND B2.DISPLAY_NAME = 'Approval Managers' THEN 'Engineer returns to manager (return)'
		WHEN B.DISPLAY_NAME = 'Engineering Responsible' AND B.STATUS = 'Cancelled' THEN 'Engineer rejection of EWO (cancel)'
		WHEN B.DISPLAY_NAME = 'Review' AND B2.DISPLAY_NAME = 'Engineering Responsible' THEN 'Approver returns to engineer (rework)'
		WHEN B.DISPLAY_NAME = 'Review' AND B.STATUS = 'Cancelled' THEN 'Approver rejection of EWO (cancel)'
		ELSE ''
	END 'Status',
	A.ProcessID__u
FROM EWOFormData__u A
LEFT JOIN vw_TasksWithOrderForEwo B ON B.PROC_INST_ID = A.ProcessID__u
LEFT JOIN vw_TasksWithOrderForEwo B2 ON B2.PROC_INST_ID = A.ProcessID__u AND B2.TaskNum = (B.TaskNum + 1)
LEFT JOIN GBLComment__u C ON C.EwoRequest__u = A.DocumentID__u AND LOWER(C.CREATED_BY) = LOWER(B.EMAIL_ADDRESS)
ORDER BY B.ASSIGNED_DATE DESC