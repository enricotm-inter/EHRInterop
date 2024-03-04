Class HSCUSTOM.EHRInterop.DSP.View.FamilyHistory Extends %RegisteredObject
{

ClassMethod GetFamilyHistoriesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
                    "FAM_PK, "_
                    "FAM_PAT_FK, "_
                    "FAM_ENC_FK, "_
                    "FAM_CLI_COD, "_
                    "FAM_CLI_CONS_COD, "_
                    "FAM_CLI_CONS_DSC, "_
                    "FAM_CLI_NAM, "_
                    "FAM_DAT, "_
                    "FAM_NOT, "_
                    "FAM_STA, "_
                    "FAM_KIN_COD, "_
                    "FAM_KIN_DSC, "_
                    "(select enc_fac_cod from hs_encounter where enc_pk = fam_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select enc_fac_dsc from hs_encounter where enc_pk = fam_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
                "FROM HS_FAMILY_HISTORY "_
				"WHERE FAM_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND FAM_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND FAM_PK = ? "
	
	Quit tSQL
}

ClassMethod TriggerFAMByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE "_
				"FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Family History */ "_
				"SELECT "_
				"fam_pk ENTITY_ID, "_
				"fam_pat_fk PATIENT_ID, "_
				"fam_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,FAM' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(fam__tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(fam__tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(fam__tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_family_history "_
				"WHERE (1=0 "_
				"OR (fam__tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND fam__tr1_dat <= NOW()) "_
				"OR (fam__tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND fam__tr2_dat <= NOW()) "_
				"OR (fam__tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND fam__tr3_dat <= NOW()) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
