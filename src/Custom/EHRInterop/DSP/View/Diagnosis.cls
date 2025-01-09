Class Custom.EHRInterop.DSP.View.Diagnosis Extends %RegisteredObject
{

ClassMethod GetDiagnosesByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tQueryID = $CLASSNAME()_"||GetDiagnosesByPat"
	Set tQueryXData = ##class(%Dictionary.CompiledXData).%OpenId(tQueryID)
	Set tSQL = tQueryXData.Data.Read()
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND DXG_ENC_FK = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND DXG_PK = ? "

	Quit tSQL
}

ClassMethod TriggerDXGByDate() As %String
{
	Set tQueryID = $CLASSNAME()_"||TriggerDXGByDate"
	Set tQueryXData = ##class(%Dictionary.CompiledXData).%OpenId(tQueryID)
	Set tSQL = tQueryXData.Data.Read()
				
	Quit tSQL
}

XData GetDiagnosesByPat [ MimeType = application/sql ]
{
	SELECT
		DXG_PK,
		DXG_ENC_FK,
		DXG_PAT_FK,
		DXG_TYP,
		DXG_COD,
		DXG_DSC,
		DXG_DAT,
		DXG_CLI_COD,
		DXG_CLI_CONS_COD,
		DXG_CLI_CONS_DSC,
		DXG_CLI_NAM,
		DXG_DAT,
		DXG_STA,
		DXG_TYP_COD,
		DXG_TYP_DSC,
		DXG_PRI,
		DXG_ADM,
		DXG_DCH,
		ENC_FAC_COD,
		ENC_FAC_DSC
	FROM HS_DIAGNOSIS
	LEFT JOIN HS_ENCOUNTER enc ON enc.ENC_PK = DXG_ENC_FK
	WHERE DXG_PAT_FK = ?
}

XData TriggerDXGByDate [ MimeType = application/sql ]
{
	SELECT
		TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID,
		ENTITY_ID,
		PATIENT_ID,
		ENCOUNTER_ID,
		ENTITY_TYPE,
		ENTITY_DATE
	FROM (
		SELECT TOP ? * FROM (
			/* Diagnosis */
			SELECT
				dxg_pk ENTITY_ID,
				dxg_pat_fk PATIENT_ID,
				dxg_enc_fk ENCOUNTER_ID,
				'PAT,ENC,DXG' ENTITY_TYPE,
				LEAST(NOW(), GREATEST(
					NVL(dxg_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(dxg_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')),
					NVL(dxg_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS'))
				)) ENTITY_DATE
			FROM hs_diagnosis
			WHERE (1=0
				OR (dxg_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND dxg_tr1_dat <= NOW())
				OR (dxg_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND dxg_tr2_dat <= NOW())
				OR (dxg_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND dxg_tr3_dat <= NOW())
			)
		)
		ORDER BY ENTITY_DATE
	)
}

}
