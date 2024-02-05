Class Custom.EHRInterop.DSP.DT.SDA3.Observation Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Observation, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set tObsEncFk = tSource.%Get("OBS_ENC_FK")
	Set tObsCod = tSource.%Get("OBS_COD")
	Set tObsDsc = tSource.%Get("OBS_DSC")
	Set tObsUntCod = tSource.%Get("OBS_UNT_COD")
	Set tObsUntDsc = tSource.%Get("OBS_UNT_DSC")
	Set tObsVal = tSource.%Get("OBS_VAL")
	Set tObsDat = tSource.%Get("OBS_DAT")
	Set tObsCliCod = tSource.%Get("OBS_CLI_COD")
	Set tObsCliConsCod = tSource.%Get("OBS_CLI_CONS_COD")
	Set tObsCliConsDsc = tSource.%Get("OBS_CLI_CONS_DSC")
	Set tObsCliNam = tSource.%Get("OBS_CLI_NAM")
	Set tEncFacCod = tSource.%Get("ENC_FAC_COD")
	Set tEncFacDsc = tSource.%Get("ENC_FAC_DSC")
	
    Set target = ##class(HS.SDA3.Observation).%New()
    
    Set target.EncounterNumber = tObsEncFk
	
	Set target.ObservationCode = ..CodeTable("Observation",tObsCod,tObsDsc,pCodingStandard)
	Set target.ObservationCode.ObservationValueUnits = ..CodeTable("UoM",tObsUntCod,tObsUntDsc,pCodingStandard)
    Set target.ObservationValue = tObsVal
    
    Set target.ObservationTime = tObsDat
    Set target.FromTime	= tObsDat
	Set target.ToTime = tObsDat
	Set target.EnteredOn = tObsDat
	
	Set target.EnteredAt = ..CodeTable("Organization",tEncFacCod,tEncFacDsc,pCodingStandard)
	
	Set target.Clinician = ..CodeTableClinician("CareProvider",tObsCliCod,tObsCliConsCod,tObsCliConsDsc,tObsCliNam,pCodingStandard)
	Set target.EnteredBy = ..CodeTableClinician("User",tObsCliCod,tObsCliConsCod,tObsCliConsDsc,tObsCliNam,pCodingStandard)

	Quit tSC
}

}
