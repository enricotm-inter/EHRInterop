Class Custom.EHRInterop.DSP.View.IllnessHistory Extends %RegisteredObject
{

ClassMethod GetIllnessHistoriesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
	//TODO: Remplazar los subselects por JOIN cuando los indexes estuvieren OK
    Set tSQL =	"SELECT "_
                    "ILL_PK, "_
                    "ILL_PAT_FK, "_
                    "ILL_ENC_FK, "_
                    "ILL_CLI_COD, "_
                    "ILL_CLI_CONS_COD, "_
                    "ILL_CLI_CONS_DSC, "_
                    "ILL_CLI_NAM, "_
                    "ILL_COD, "_
                    "ILL_DSC, "_
                    "ILL_NOT, "_
                    "ILL_STA, "_
                    "ILL_DAT, "_
                    "(select enc_fac_cod from hs_encounter where enc_pk = ill_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select enc_fac_dsc from hs_encounter where enc_pk = ill_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
                "FROM HS_ILLNESS_HISTORY "_
				"WHERE ILL_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND ILL_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND ILL_PK = ? "
	
	Quit tSQL
}

ClassMethod TriggerILLByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Illness History */ "_
				"SELECT "_
				"ill_pk ENTITY_ID, "_
				"ill_pat_fk PATIENT_ID, "_
				"ill_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,ILL' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(ill_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(ill_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(ill_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_illness_history "_
				"WHERE (1=0 "_
				"OR (ill_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND ill_tr1_dat <= NOW()) "_
				"OR (ill_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND ill_tr2_dat <= NOW()) "_
				"OR (ill_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND ill_tr3_dat <= NOW()) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
	Quit tSQL
}

}
