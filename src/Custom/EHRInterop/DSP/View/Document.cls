Class Custom.EHRInterop.DSP.View.Document Extends Custom.EHRInterop.Core.Util.View
{

ClassMethod GetDocumentsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
	Set tSQL = ..GetQuery($this, "GetDocumentsByPat")
	Set:pIncludeWhereByEnc tSQL = ..IncludeWhereByEnc(tSQL)
	Set:pIncludeWhereByPK tSQL = ..IncludeWhereByPK(tSQL)
	
	Quit tSQL
}

ClassMethod TriggerDOCByDate() As %String
{
	Quit ..GetQuery($this, "TriggerDOCByDate")
}

XData GetDocumentsByPat [ MimeType = application/sql ]
{
	SELECT 
		DOC_PK, 
		DOC_PAT_FK, 
		DOC_ENC_FK, 
		DOC_TYP_COD, 
		DOC_TYP_COD AS DOC_TYP_DSC, 
		DOC_NAM, 
		DOC_DAT, 
		DOC_CLI_COD, 
		DOC_CLI_CONS_COD, 
		DOC_CLI_CONS_DSC, 
		DOC_CLI_NAM, 
		DOC_BDT, 
		DOC_BOD, 
		DOC_STA, 
		ENC_FAC_COD, 
		ENC_FAC_DSC 
	FROM HS_DOCUMENT 
	LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = DOC_ENC_FK 
	WHERE DOC_PAT_FK = ?
	/*& --AND DOC_ENC_FK = ? &*/
	/*% --AND DOC_PK = ? %*/
}

XData TriggerDOCByDate [ MimeType = application/sql ]
{
	SELECT
		TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID,
		ENTITY_ID,
		PATIENT_ID,
		ENCOUNTER_ID,
		ENTITY_TYPE,
		ENTITY_DATE
	FROM (
		SELECT TOP ? * FROM (
			/* Document */
			SELECT
				DOC_PK ENTITY_ID,
				DOC_PAT_FK PATIENT_ID,
				DOC_ENC_FK ENCOUNTER_ID,
				'PAT,ENC,DOC' ENTITY_TYPE,
				LEAST(NOW(), GREATEST(
					NVL(DOC_TR1_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(DOC_TR2_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS'))
				)) ENTITY_DATE
			FROM (
				SELECT DOC_PK, DOC_PAT_FK, DOC_ENC_FK , DOC_TR1_DAT, DOC_TR2_DAT FROM HS_DOCUMENT WHERE DOC_TR1_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND DOC_TR1_DAT <= NOW()
				UNION
				SELECT DOC_PK, DOC_PAT_FK, DOC_ENC_FK , DOC_TR1_DAT, DOC_TR2_DAT FROM HS_DOCUMENT WHERE DOC_TR2_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND DOC_TR2_DAT <= NOW()
			)
		)
		ORDER BY ENTITY_DATE
	)
}

}
