Class Custom.EHRInterop.DSP.View.Alert Extends %RegisteredObject
{

ClassMethod GetAlertsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL = "SELECT "_
					"ALT_PK, "_
					"ALT_PAT_FK, "_
					"ALT_ENC_FK, "_
					"ALT_TYP_COD, "_
					"ALT_TYP_DSC, "_
					"ALT_COD, "_
					"ALT_DSC, "_
					"ALT_STA, "_
					"ALT_DAT, "_
					"ALT_CLI_COD, "_
					"ALT_CLI_CONS_COD, "_
					"ALT_CLI_CONS_DSC, "_
					"ALT_CLI_NAM, "_
                    "ENC_FAC_COD, "_
					"ENC_FAC_DSC "_
				"FROM hs_alert "_
				"LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = ALT_ENC_FK "_
				"WHERE ALT_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND ALT_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND ALT_PK = ? "
  	
  	Quit tSQL
}

ClassMethod TriggerALTByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE "_
				"FROM ( "_
				"SELECT TOP ? * FROM ( "_
				"/* Alert */ "_
				"SELECT "_
				"alt_pk ENTITY_ID, "_
				"alt_pat_fk PATIENT_ID, "_
				"alt_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,ALT' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(alt_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(alt_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(alt_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_alert WHERE alt_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND alt_tr1_dat <= NOW() AND alt_tr1_fec >= CAST(TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AS DATETIME) AND alt_tr1_fec <= CAST(NOW() AS DATETIME) "_
				"UNION "_
				"SELECT * FROM hs_alert WHERE alt_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND alt_tr2_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_alert WHERE alt_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND alt_tr3_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
