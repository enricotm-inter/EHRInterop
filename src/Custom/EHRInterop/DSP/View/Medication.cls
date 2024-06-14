Class Custom.EHRInterop.DSP.View.Medication Extends %RegisteredObject
{

ClassMethod GetMedicationsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"MED_PK, "_
                    "MED_PAT_FK, "_
                    "MED_ENC_FK, "_
                    "MED_PSC_COD, "_
                    "MED_COD, "_
                    "MED_DSC, "_
                    "MED_ROU_COD, "_
                    "MED_ROU_DSC, "_
                    "MED_DOS_VAL, "_
                    "MED_UNI_COD, "_
                    "MED_UNI_DSC, "_
                    "MED_CAT_COD, "_
                    "MED_CAT_DSC, "_
                    "MED_FRQ_COD, "_
                    "MED_FRQ_DSC, "_
                    "MED_APR_COD, "_
                    "MED_APR_DSC, "_
                    "MED_DAT, "_
                    "MED_BEG_DAT, "_
                    "MED_END_DAT, "_
                    "MED_DUR_VAL, "_
                    "MED_CLI_COD, "_
                    "MED_CLI_CONS_COD, "_
                    "MED_CLI_CONS_DSC, "_
                    "MED_CLI_NAM, "_
                    "MED_STA, "_
                    "ENC_FAC_COD, "_
					"ENC_FAC_DSC "_
				"FROM HS_MEDICATION "_
				"LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = MED_ENC_FK "_
				"WHERE MED_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND MED_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND MED_PK = ? "

	Quit tSQL
}

ClassMethod TriggerMEDByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Medication */ "_
				"SELECT "_
				"med_pk ENTITY_ID, "_
				"med_pat_fk PATIENT_ID, "_
				"med_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,MED' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(med_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(med_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(med_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_medication WHERE med_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND med_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_medication WHERE med_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND med_tr2_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_medication WHERE med_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND med_tr3_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
	Quit tSQL
}

}
