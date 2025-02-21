Class Custom.EHRInterop.DSP.View.Patient Extends %RegisteredObject
{

ClassMethod GetPatientByPat() As %String
{
	Set tQueryID = $CLASSNAME()_"||QueryPatientByPat"
	Set tQueryXData = ##class(%Dictionary.CompiledXData).%OpenId(tQueryID)
	Set tSQL = tQueryXData.Data.Read()
   
	Quit tSQL
}

XData QueryPatientByPat [ MimeType = application/sql ]
{
	SELECT
		PAT_PK,
		PAT_NAM,
		PAT_MOT,
		PAT_ALI,
		PAT_REL_COD,
		PAT_REL_DSC,
		PAT_GEN,
		PAT_CIV_COD,
		PAT_CIV_DSC,
		PAT_RAC_COD,
		PAT_RAC_DSC,
		PAT_FAT,
		PAT_CPL,
		PAT_BIR_DAT,
		PAT_NTL_COD,
		PAT_NTL_DSC,
		PAT_NID,
		PAT_SSN,
		PAT_DL,
		PAT_DL_UF,
		PAT_ADR_STR,
		PAT_ADR_NUM,
		PAT_ADR_CPL,
		PAT_ADR_CIT,
		PAT_ADR_PRV,
		PAT_ADR_CTR,
		PAT_ADR_UF_COD,
		PAT_ADR_UF_DSC,
		PAT_ADR_ZIP,
		PAT_TEL_RES,
		PAT_TEL_COM,
		PAT_TEL_MOB,
		PAT_EMA,
		PAT_DTH_DAT,
		PAT_DTH_LOC
	FROM HS_PATIENT 
	WHERE PAT_PK = ?
}

ClassMethod TriggerPATByDate() As %String
{
	Set tSQL = "SELECT "_
				"TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || ENTITY_ID || '_' || ENTITY_DATE) INFO_ID, "_
				"ENTITY_ID, "_
				"PATIENT_ID, "_
				"ENCOUNTER_ID, "_
				"ENTITY_TYPE, "_
				"ENTITY_DATE FROM ( "_
				"SELECT TOP ? * FROM ( "_
				" /* Patient */  "_
				"SELECT "_
				"'' ENTITY_ID, "_
				"pat_pk PATIENT_ID, "_
				"NULL ENCOUNTER_ID, "_
				"'PAT' ENTITY_TYPE, "_
				"LEAST(NOW(), GREATEST( "_
				"NVL(pat_tr1_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')), "_
				"NVL(pat_tr2_dat, TO_TIMESTAMP('1900-01-01 00:00:00', 'YYYY-MM-DD HH:MI:SS')) "_
				")) ENTITY_DATE "_
				"FROM ( "_
				"SELECT * FROM hs_patient WHERE pat_tr1_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND pat_tr1_dat <= NOW() "_
				"UNION "_
				"SELECT * FROM hs_patient WHERE pat_tr2_dat > TO_TIMESTAMP(?, 'YYYY-MM-DD HH:MI:SS') AND pat_tr2_dat <= NOW() "_
				") "_
				") "_
				"ORDER BY ENTITY_DATE "_
				") "
				
	Quit tSQL
}

ClassMethod TriggerByPat() As %String
{
	Set tSQL = "SELECT PATIENT_ID INFO_ID, ENTITY_ID, PATIENT_ID, ENCOUNTER_ID, ENTITY_TYPE, ENTITY_DATE FROM ( "_
				" "_ 
				"/* Patient */ "_
				"SELECT "_
				"NULL ENTITY_ID, "_
				"PAT_PK PATIENT_ID, "_
				"NULL ENCOUNTER_ID, "_
				"'PAT' ENTITY_TYPE, "_
				"SYSDATE ENTITY_DATE "_
				"FROM HS_PATIENT "_
				"WHERE PAT_PK = ? "_
				") "
				
	Quit tSQL
}

ClassMethod TriggerBySQLEnc() As %String
{
	Set tSQL = "SELECT TRIM(ENCOUNTER_ID || '_' || ENTITY_TYPE || '_' || TO_CHAR(ENTITY_DATE, '%Y-%m-%d %H:%M:%S')) INFO_ID, ENTITY_ID, PATIENT_ID, ENCOUNTER_ID, ENTITY_TYPE, TO_CHAR(ENTITY_DATE, '%Y-%m-%d %H:%M:%S') ENTITY_DATE FROM ( "_
				" "_ 
				"/* Patient */ "_
				"select "_
				"NULL::INTEGER ENTITY_ID, "_
				"p.pat_pk PATIENT_ID, "_
				"e.enc_pk ENCOUNTER_ID, "_
				"'ALT,APT,PAT,ENC,DXG,DOC,OBS,PRC,SOC,ILL,FAM,RAD,LAB,OTH,MED' ENTITY_TYPE, "_
				"SYSDATE ENTITY_DATE "_
				"FROM hs_patient p "_
				"INNER JOIN hs_encounter e ON e.enc_pat_fk = p.pat_pk "_
				"WHERE p.pat_pk IN ('2710','5626','5797','8543','8653','9679','10806','12917','13049','14166','15092','16302','18440','20028','20248','20291','21081','21352','21563','21868','22124','22176','22454','22958','23921','24377','26801','30324','31754','32100','32266','33792','38854','38959','40306','40637','43278','43388','43495','44008','44067','44676','46778','48067','49131','49266','49927','51056','51144','51762','53455','55487','55587','57415','57615','58798','61868','64003','64956','66249','69758','69935','71993','72752','73552','74018','74490','75066','76470','83610','85862','87080','87425','89595','91579','93082','96482','96688','97681','104869','106942','107005','107060','109503','109635','110122','110770','110959','111269','113303','119502','120586','122379','124260','125377','126550','127267','128760','128792','128837','128968','129751','132123','132149','132391','134977','135201','137643','138467','138913','140147','140467','142221','145675','145881','146405','147613','148405','149950','150370','152211','152403','154313','157258','160310','161285','162562','163530','164366','165490','166210','168853','173001','184287','184778','194219','199310','204681','208837','211984','212794','215811','216410','220367','220604','222422','225292','228179','228697','231866','233116','502472','504291','506269','512419','512954','513148','513178','513331','513770','521127','524977','525189','526215','529246','531408','536225','538235','542508','544743','549691','550483','550652','556200','559491','560789','564177','566370','566551','566986','581183','592218','598306','598318','598753','618303','622245','630530','632137','636010','643161','644965','652128','659822','663531','669973','682553','682760','683073','685896','691100','691207','692086','704868','712271','713941','714338','717676','717914','718752','725291','725946','729160','744719','745659','745782','746916','751948','763025','763965','770795','772842','773657','779685','780602','780864','781431','789362','792831','818960','819093','826844','837840','842366','848646','850044','852533','856460','858400','863007','867926','873724','875145','893469','899562','899827','912171','913541','915760','917440','918202','927668','937149','943806','948376','953392','954984','957316','964832','967222','968396','981432','985601','991084','991890','995896','1000559','1002414','1012933','1014079','1032911','1058221','1064091','1068122','1078961','1096926','1104081','1116631','1118476','1119808','1120745','1126494','1129161','1130419','1130850','1131532','1136712','1152611','1153204','1154369','1159229','1160269','1162461','1168855','1169240','1172467','1174587','1175555','1175977','1176197','1180480','1181970','1184329','1187001','1191493','1193237','1204669','1209063','1209929','1212956','1215829','1221334','1225056','1229863','1237844','1250261','1254154','1256269','1258365','1260972','1269108','1271168','1276616','1280503','1281997','1283007','1284745','1287160','1290810','1295898','1301731','1303175','1304107','1307386','1312103','1316218','1316596','1319753','1320384','1320604','1322906','1325382','1325644','1325852','1330256','1333785','1336849','1337319','1339261','1339509','1349856','1353719','1354533','1356269','1361394','1367735','1367974','1373458','1373653','1374679','1387507','1387634','1388426','1388633','1394123','1403603','1404225','1410512','1416494','1421031','1422858','1426405','1430596','1431417','1431832','1434954','1437621','1437693','1444927','1449804','1454092','1457698','1461413','1465246','1467137','1471089','1474355','1474515','1476156','1478517','1478738','1480556','1481026','1481047','1486001','1488117','1489091','1490783','1490920','1492382','1492873','1493350','1494481','1495322','1498674','1500365','1500592','1501614','1504002','1508478','1509720','1509924','1511668','1512461','1515154','1516130','1519201','1519769','1520719','1522111','1523110','1524767','1527760','1528660','1529425','1529566','1530971','1531862','1533618','1534013','1534754','1535182','1535539','1536102','1537948','1541192','1541200','1542081','1542917','1543141','1545093','1545881','1547419','1551509','1551978','1552207','1552254','1553164','1553270','1553639','1554273','1554927','1556671','1556774','1558678','1559112','1563781','1564325','1565260','1565658','1565899','1569725','1569743','1569936','1571713','1572234','1574583','1575686','1575743','1575754','1576562','1578139','1579817','1580604','1580785','1580805','1582252','1584113','1584351','1585430','1586299','1586616','1586639','1588352','1588881','1589314','1589706','1589914','1591208','1594458','1594688','1594851','1595091','1596422','1597715','1597957','1598220','1598897','1600596','1601076','1601799','1602182','1603613','1603884','1604100','1604556','1605054','1605543','1605709','1606015','1606757','1607045','1608253','1608413','1609189','1609952','1611136','1611387','1611398','1611409','1611603','1612101','1613165','1613645','1613756','1614300','1614863','1615426','1615489','1615527','1616134','1616311','1616562','1616733','1616830','1617168','1617287','1617366','1617421','1617439','1617641','1617768','1617807','1618049','1618553','1618845','1619169','1619720','1619896','1620032','1620850','1620986','1621284','1621352','1622501','1622522','1622734','1622982','1623195','1623406','1623636','1623665','1623678','1623763','1624037','1624116','1624140','1624241','1624245','1624302','1624325','1624437','1624652','1624799','1624963','1625076','1625130','1625531','1625560','1625564','1626097','1626134','1626808','1626881','1627021','1627076','1627150','1627485','1627592','1627601','1627613','1627834','1627865','1627916','1628081','1628131','1628310','1628387','1628428','1628439','1628558','1628855','1628882','1629010','1629477','1629491','1629919','1630165','1630177','1630178','1630233','1630427','1630638','1630732','1631463','1631559','1631574','1632135','1632160','1632316','1632420','1632451','1632498','1632553','1632559','1632726','1632897','1633113','1633211','1633346','1633398','1633458','1633495','1633683','1633764','1633841','1634016','1634078','1634131','1634211','1634222','1634234','1634241','1634396','1634463','1634468','1634494','1634671','1634736','1634764','1634770','1634855','1634939','1635115','1635171','1635280','1635283','1635299','1635314','1635324','1635362','1635391','1635507','1635516','1635545','1635573','1635612','1635667','1635707','1635756','1635763','1635805','1635814','1635830','1635860','1635895','1635898','1635903','1635935','1635946','1635972','1635995','1636073','1636204','1636246','1636250','1636285','1636303','1636312','1636328','1636335','1636390','1636402','1636413','1636444','1636462','1636464','1636469','1636474','1636492','1636493','1636520','1636557','1636564','1636569','1636618','1636643','1636775','1636792','1636801','1636830','1636850','1636880','1636899','1636924','1636945','1637004','1637014','1637077','1637080','1637090','1637106','1637122','1637128','1637184','1637186','1637193','1637212','1637222','1637227','1637267','1637268','1637296','1637306','1637307','1637315','1637333','1637334','1637357','1637359','1637392','1637398','1637401','1637429','1637434','1637438','1637454','1637467','1637484','1637487','1637496','1637510','1637625','1637654','1637657','1637664','1637680','1637696','1637703','1637714','1637758','1637763','1637825','1637873','1637922','1637926','1637945','1637947','1637954','1637967','1637968','1637969') "_
				") "
				
	Quit tSQL
}

ClassMethod TriggerBySQLLab() As %String
{
	Set tSQL = "SELECT TRIM(ENCOUNTER_ID || '_' || ENTITY_TYPE || '_' || TO_CHAR(ENTITY_DATE, '%Y-%m-%d %H:%M:%S')) INFO_ID, ENTITY_ID, PATIENT_ID, ENCOUNTER_ID, ENTITY_TYPE, TO_CHAR(ENTITY_DATE, '%Y-%m-%d %H:%M:%S') ENTITY_DATE FROM ( "_
				" "_ 
				"/* Patient */ "_
				"select "_
				"l.lab_pk ENTITY_ID, "_
				"p.pat_pk PATIENT_ID, "_
				"e.enc_pk ENCOUNTER_ID, "_
				"'PAT,ENC,LAB' ENTITY_TYPE, "_
				"SYSDATE ENTITY_DATE "_
				"FROM hs_patient p "_
				"INNER JOIN hs_encounter e ON e.enc_pat_fk = p.pat_pk "_
				"INNER JOIN hs_lab_order l ON l.lab_enc_fk = e.enc_pk "_
				"WHERE enc_pat_fk = '10883' and enc_pk = 4705156 "_
				") "
				
	Quit tSQL
}

ClassMethod TriggerBySQLPat() As %String
{
	Set tSQL = "SELECT TRIM(PATIENT_ID || '_' || ENTITY_TYPE || '_' || TO_CHAR(ENTITY_DATE, '%Y-%m-%d %H:%M:%S')) INFO_ID, ENTITY_ID, PATIENT_ID, ENCOUNTER_ID, ENTITY_TYPE, TO_CHAR(ENTITY_DATE, '%Y-%m-%d %H:%M:%S') ENTITY_DATE FROM ( "_
				" "_ 
				"/* Patient */ "_
				"select "_
				"NULL::INTEGER ENTITY_ID, "_
				"p.pat_pk PATIENT_ID, "_
				"NULL::INTEGER ENCOUNTER_ID, "_
				;"'PAT,ENC,DXG,LAB,RAD,DOC,OBS,ALT,APT,PRC,SOC,ILL,FAM,OTH,MED' ENTITY_TYPE, "_
				"'PAT,ENC,DXG,ALT,PRC,SOC,ILL,FAM' ENTITY_TYPE, "_
				"SYSDATE ENTITY_DATE "_
				"FROM hs_patient p "_
				"WHERE 1=0 and (p.pat_tr1_dat > TO_DATE('2022-01-01 00:00:00') or p.pat_tr2_dat > TO_DATE('2022-01-01 00:00:00')) "_
				") "
	Quit tSQL
}

}
