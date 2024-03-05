Class Custom.EHRInterop.DSP.DT.SDA3.Alert Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Alert, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)

	Set target = ##class(HS.SDA3.Alert).%New()

	//Need to format correctly the Alert Date, from '2014-03-13-09:42:16' to '2014-03-13T09:42:16'
    Set tAltDat = $Extract(tSource.%Get("ALT_DAT"),1,10)_"T"_$Extract(tSource.%Get("ALT_DAT"),12,19)
    
    Set target.ExternalId = tSource.%Get("ALT_PK")
	Set target.AlertType = ..CodeTable("AlertType",tSource.%Get("ALT_TYP_COD"),tSource.%Get("ALT_TYP_DSC"),pCodingStandard)
	Set target.Alert = ..CodeTable("Alert",tSource.%Get("ALT_COD"),tSource.%Get("ALT_DSC"),pCodingStandard)
	Set target.Status = "A"
	Set target.FromTime = tAltDat
	Set target.ToTime = tAltDat
	Set target.EnteredOn = tAltDat
	Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
	Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("ALT_CLI_COD"),tSource.%Get("ALT_CLI_CONS_COD"),tSource.%Get("ALT_CLI_CONS_DSC"),tSource.%Get("ALT_CLI_NAM"),pCodingStandard)
	
	Quit tSC
}

}
