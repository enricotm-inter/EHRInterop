Class Custom.EHRInterop.DSP.View.Encounter Extends Custom.EHRInterop.Core.Util.View
{

ClassMethod GetEncountersByPat(pIncludeWhereByPK As %Boolean) As %String
{
   	Set tSQL = ..GetXDataQuery($this, "GetEncountersByPat")
	Set:pIncludeWhereByPK tSQL = ..IncludeWhereByPK(tSQL)
	
	Quit tSQL
}

ClassMethod TriggerENCByDate() As %String
{
	Quit ..GetXDataQuery($this, "TriggerENCByDate")
}

XData GetEncountersByPat [ MimeType = application/sql ]
{
	SELECT
		ENC_PK,
		ENC_PAT_FK,
		ENC_ADM_DAT,
		ENC_TYP,
		ENC_FAC_COD,
		ENC_FAC_DSC,
		ENC_INS_COD,
		ENC_INS_DSC,
		ENC_SPE_COD,
		ENC_SPE_DSC,
		ENC_DIS_DAT,
		ENC_WRD,
		ENC_BED,
		ENC_CLI_COD,
		ENC_CLI_CONS_COD,
		ENC_CLI_CONS_DSC,
		ENC_CLI_NAM
	FROM HS_ENCOUNTER
	WHERE ENC_PAT_FK = ?
	/*% --AND ENC_PK = ? %*/
}

XData TriggerENCByDate [ MimeType = application/sql ]
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
			/* Encounter */
			SELECT
				ENC_PK ENTITY_ID,
				ENC_PAT_FK PATIENT_ID,
				ENC_PK ENCOUNTER_ID,
				'PAT,ENC' ENTITY_TYPE,
				LEAST(NOW(), GREATEST(
					NVL(ENC_TR1_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(ENC_TR2_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(ENC_TR3_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS'))
				)) ENTITY_DATE
			FROM HS_ENCOUNTER
			WHERE (1=0
				OR (ENC_TR1_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr1_dat <= NOW())
				OR (ENC_TR2_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr2_dat <= NOW())
				OR (ENC_TR3_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr3_dat <= NOW())
			)
		)
		ORDER BY ENTITY_DATE
	)
}

}
