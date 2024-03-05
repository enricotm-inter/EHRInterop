Class Custom.EHRInterop.DSP.DT.SDA3.Appointment Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Appointment, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.Appointment).%New()
	
	Set tAptDate = tSource.%Get("APT_DAT")_"T00:00:00"
	Set tCodFacility = tSource.%Get("APT_LOC_DSC")
	Set tFacility = $ZCONVERT(tSource.%Get("APT_LOC_DSC"),"U")

	Set target.Status = tSource.%Get("APT_STA")
	Set target.Type = ..CodeTable("AppointmentType",tSource.%Get("APT_TYP_COD"),tSource.%Get("APT_TYP_DSC"),pCodingStandard)
	Set target.PlacerApptId = tSource.%Get("APT_PK")
	Set target.FillerApptId = tSource.%Get("APT_PK")
	Set target.EncounterNumber = tSource.%Get("APT_ENC_FK")
	Set target.NoShow = tSource.%Get("APT_NSH")
	Set target.OrderItem = ..CodeTable("Order",tSource.%Get("APT_ITE_COD"),tSource.%Get("APT_ITE_DSC"))
	Set target.CareProvider = ..CodeTableClinician("CareProvider",tSource.%Get("APT_CLI_COD"),tSource.%Get("APT_CLI_CONS_COD"),tSource.%Get("APT_CLI_CONS_DSC"),tSource.%Get("APT_CLI_NAM"),pCodingStandard)
	
	/// HSAA Name set to SDA3 Code (if it exists) or Description(if code does not exist)</br>
	Set target.Location = ..CodeTable("HealthCareFacility",tFacility,tFacility,pCodingStandard)
	
	Set target.FromTime = tAptDate
	Set target.ToTime = tAptDate
	Set target.EnteredOn = tAptDate
	Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("APT_CLI_COD"),tSource.%Get("APT_CLI_CONS_COD"),tSource.%Get("APT_CLI_CONS_DSC"),tSource.%Get("APT_CLI_NAM"),pCodingStandard)
	Set target.Notes = tSource.%Get("APT_TXT")
	
	Quit tSC
}

}
