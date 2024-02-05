
DROP FOREIGN SERVER FTServer CASCADE
GO
CREATE FOREIGN SERVER FTServer FOREIGN DATA WRAPPER CSV HOST 'your-dirpath-here'
GO
CREATE FOREIGN TABLE hs_diagnosis (
  dxg_pk VARCHAR(8000),
  dxg_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  dxg_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  dxg_cod VARCHAR(8000),
  dxg_dsc VARCHAR(8000),
  dxg_typ VARCHAR(8000),
  dxg_dat DATETIME,
  dxg_cli_cod VARCHAR(8000),
  dxg_cli_cons_cod VARCHAR(8000),
  dxg_cli_cons_dsc VARCHAR(8000),
  dxg_cli_nam VARCHAR(8000),
  dxg_sta VARCHAR(8000),
  dxg_typ_cod VARCHAR(8000),
  dxg_typ_dsc VARCHAR(8000),
  dxg_pri BIT,
  dxg_adm BIT,
  dxg_dch BIT,
  dxg_tr1_dat DATETIME,
  dxg_tr2_dat DATETIME,
  dxg_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_diagnosis.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_document (
  doc_pk VARCHAR(8000),
  doc_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  doc_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  doc_typ_cod VARCHAR(8000),
  doc_typ_dsc VARCHAR(8000),
  doc_nam VARCHAR(8000),
  doc_dat DATETIME,
  doc_cli_cod VARCHAR(8000),
  doc_cli_cons_cod VARCHAR(8000),
  doc_cli_cons_dsc VARCHAR(8000),
  doc_cli_nam VARCHAR(8000),
  doc_bdt VARCHAR(8000),
  doc_bod VARCHAR(8000),
  doc_sta VARCHAR(8000),
  doc_tr1_dat DATETIME,
  doc_tr2_dat DATETIME,
  doc_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_document.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_encounter (
  enc_pk VARCHAR(8000),
  enc_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  enc_pat_cod VARCHAR(8000),
  enc_typ VARCHAR(8000),
  enc_fac_cod VARCHAR(8000),
  enc_fac_dsc VARCHAR(8000),
  enc_ins_cod VARCHAR(8000),
  enc_ins_dsc VARCHAR(8000),
  enc_spe_cod VARCHAR(8000),
  enc_spe_dsc VARCHAR(8000),
  enc_adm_dat DATETIME,
  enc_dis_dat DATETIME,
  enc_wrd VARCHAR(8000),
  enc_bed VARCHAR(8000),
  enc_cli_cod VARCHAR(8000),
  enc_cli_cons_cod VARCHAR(8000),
  enc_cli_cons_dsc VARCHAR(8000),
  enc_cli_nam VARCHAR(8000),
  enc_tr1_dat DATETIME,
  enc_tr2_dat DATETIME,
  enc_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_encounter.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_family_history (
  fam_pk VARCHAR(8000),
  fam_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  fam_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  fam_cli_cod VARCHAR(8000),
  fam_cli_cons_cod VARCHAR(8000),
  fam_cli_cons_dsc VARCHAR(8000),
  fam_cli_nam VARCHAR(8000),
  fam_dat DATETIME,
  fam_kin_cod VARCHAR(8000),
  fam_kin_dsc VARCHAR(8000),
  fam_not VARCHAR(8000),
  fam_ill_cod VARCHAR(8000),
  fam_ill_dsc VARCHAR(8000),
  fam_sta VARCHAR(8000),
  fam_tr1_dat DATETIME,
  fam_tr2_dat DATETIME,
  fam_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_family_history.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_illness_history (
  ill_pk VARCHAR(8000),
  ill_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  ill_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  ill_cli_cod VARCHAR(8000),
  ill_cli_cons_cod VARCHAR(8000),
  ill_cli_cons_dsc VARCHAR(8000),
  ill_cli_nam VARCHAR(8000),
  ill_dat DATETIME,
  ill_cod VARCHAR(8000),
  ill_dsc VARCHAR(8000),
  ill_not VARCHAR(8000),
  ill_sta VARCHAR(8000),
  ill_tr1_dat DATETIME,
  ill_tr2_dat DATETIME,
  ill_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_illness_history.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_lab_order (
  lab_pk VARCHAR(8000),
  lab_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  lab_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  lab_pid VARCHAR(8000),
  lab_fid VARCHAR(8000),
  lab_cod VARCHAR(8000),
  lab_dsc VARCHAR(8000),
  lab_ord_dat DATETIME,
  lab_ord_not VARCHAR(8000),
  lab_cli_cod VARCHAR(8000),
  lab_cli_cons_cod VARCHAR(8000),
  lab_cli_cons_dsc VARCHAR(8000),
  lab_cli_nam VARCHAR(8000),
  lab_sta VARCHAR(8000),
  lab_res_nam VARCHAR(8000),
  lab_res_dat DATETIME,
  lab_res_bdt VARCHAR(8000),
  lab_res_bod VARCHAR(8000),
  lab_tr1_dat DATETIME,
  lab_tr2_dat DATETIME,
  lab_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_lab_order.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_medication (
  med_pk VARCHAR(8000),
  med_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  med_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  med_psc_cod VARCHAR(8000),
  med_cod VARCHAR(8000),
  med_dsc VARCHAR(8000),
  med_rou_cod VARCHAR(8000),
  med_rou_dsc VARCHAR(8000),
  med_dos_val VARCHAR(8000),
  med_uni_cod VARCHAR(8000),
  med_uni_dsc VARCHAR(8000),
  med_cat_cod VARCHAR(8000),
  med_cat_dsc VARCHAR(8000),
  med_frq_cod VARCHAR(8000),
  med_frq_dsc VARCHAR(8000),
  med_apr_cod VARCHAR(8000),
  med_apr_dsc VARCHAR(8000),
  med_dat DATETIME,
  med_beg_dat DATETIME,
  med_end_dat DATETIME,
  med_dur_val VARCHAR(8000),
  med_cli_cod VARCHAR(8000),
  med_cli_cons_cod VARCHAR(8000),
  med_cli_cons_dsc VARCHAR(8000),
  med_cli_nam VARCHAR(8000),
  med_sta VARCHAR(8000),
  med_tr1_dat DATETIME,
  med_tr2_dat DATETIME,
  med_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_medication.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_patient (
  pat_pk VARCHAR(8000),
  pat_nam VARCHAR(8000),
  pat_mot VARCHAR(8000),
  pat_ali VARCHAR(8000),
  pat_rel_cod VARCHAR(8000),
  pat_rel_dsc VARCHAR(8000),
  pat_gen VARCHAR(8000),
  pat_civ_cod VARCHAR(8000),
  pat_civ_dsc VARCHAR(8000),
  pat_rac_cod VARCHAR(8000),
  pat_rac_dsc VARCHAR(8000),
  pat_fat VARCHAR(8000),
  pat_cpl VARCHAR(8000),
  pat_bir_dat DATETIME,
  pat_ntl_cod VARCHAR(8000),
  pat_ntl_dsc VARCHAR(8000),
  pat_nid VARCHAR(8000),
  pat_ssn VARCHAR(8000),
  pat_dl VARCHAR(8000),
  pat_dl_uf VARCHAR(8000),
  pat_adr_str VARCHAR(8000),
  pat_adr_num VARCHAR(8000),
  pat_adr_cpl VARCHAR(8000),
  pat_adr_cit VARCHAR(8000),
  pat_adr_uf_cod VARCHAR(8000),
  pat_adr_uf_dsc VARCHAR(8000),
  pat_adr_zip VARCHAR(8000),
  pat_adr_prv VARCHAR(8000),
  pat_adr_ctr VARCHAR(8000),
  pat_tel_res VARCHAR(8000),
  pat_tel_com VARCHAR(8000),
  pat_tel_mob VARCHAR(8000),
  pat_ema VARCHAR(8000),
  pat_dth_dat DATETIME,
  pat_dth_loc VARCHAR(8000),
  pat_tr1_dat DATETIME,
  pat_tr2_dat DATETIME,
  pat_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_patient.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_procedure (
  prc_pk VARCHAR(8000),
  prc_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  prc_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  prc_cod VARCHAR(8000),
  prc_dsc VARCHAR(8000),
  prc_typ_cod VARCHAR(8000),
  prc_typ_dsc VARCHAR(8000),
  prc_dat DATETIME,
  prc_cli_cod VARCHAR(8000),
  prc_cli_cons_cod VARCHAR(8000),
  prc_cli_cons_dsc VARCHAR(8000),
  prc_cli_nam VARCHAR(8000),
  prc_tr1_dat DATETIME,
  prc_tr2_dat DATETIME,
  prc_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_procedure.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
CREATE FOREIGN TABLE hs_social_history (
  soc_pk VARCHAR(8000),
  soc_pat_fk VARCHAR(8000),
  pat_pk VARCHAR(8000),
  soc_enc_fk VARCHAR(8000),
  enc_pk VARCHAR(8000),
  soc_dat DATETIME,
  soc_cli_cod VARCHAR(8000),
  soc_cli_cons_cod VARCHAR(8000),
  soc_cli_cons_dsc VARCHAR(8000),
  soc_cli_nam VARCHAR(8000),
  soc_cod VARCHAR(8000),
  soc_dsc VARCHAR(8000),
  soc_not VARCHAR(8000),
  soc_tr1_dat DATETIME,
  soc_tr2_dat DATETIME,
  soc_tr3_dat DATETIME
) SERVER FTServer FILE 'hs_social_history.csv' USING {"from" : {"file" : {"header": 1, "charset": "UTF-8", "columnseparator": ";"} } }
GO
