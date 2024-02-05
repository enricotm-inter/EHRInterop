Class Custom.EHRInterop.DSP.View.Diagnosis Extends %RegisteredObject
{

ClassMethod GetDiagnosesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"DXG_PK, "_
					"DXG_ENC_FK, "_
					"DXG_PAT_FK, "_
					"DXG_TYP, "_
					"(case when DXG_COD = '' then 'NULL' else DXG_COD end) DXG_COD, "_
					"DXG_DSC, "_
					"DXG_DAT, "_
					"DXG_CLI_COD, "_
					"DXG_CLI_CONS_COD, "_
					"DXG_CLI_CONS_DSC, "_
					"DXG_CLI_NAM, "_
					"DXG_DAT, "_
					"DXG_STA, "_
					"DXG_TYP_COD, "_
					"DXG_TYP_DSC, "_
					"DXG_PRI, "_      
					#; "(case DXG_ADM when 'TRUE' then 'TRUE' else 'FALSE' end) DXG_ADM, "_
					#; "(case DXG_DCH when 'TRUE' then 'TRUE' else 'FALSE' end) DXG_DCH, "_
					"DXG_ADM, "_
					"DXG_DCH, "_
					"(select distinct(enc_fac_cod) from hs_encounter where enc_pk = dxg_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select distinct(enc_fac_dsc) from hs_encounter where enc_pk = dxg_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
				"FROM hs_diagnosis "_
				"WHERE dxg_pat_fk = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND dxg_enc_fk = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND dxg_pk = ? "

	Quit tSQL
}

ClassMethod TriggerDXGByDate() As %String
{
	set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE "_
				"FROM ( "_
				"SELECT TOP ? * FROM ( "_
				"/* Diagnosis */ "_
				"SELECT "_
				"dxg_pk ENTITY_ID, "_
				"dxg_pat_fk PATIENT_ID, "_
				"dxg_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,DXG' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(dxg_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(dxg_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(dxg_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_diagnosis "_
				"WHERE (1=0 "_
				"OR (dxg_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND dxg_tr1_dat <= NOW()) "_
				"OR (dxg_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND dxg_tr2_dat <= NOW()) "_
				"OR (dxg_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND dxg_tr3_dat <= NOW()) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
