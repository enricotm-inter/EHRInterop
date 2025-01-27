Class Custom.EHRInterop.DSP.View.Observation Extends Custom.EHRInterop.Core.Util.View
{

ClassMethod GetObservationsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL = ..GetQuery($this, "GetObservationsByPat")
	Set:pIncludeWhereByEnc tSQL = ..IncludeWhereByEnc(tSQL)
	Set:pIncludeWhereByPK tSQL = ..IncludeWhereByPK(tSQL)
	
	Quit tSQL
}

ClassMethod TriggerOBSByDate() As %String
{
	Quit ..GetQuery($this, "TriggerOBSByDate")
}

XData GetObservationsByPat [ MimeType = application/sql ]
{
		SELECT
		OBS_PK,
		OBS_PAT_FK,
		OBS_ENC_FK,
		OBS_CLI_COD,
		OBS_CLI_CONS_COD,
		OBS_CLI_CONS_DSC,
		OBS_CLI_NAM,
		OBS_COD,
		OBS_DSC,
		OBS_VAL,
		OBS_UNT_COD,
		OBS_UNT_DSC,
		OBS_STA,
		OBS_DAT,
		ENC_FAC_COD,
		ENC_FAC_DSC
	FROM HS_OBSERVATION
	LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = OBS_ENC_FK
	WHERE OBS_PAT_FK = ?
	/*& --AND OBS_ENC_FK = ? &*/
	/*% --AND OBS_PK = ? %*/
}

XData TriggerOBSByDate [ MimeType = application/sql ]
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
			/* Observation */
			SELECT
				OBS_PK ENTITY_ID,
				OBS_PAT_FK PATIENT_ID,
				OBS_ENC_FK ENCOUNTER_ID,
				'PAT,ENC,OBS' ENTITY_TYPE,
				LEAST(NOW(), GREATEST(
					NVL(OBS_TR1_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(OBS_TR2_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(OBS_TR3_DAT, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS'))
				)) ENTITY_DATE
			FROM HS_OBSERVATION
			WHERE (1=0
				OR (OBS_TR1_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND OBS_TR1_DAT <= NOW())
				OR (OBS_TR2_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND OBS_TR2_DAT <= NOW())
				OR (OBS_TR3_DAT > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND OBS_TR3_DAT <= NOW())
			)
		)
		ORDER BY ENTITY_DATE
	)
}

}
