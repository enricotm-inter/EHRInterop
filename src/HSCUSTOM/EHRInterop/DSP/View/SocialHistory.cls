Class HSCUSTOM.EHRInterop.DSP.View.SocialHistory Extends %RegisteredObject
{

ClassMethod GetSocialHistoriesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
                    "SOC_PK, "_
                    "SOC_PAT_FK, "_
                    "SOC_ENC_FK, "_
                    "SOC_DAT, "_
                    "SOC_CLI_COD, "_
                    "SOC_CLI_CONS_COD, "_
                    "SOC_CLI_CONS_DSC, "_
                    "SOC_CLI_NAM, "_
                    "SOC_COD, "_
                    "SOC_DSC, "_
                    "SOC_NOT, "_
                    "(select enc_fac_cod from hs_encounter where enc_pk = soc_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select enc_fac_dsc from hs_encounter where enc_pk = soc_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
                "FROM HS_SOCIAL_HISTORY "_
				"WHERE SOC_PAT_FK = ? "
    
    Set:pIncludeWhereByEnc tSQL = tSQL_"AND SOC_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND SOC_PK = ? "
	
	Quit tSQL
}

ClassMethod TriggerSOCByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Social History */ "_
				"SELECT "_
				"soc_pk ENTITY_ID, "_
				"soc_pat_fk PATIENT_ID, "_
				"soc_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,SOC' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(soc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(soc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(soc_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_social_history "_
				"WHERE (1=0 "_
				"OR (soc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND soc_tr1_dat <= NOW()) "_
				"OR (soc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND soc_tr2_dat <= NOW()) "_
				"OR (soc_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND soc_tr3_dat <= NOW()) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
