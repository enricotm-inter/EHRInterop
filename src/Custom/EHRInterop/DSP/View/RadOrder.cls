Class Custom.EHRInterop.DSP.View.RadOrder Extends %RegisteredObject
{

ClassMethod GetRadOrdersByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
	Set tSQL =	"SELECT "_
					"RAD_PK, "_
					"RAD_PID, "_
					"RAD_FID, "_
                    "RAD_PAT_FK, "_
                    "RAD_ENC_FK, "_
                    "RAD_ORD_DAT, "_
                    "RAD_COD, "_
                    "RAD_DSC, "_
                    "RAD_STA, "_
                    "RAD_CLI_COD, "_
                    "RAD_CLI_CONS_COD, "_
                    "RAD_CLI_CONS_DSC, "_
                    "RAD_CLI_NAM, "_
                    "RAD_RES_BDT, "_
                    "RAD_RES_BOD, "_
                    "RAD_RES_NAM, "_
                    "RAD_RES_DAT, "_
                    "ENC_FAC_COD, "_
					"ENC_FAC_DSC "_
				"FROM HS_RAD_ORDER "_
				"LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = RAD_ENC_FK "_
				"WHERE RAD_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND RAD_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND RAD_PK = ? "

	Quit tSQL
}

ClassMethod TriggerRADByDate() As %String
{
	Set tSQL = "SELECT TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Rad Order */ "_
				"SELECT "_
				"rad_pk ENTITY_ID, "_
				"rad_pat_fk PATIENT_ID, "_
				"rad_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,RAD' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(rad_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(rad_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(rad_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT rad_pk, rad_pat_fk, rad_enc_fk, rad_tr1_dat, rad_tr2_dat, rad_tr3_dat FROM hs_rad_order WHERE rad_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND rad_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT rad_pk, rad_pat_fk, rad_enc_fk, rad_tr1_dat, rad_tr2_dat, rad_tr3_dat FROM hs_rad_order WHERE rad_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND rad_tr2_dat <= NOW() "_
				"UNION "_
				"SELECT rad_pk, rad_pat_fk, rad_enc_fk, rad_tr1_dat, rad_tr2_dat, rad_tr3_dat FROM hs_rad_order WHERE rad_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND rad_tr3_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
