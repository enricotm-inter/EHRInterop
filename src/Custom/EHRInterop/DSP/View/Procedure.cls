Class Custom.EHRInterop.DSP.View.Procedure Extends %RegisteredObject
{

ClassMethod GetProceduresByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"PRC_PK, "_
					"PRC_ENC_FK, "_
					"PRC_PAT_FK, "_
					"PRC_COD, "_
					"PRC_DSC, "_
					"PRC_TYP_COD, "_
					"PRC_TYP_DSC, "_
					"PRC_DAT, "_
					"PRC_CLI_COD, "_
					"PRC_CLI_CONS_COD, "_
					"PRC_CLI_CONS_DSC, "_
					"PRC_CLI_NAM, "_
					"ENC_FAC_COD, "_
					"ENC_FAC_DSC "_
				"FROM HS_PROCEDURE "_
				"LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = PRC_ENC_FK "_
				"WHERE PRC_PAT_FK = ? "
	
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND PRC_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND PRC_PK = ? "
						
	Quit tSQL
}

ClassMethod TriggerPRCByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Procedure */ "_
				"SELECT "_
				"prc_pk ENTITY_ID, "_
				"prc_pat_fk PATIENT_ID, "_
				"prc_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,PRC' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(prc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(prc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_procedure WHERE prc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND prc_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_procedure WHERE prc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND prc_tr2_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
