Class HSCUSTOM.EHRInterop.DSP.View.Document Extends %RegisteredObject
{

ClassMethod GetDocumentsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"DOC_PK, "_
					"DOC_PAT_FK, "_
					"DOC_ENC_FK, "_
					"DOC_TYP_COD, "_
					"DOC_TYP_COD AS DOC_TYP_DSC, "_
					"DOC_NAM, "_
					"DOC_DAT, "_
					"DOC_CLI_COD, "_
					"DOC_CLI_CONS_COD, "_
					"DOC_CLI_CONS_DSC, "_
					"DOC_CLI_NAM, "_
					"DOC_BDT, "_
					"DOC_BOD, "_
					"DOC_STA, "_
					"(select distinct(enc_fac_cod) from hs_encounter where enc_pk = doc_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select distinct(enc_fac_dsc) from hs_encounter where enc_pk = doc_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
				"FROM HS_DOCUMENT "_
				"WHERE DOC_PAT_FK = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND DOC_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND DOC_PK = ? "
	
	Quit tSQL
}

ClassMethod TriggerDOCByDate() As %String
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
				"/* Document */ "_
				"SELECT "_
				"doc_pk ENTITY_ID, "_
				"doc_pat_fk PATIENT_ID, "_
				"doc_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,DOC' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(doc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(doc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT doc_pk, doc_pat_fk, doc_enc_fk , doc_tr1_dat, doc_tr2_dat FROM hs_document WHERE doc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND doc_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT doc_pk, doc_pat_fk, doc_enc_fk , doc_tr1_dat, doc_tr2_dat FROM hs_document WHERE doc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND doc_tr2_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
	Quit tSQL
}

ClassMethod TriggerDOCByDateDaily() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM ( "_
				"/* Document */ "_
				"SELECT "_
				"doc_pk ENTITY_ID, "_
				"doc_pat_fk PATIENT_ID, "_
				"doc_enc_fk ENCOUNTER_ID, "_
				"'PAT,ENC,DOC' ENTITY_TYPE, "_
				"LEAST(DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')), GREATEST( "_
				"NVL(doc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(doc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT doc_pk, doc_pat_fk, doc_enc_fk , doc_tr1_dat, doc_tr2_dat FROM hs_document WHERE doc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND doc_tr1_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) "_
				"UNION "_
				"SELECT doc_pk, doc_pat_fk, doc_enc_fk , doc_tr1_dat, doc_tr2_dat FROM hs_document WHERE doc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND doc_tr2_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
	Quit tSQL
}

}
