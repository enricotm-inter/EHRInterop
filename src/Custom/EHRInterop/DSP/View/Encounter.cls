Class Custom.EHRInterop.DSP.View.Encounter Extends %RegisteredObject
{

ClassMethod GetEncountersByPat(pIncludeWhereByPK As %Boolean) As %String
{
    Set tSQL =	"SELECT "_
					"enc_pk, "_
					"enc_pat_fk, "_
					"enc_adm_dat, "_
					"trim(enc_typ) as enc_typ, "_
					"trim(enc_fac_cod) as enc_fac_cod, "_
					"trim(enc_fac_dsc) as enc_fac_dsc, "_
					"trim(enc_ins_cod) as enc_ins_cod, "_
					"trim(enc_ins_dsc) as enc_ins_dsc, "_
					"trim(enc_spe_cod) as enc_spe_cod, "_
					"trim(enc_spe_dsc) as enc_spe_dsc, "_
					"enc_dis_dat, "_
					"trim(enc_wrd) as enc_wrd, "_
					"trim(enc_bed) as enc_bed, "_
					"enc_cli_cod, "_
					"enc_cli_cons_cod, "_
					"enc_cli_cons_dsc, "_
					"enc_cli_nam "_
				"FROM hs_encounter "_
				"WHERE enc_pat_fk = ? "
				
	Set:pIncludeWhereByPK tSQL = tSQL_"AND enc_pk = ? "
	
	Quit tSQL
}

ClassMethod TriggerENCByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT FIRST ? * FROM ( "_
				"/* Encounter */ "_
				"SELECT "_
				"enc_pk ENTITY_ID, "_
				"enc_pat_fk PATIENT_ID, "_
				"enc_pk ENCOUNTER_ID, "_
				"'PAT,ENC' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(enc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_encounter "_
				"WHERE (1=0 "_
				"OR (enc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr1_dat <= NOW()) "_
				"OR (enc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr2_dat <= NOW()) "_
				"OR (enc_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr3_dat <= NOW()) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "

	Quit tSQL
}

ClassMethod TriggerENCByDateDaily() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT * FROM ( "_
				"/* Encounter */ "_
				"SELECT "_
				"'' ENTITY_ID, "_
				"enc_pat_fk PATIENT_ID, "_
				"enc_pk ENCOUNTER_ID, "_
				"'ALT,DXG,ENC,FAM,ILL,MED,OBS,OTH,PAT,PRC,SOC' ENTITY_TYPE, "_
				"LEAST(DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS')), GREATEST( "_
				"NVL(enc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM hs_encounter "_
				"WHERE (1=0 "_
				"OR (enc_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr1_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS'))) "_
				"OR (enc_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr2_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS'))) "_
				"OR (enc_tr3_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND enc_tr3_dat <= DATEADD('day', 10, TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS'))) "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "

	Quit tSQL
}

ClassMethod TriggerENCByDelete() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT * FROM ( "_
				"/* Encounter */ "_
				"SELECT "_
				"enc_pk ENTITY_ID, "_
				"enc_pat_fk PATIENT_ID, "_
				"enc_pk ENCOUNTER_ID, "_
				"'PAT,ENC' ENTITY_TYPE, "_
				"GREATEST( "_
				"NVL(enc_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(enc_tr3_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				") ENTITY_DATE "_
				"FROM hs_encounter "_
				"WHERE NOTTOBEUSED enc_pk IN (1262397, "_
									"285121, "_
									"1496586, "_
									"2242225, "_
									"2353357, "_
									"2366257, "_
									"2381479, "_
									"2429378, "_
									"685383, "_
									"989051 "_
									") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "

	Quit tSQL
}

}
