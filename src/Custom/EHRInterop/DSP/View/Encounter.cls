Class Custom.EHRInterop.DSP.View.Encounter Extends %RegisteredObject
{

ClassMethod GetEncountersByPat(pIncludeWhereByPK As %Boolean) As %String
{
    Set tQueryID = $CLASSNAME()_"||QueryEncounterByPat"
	Set tQueryXData = ##class(%Dictionary.CompiledXData).%OpenId(tQueryID)
	Set tSQL = tQueryXData.Data.Read()
				
	Set:pIncludeWhereByPK tSQL = tSQL_"AND ENC_PK = ? "
	
	Quit tSQL
}

XData QueryEncounterByPat [ MimeType = application/sql ]
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
}

ClassMethod TriggerENCByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Encounter */ "_
				"SELECT "_
				"enc_pk ENTITY_ID, "_
				"enc_pat_fk PATIENT_ID, "_
				"enc_pk ENCOUNTER_ID, "_
				"'PAT,ENC' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(enc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_encounter "_
				"WHERE (1=0 "_
				"OR (enc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr1_dat <= NOW()) "_
				"OR (enc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr2_dat <= NOW()) "_
				"OR (enc_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr3_dat <= NOW()) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "

	Quit tSQL
}

}
