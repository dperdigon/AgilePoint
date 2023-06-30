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
	B.PROC_INST_NAME 'Title',
	A.RequestorName__u 'Requestor',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, B.STARTED_DATE), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, B.STARTED_DATE), 108) 'Request Creation Date',
	B.DISPLAY_NAME AS 'Task',
	B.FULL_NAME 'Approver',
	B.EMAIL_ADDRESS,
	B.TaskLevel,
	CASE
		WHEN B.TaskLevel = 'Requestor' AND B.STATUS = 'Completed' THEN 'Send'
		WHEN B.TaskLevel = 'Requestor' AND B.STATUS = 'Cancelled' THEN 'Exit'
		WHEN B.TaskLevel = 'Manager' AND B.STATUS = 'Completed' AND B2.DISPLAY_NAME = 'Engineer' THEN 'Approve'
		WHEN B.TaskLevel = 'Manager' AND B.STATUS = 'Completed' AND B2.DISPLAY_NAME = 'Requestor' THEN 'Return form to requestor'
		WHEN B.TaskLevel = 'Manager' AND B.STATUS = 'Cancelled' THEN 'Reject'
		WHEN B.TaskLevel = 'Engineer' AND B.STATUS = 'Completed' AND B2.DISPLAY_NAME = 'Requestor' THEN 'Approve'
		WHEN B.TaskLevel = 'Engineer' AND B.STATUS = 'Completed' AND B2.DISPLAY_NAME = 'Manager' THEN 'Reject'
		WHEN B.TaskLevel = 'Approver' AND B.STATUS = 'Completed' AND B2.DISPLAY_NAME IS NULL THEN 'Approve'
		WHEN B.TaskLevel = 'Approver' AND B.STATUS = 'Completed' AND B2.DISPLAY_NAME = 'Engineer' THEN 'Reject'
		WHEN B2.DISPLAY_NAME IS NULL AND IIF(B.STATUS = 'Overdue', 'Assigned', IIF(B.STATUS = 'New', 'Assigned', B.STATUS)) = 'Assigned' THEN 'In Progress'
		WHEN B2.DISPLAY_NAME IS NULL AND B.STATUS = 'Cancelled' THEN 'WF APP'
		ELSE ''
	END 'Button Pressed',
	B.STATUS,
	CONVERT(VARCHAR(20), CONVERT(DATETIME, B.ASSIGNED_DATE), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, B.ASSIGNED_DATE), 108) 'Date And Time',
	CONVERT(DATETIME, B.STARTED_DATE) 'Request Creation Date Hidden',
	A.ProcessID__u
FROM EWOFormData__u A
LEFT JOIN vw_TasksWithOrderForEwo B ON B.PROC_INST_ID = A.ProcessID__u
LEFT JOIN vw_TasksWithOrderForEwo B2 ON B2.PROC_INST_ID = A.ProcessID__u AND B2.TaskNum = (B.TaskNum + 1)
LEFT JOIN GBLComment__u C ON C.EwoRequest__u = A.DocumentID__u AND LOWER(C.CREATED_BY) = LOWER(B.EMAIL_ADDRESS)
WHERE B.[STATUS] <> 'Removed'
