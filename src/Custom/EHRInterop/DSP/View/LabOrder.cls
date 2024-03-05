Class Custom.EHRInterop.DSP.View.LabOrder Extends %RegisteredObject
{

ClassMethod GetLabOrdersByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
	Set tSQL =	"SELECT "_
					"LAB_PK, "_
					"LAB_PID, "_
					"LAB_FID, "_
					"LAB_PAT_FK, "_
					"LAB_ENC_FK, "_
					"LAB_ORD_DAT, "_
					"LAB_COD, "_
					"LAB_DSC, "_
					"case lab_sta when 'CA-CANCELADO' then 'CA' when 'TE-RECIBIDO/TERMINADO' then 'CM' else lab_sta end as LAB_STA, "_
                    "LAB_CLI_COD, "_
					"LAB_CLI_CONS_COD, "_
					"LAB_CLI_CONS_DSC, "_
					"LAB_CLI_NAM, "_
					"LAB_RES_DAT, "_
					"LAB_RES_BDT, "_
					"LAB_RES_BOD, "_
					"LAB_RES_NAM, "_
					"(select enc_fac_cod from hs_encounter where enc_pk = lab_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select enc_fac_dsc from hs_encounter where enc_pk = lab_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
				"FROM HS_LAB_ORDER "_
				"WHERE LAB_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND LAB_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND LAB_PK = ? "
	
	Quit tSQL
}

ClassMethod TriggerLABByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Lab Order */ "_
				"SELECT "_
				"lab_pk ENTITY_ID, "_
				"lab_pat_fk PATIENT_ID, "_
				"lab_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,LAB' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(lab_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(lab_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(lab_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT lab_pk, lab_pat_fk, lab_enc_fk, lab_tr1_dat, lab_tr2_dat, lab_tr3_dat FROM hs_lab_order WHERE lab_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND lab_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT lab_pk, lab_pat_fk, lab_enc_fk, lab_tr1_dat, lab_tr2_dat, lab_tr3_dat FROM hs_lab_order WHERE lab_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND lab_tr2_dat <= NOW() "_
				"UNION "_
				"SELECT lab_pk, lab_pat_fk, lab_enc_fk, lab_tr1_dat, lab_tr2_dat, lab_tr3_dat FROM hs_lab_order WHERE lab_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND lab_tr3_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

ClassMethod TriggerLABByDateDaily() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT * FROM ( "_
				"/* Lab Order */ "_
				"SELECT "_
				"lab_pk ENTITY_ID, "_
				"lab_pat_fk PATIENT_ID, "_
				"lab_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,LAB' ENTITY_TYPE, "_
				"LEAST(DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')), GREATEST( "_
				"NVL(lab_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(lab_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(lab_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT lab_pk, lab_pat_fk, lab_enc_fk, lab_tr1_dat, lab_tr2_dat, lab_tr3_dat FROM hs_lab_order WHERE lab_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND lab_tr1_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) "_
				"UNION "_
				"SELECT lab_pk, lab_pat_fk, lab_enc_fk, lab_tr1_dat, lab_tr2_dat, lab_tr3_dat FROM hs_lab_order WHERE lab_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND lab_tr2_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) "_
				"UNION "_
				"SELECT lab_pk, lab_pat_fk, lab_enc_fk, lab_tr1_dat, lab_tr2_dat, lab_tr3_dat FROM hs_lab_order WHERE lab_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND lab_tr3_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

}
