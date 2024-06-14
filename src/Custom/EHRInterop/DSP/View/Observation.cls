Class Custom.EHRInterop.DSP.View.Observation Extends %RegisteredObject
{

ClassMethod GetObservationsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"OBS_PK, "_
					"OBS_PAT_FK, "_
					"OBS_ENC_FK, "_
					"OBS_CLI_COD, "_
					"OBS_CLI_CONS_COD, "_
					"BS_CLI_CONS_DSC, "_
					"OBS_CLI_NAM, "_
					"OBS_COD, "_
					"OBS_DSC, "_
					"OBS_VAL, "_
					"OBS_UNT_COD, "_
					"OBS_UNT_DSC, "_
					"OBS_STA, "_
					"OBS_DAT, "_
					"ENC_FAC_COD, "_
					"ENC_FAC_DSC "_
				"FROM hs_observation "_
				"LEFT JOIN hs_encounter enc ON enc.ENC_PK = OBS_ENC_FK "_
				"WHERE OBS_PAT_FK = ? "
				
				
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND OBS_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND OBS_PK = ? "

	Quit tSQL
}

ClassMethod TriggerOBSByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Observation */ "_
				"SELECT "_
				"obs_pk ENTITY_ID, "_
				"obs_pat_fk PATIENT_ID, "_
				"obs_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,OBS' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(obs_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(obs_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(obs_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_observation WHERE obs_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND obs_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_observation WHERE obs_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND obs_tr2_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_observation WHERE obs_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND obs_tr3_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
