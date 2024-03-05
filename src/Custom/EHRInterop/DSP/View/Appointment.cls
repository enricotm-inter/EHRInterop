Class Custom.EHRInterop.DSP.View.Appointment Extends %RegisteredObject
{

ClassMethod GetAppointmentsByPat(pIncludeWhereByEnc As %Boolean, pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL = "SELECT "_
						"APT_PK, "_
						"APT_PAT_FK, "_
						"NULL APT_ENC_FK, "_
						"APT_CLI_COD, "_
						"APT_CLI_CONS_COD, "_
						"APT_CLI_CONS_DSC, "_
						"APT_CLI_NAM, "_
						"(CASE WHEN LENGTH(APT_LOC_DSC) > 0 THEN APT_LOC_COD ELSE '' END) APT_LOC_COD, "_
						"APT_LOC_DSC, "_
						"APT_DAT, "_
						"APT_NSH, "_
						"(CASE WHEN APT_STA = 'C' THEN 'CANCELLED' ELSE 'BOOKED' END) APT_STA, "_
						"APT_TYP_COD, "_
						"APT_TYP_DSC, "_
						"APT_ITE_COD, "_
						"APT_ITE_DSC, "_
						"APT_TXT, "_
                    "(select enc_fac_cod from hs_encounter where enc_pk = apt_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_COD, "_
					"(select enc_fac_dsc from hs_encounter where enc_pk = apt_enc_fk and length(enc_fac_dsc) > 0) as ENC_FAC_DSC "_
				"FROM hs_appointment "_
				"WHERE apt_pat_fk = ? "
				
	Set:pIncludeWhereByEnc tSQL = tSQL_"AND apt_enc_fk = ? "
	Set:pIncludeWhereByPK tSQL = tSQL_"AND apt_pk = ? "
  	
  	Quit tSQL
}

ClassMethod TriggerAPTByDate() As %String
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
				"/* Appointment */ "_
				"SELECT "_
				"apt_pk ENTITY_ID, "_
				"apt_pat_fk PATIENT_ID, "_
				"'' ENCOUNTER_ID, "_
				"'PAT,ENC,APT' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(apt_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(apt_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_appointment WHERE apt_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND apt_tr1_dat <= NOW() AND apt_tr1_fec >= CAST(TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AS DATETIME) AND apt_tr1_fec <= CAST(NOW() AS DATETIME) "_
				"UNION "_
				"SELECT * FROM hs_appointment WHERE apt_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND apt_tr2_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

ClassMethod TriggerAPTByDateDaily() As %String
{
	set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM ( "_
				"/* Appointment */ "_
				"SELECT "_
				"apt_pk ENTITY_ID, "_
				"apt_pat_fk PATIENT_ID, "_
				"'' ENCOUNTER_ID, "_
				"'PAT,ENC,APT' ENTITY_TYPE, "_
				"LEAST(DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')), GREATEST( "_
				"NVL(apt_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(apt_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_appointment WHERE apt_pat_fk is not null and apt_pk is not null and apt_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND apt_tr1_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) AND apt_tr1_fec >= CAST(TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AS DATETIME) AND apt_tr1_fec <= CAST(DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) AS DATETIME) "_
				"UNION "_
				"SELECT * FROM hs_appointment WHERE apt_pat_fk is not null and apt_pk is not null and apt_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND apt_tr2_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
	
	Quit tSQL
}

}
