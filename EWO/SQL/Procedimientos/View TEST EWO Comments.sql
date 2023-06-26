SELECT
	C.EwoRequest__u 'Document',
	C.Comment__u 'Comment',
	C.CommentedBy__u 'Commented By',
	CONVERT(VARCHAR(20), CONVERT(DATETIME, C.CommentedOn__u), 101) + ' ' + CONVERT(VARCHAR(20), CONVERT(DATETIME, C.CommentedOn__u), 108) 'Commented On',
	CONVERT(DATETIME, C.CommentedOn__u) 'Commented On Hdn'
FROM GBLComment__u C
WHERE C.EwoRequest__u IS NOT NULL