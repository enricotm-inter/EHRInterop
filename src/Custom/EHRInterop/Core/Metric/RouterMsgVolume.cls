Class Custom.EHRInterop.Core.Metric.RouterMsgVolume Extends Ens.BusinessMetric
{

Property LISNETMaxID As %Integer;

Property PixeonMaxID As %Integer;

Property TasyMaxID As %Integer;

Property ClinipamMaxID As %Integer;

Property MVSANTANAMaxID As %Integer;

Property HCBCMaxID As %Integer;

Property MVSALVALUSMaxID As %Integer;

/// Total LISNET msgs per time
Property LISNETCountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

/// Total Pixeon msgs per time
Property PixeonCountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

/// Total TASY msgs per time
Property TasyCountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

/// Total CLINIPAM msgs per time
Property ClinipamCountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

/// Total MVSantana msgs per time
Property MVSANTANACountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

/// Total MVSantana msgs per time
Property HCBCCountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

/// Total MVSantana msgs per time
Property MVSALVALUSCountMsg As Ens.DataType.Metric(AUTOHISTORY = 24) [ MultiDimensional ];

Method OnCalculateMetrics() As %Status
{
	//LISNET
	If (..LISNETMaxID = "") {
		Set ..LISNETMaxID = 1
	}
	
	Set tCountDiffLisnet = ""
	Set tMaxIDLisnet = ""
	Set tPrevMaxIDLisnet = ..LISNETMaxID
	
    &SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDLisnet) INTO :tCountDiffLisnet, :tMaxIDLisnet
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%LISNET%'
		AND TimeSlot > '2022-04-13 12:00:00'
		AND ID > :tPrevMaxIDLisnet)

    //Set ..LISNETCountMsg = $Get(..LISNETCountMsg) + tCountDiffLisnet
    Set ..LISNETCountMsg = tCountDiffLisnet
    Set ..LISNETMaxID = tMaxIDLisnet
    
    //Pixeon
	If (..PixeonMaxID = "") {
		Set ..PixeonMaxID = 1
	}
	
	Set tCountDiffPixeon = ""
	Set tMaxIDPixeon = ""
	Set tPrevMaxIDPixeon = ..PixeonMaxID
	
    &SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDPixeon) INTO :tCountDiffPixeon, :tMaxIDPixeon
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%PIXEON%'
		AND TimeSlot > '2022-04-13 12:00:00'
		AND ID > :tPrevMaxIDPixeon)

    //Set ..PixeonCountMsg = $Get(..PixeonCountMsg) + tCountDiffPixeon
    Set ..PixeonCountMsg = tCountDiffPixeon
    Set ..PixeonMaxID = tMaxIDPixeon
    
    //Tasy
	If (..TasyMaxID = "") {
		Set ..TasyMaxID = 1
	}
	
	Set tCountDiffTasy = ""
	Set tMaxIDTasy = ""
	Set tPrevMaxIDTasy = ..TasyMaxID
	
    &SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDTasy) INTO :tCountDiffTasy, :tMaxIDTasy
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%Oracle Service ByDate%'
		AND TimeSlot > '2022-04-13 12:00:00'
		AND ID > :tPrevMaxIDTasy)

    //Set ..TasyCountMsg = $Get(..TasyCountMsg) + tCountDiffTasy
    Set ..TasyCountMsg = tCountDiffTasy
    Set ..TasyMaxID = tMaxIDTasy
    
	//CLINIPAM
	If (..ClinipamMaxID = "") {
		Set ..ClinipamMaxID = 1
	}
	
	Set tCountDiffClinipam = ""
	Set tMaxIDClinipam = ""
	Set tPrevMaxIDClinipam = ..ClinipamMaxID

	&SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDClinipam) INTO :tCountDiffClinipam, :tMaxIDClinipam
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%Clinipam Oracle Service ByDate%'
		AND TimeSlot > '2022-07-14 08:30:00'
		AND ID > :tPrevMaxIDClinipam)

    Set ..ClinipamCountMsg = tCountDiffClinipam
    Set ..ClinipamMaxID = tMaxIDClinipam

    
    //MVSANTANA
	If (..MVSANTANAMaxID = "") {
		Set ..MVSANTANAMaxID = 1
	}
	
	Set tCountDiffMVSantana = ""
	Set tMaxIDMVSantana = ""
	Set tPrevMaxIDMVSantana = ..MVSANTANAMaxID

	&SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDMVSantana) INTO :tCountDiffMVSantana, :tMaxIDMVSantana
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%MVSANTANA Oracle Service ByDate%'
		AND TimeSlot > '2022-08-25 15:00:00'
		AND ID > :tPrevMaxIDMVSantana)

    Set ..MVSANTANACountMsg		= tCountDiffMVSantana
    Set ..MVSANTANAMaxID		= tMaxIDMVSantana
    
    //HCBC
	If (..HCBCMaxID = "") {
		Set ..HCBCMaxID = 1
	}
	
	Set tCountDiffHCBC = ""
	Set tMaxIDHCBC = ""
	Set tPrevMaxIDHCBC = ..HCBCMaxID

	&SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDHCBC) INTO :tCountDiffHCBC, :tMaxIDHCBC
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%HCBC Oracle Service ByDate%'
		AND TimeSlot > '2022-09-14 22:00:00'
		AND ID > :tPrevMaxIDHCBC)

    Set ..HCBCCountMsg	= tCountDiffHCBC
    Set ..HCBCMaxID		= tMaxIDHCBC
    
    //MV SALVALUS
	If (..MVSALVALUSMaxID = "") {
		Set ..MVSALVALUSMaxID = 1
	}
	
	Set tCountDiffMVSALVALUS = ""
	Set tMaxIDMVSALVALUS = ""
	Set tPrevMaxIDMVSALVALUS = ..MVSALVALUSMaxID

	&SQL(SELECT NVL(SUM(TotalCount), 0), NVL(MAX(ID), :tPrevMaxIDMVSALVALUS) INTO :tCountDiffMVSALVALUS, :tMaxIDMVSALVALUS
		FROM Ens_Activity_Data.Seconds
		WHERE HostName LIKE '%MVSALVALUS Service ByDate%'
		AND TimeSlot > '2022-11-01 00:00:00'
		AND ID > :tPrevMaxIDMVSALVALUS)

    Set ..MVSALVALUSCountMsg	= tCountDiffMVSALVALUS
    Set ..MVSALVALUSMaxID		= tMaxIDMVSALVALUS
	
	Quit $$$OK
}

}
