Class Custom.EHRInterop.DSP.View.Procedure Extends Custom.EHRInterop.Core.Util.View
{

ClassMethod GetProceduresByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
  	Set tSQL = ..GetQuery($this, "GetProceduresByPat")
	Set:pIncludeWhereByEnc tSQL = ..IncludeWhereByEnc(tSQL)
	Set:pIncludeWhereByPK tSQL = ..IncludeWhereByPK(tSQL)
	
	Quit tSQL
}

ClassMethod TriggerPRCByDate() As %String
{
	Quit ..GetQuery($this, "TriggerPRCByDate")
}

XData GetProceduresByPat [ MimeType = application/sql ]
{
	SELECT
		PRC_PK,
		PRC_ENC_FK,
		PRC_PAT_FK,
		PRC_COD,
		PRC_DSC,
		PRC_TYP_COD,
		PRC_TYP_DSC,
		PRC_DAT,
		PRC_CLI_COD,
		PRC_CLI_CONS_COD,
		PRC_CLI_CONS_DSC,
		PRC_CLI_NAM,
		ENC_FAC_COD,
		ENC_FAC_DSC
	FROM HS_PROCEDURE
	LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = PRC_ENC_FK
	WHERE PRC_PAT_FK = ?
	/*& --AND PRC_ENC_FK = ? &*/
	/*% --AND PRC_PK = ? %*/
}

XData TriggerPRCByDate [ MimeType = application/sql ]
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
			/* Procedure */
			SELECT
				PRC_PK ENTITY_ID,
				PRC_PAT_FK PATIENT_ID,
				PRC_ENC_FK ENCOUNTER_ID,
				'PAT,ENC,PRC' ENTITY_TYPE,
				LEAST(NOW(), GREATEST(
					NVL(PRC_TR1_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(PRC_TR2_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS'))
				)) ENTITY_DATE
			FROM (
				SELECT PRC_PK, PRC_PAT_FK, PRC_ENC_FK , PRC_TR1_DAT, PRC_TR2_DAT FROM HS_PROCEDURE WHERE PRC_TR1_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND PRC_TR1_DAT <= NOW()
				UNION
				SELECT PRC_PK, PRC_PAT_FK, PRC_ENC_FK , PRC_TR1_DAT, PRC_TR2_DAT FROM HS_PROCEDURE WHERE PRC_TR2_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND PRC_TR2_DAT <= NOW()
			)
		)
		ORDER BY ENTITY_DATE
	)
}

}
