Class Custom.EHRInterop.DSP.View.Diagnosis Extends Custom.EHRInterop.Core.Util.View
{

ClassMethod GetDiagnosesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
	Set tSQL = ..GetXDataQuery($this, "GetDiagnosesByPat")
	Set:pIncludeWhereByEnc tSQL = ..IncludeWhereByEnc(tSQL)
	Set:pIncludeWhereByPK tSQL = ..IncludeWhereByPK(tSQL)

	Quit tSQL
}

ClassMethod TriggerDXGByDate() As %String
{
	Quit ..GetXDataQuery($this, "TriggerDXGByDate")
}

XData GetDiagnosesByPat [ MimeType = application/sql ]
{
	SELECT
		DXG_PK,
		DXG_ENC_FK,
		DXG_PAT_FK,
		DXG_TYP,
		DXG_COD,
		DXG_DSC,
		DXG_DAT,
		DXG_CLI_COD,
		DXG_CLI_CONS_COD,
		DXG_CLI_CONS_DSC,
		DXG_CLI_NAM,
		DXG_DAT,
		DXG_STA,
		DXG_TYP_COD,
		DXG_TYP_DSC,
		DXG_PRI,
		DXG_ADM,
		DXG_DCH,
		ENC_FAC_COD,
		ENC_FAC_DSC
	FROM HS_DIAGNOSIS
	LEFT JOIN HS_ENCOUNTER E ON E.ENC_PK = DXG_ENC_FK
	WHERE DXG_PAT_FK = ?
	/** AND DXG_ENC_FK = ? **/
	/*** AND DXG_PK = ? ***/
}

XData TriggerDXGByDate [ MimeType = application/sql ]
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
			/* Diagnosis */
			SELECT
				DXG_PK ENTITY_ID,
				DXG_PAT_FK PATIENT_ID,
				DXG_ENC_FK ENCOUNTER_ID,
				'PAT,ENC,DXG' ENTITY_TYPE,
				LEAST(NOW(), GREATEST(
					NVL(DXG_TR1_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(DXG_TR2_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(DXG_TR3_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS'))
				)) ENTITY_DATE
			FROM HS_DIAGNOSIS
			WHERE (1=0
				OR (DXG_TR1_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND DXG_TR1_DAT <= NOW())
				OR (DXG_TR2_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND DXG_TR2_DAT <= NOW())
				OR (DXG_TR3_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND DXG_TR3_DAT <= NOW())
			)
		)
		ORDER BY ENTITY_DATE
	)
}

}
