Class Custom.EHRInterop.DSP.View.Diagnosis Extends %RegisteredObject
{

ClassMethod GetDiagnosesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"DXG_PK, "_
					"DXG_ENC_FK, "_
					"DXG_PAT_FK, "_
					"DXG_TYP, "_
					"DXG_COD, "_
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
					"DXG_ADM, "_
					"DXG_DCH, "_
					"ENC_FAC_COD, "_
					"ENC_FAC_DSC "_
				"FROM HS_DIAGNOSIS "_
				"LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = DXG_ENC_FK "_
				"WHERE DXG_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND DXG_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND DXG_PK = ? "

	Quit tSQL
}

ClassMethod TriggerDXGByDate() As %String
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
