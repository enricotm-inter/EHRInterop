Class Custom.EHRInterop.DSP.DT.SDA3.RadOrder Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.RadOrder, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.RadOrder).%New()
	
	Set target.ExternalId = tSource.%Get("RAD_PK")
	
	Set target.PlacerId	= tSource.%Get("RAD_PID")
    Set target.FillerId = tSource.%Get("RAD_FID")
    Set target.OrderItem = ..CodeTable("Order",tSource.%Get("RAD_COD"),tSource.%Get("RAD_DSC"),pCodingStandard)
    Set target.Status  = tSource.%Get("RAD_STA")
    Set target.OrderedBy = ..CodeTableClinician("CareProvider",tSource.%Get("RAD_CLI_COD"),tSource.%Get("RAD_CLI_CONS_COD"),tSource.%Get("RAD_CLI_CONS_DSC"),tSource.%Get("RAD_CLI_NAM"),pCodingStandard)
    Set target.SpecimenCollectedTime = tSource.%Get("RAD_RES_DAT")
    Set target.EncounterNumber = tSource.%Get("RAD_ENC_FK")
	Set target.EnteredOn = tSource.%Get("RAD_ORD_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("RAD_CLI_COD"),tSource.%Get("RAD_CLI_CONS_COD"),tSource.%Get("RAD_CLI_CONS_DSC"),tSource.%Get("RAD_CLI_NAM"),pCodingStandard)
    Set target.FromTime = tSource.%Get("RAD_ORD_DAT")
    Set target.ToTime = tSource.%Get("RAD_ORD_DAT")
    
    If (tSource.%Get("RAD_RES_BOD") '= "")
	{
		Set tSDA3RadResult = ##class(HS.SDA3.Result).%New()
	
		Set tSDA3RadResult.FileType = tSource.%Get("RAD_RES_BDT")
		
    	Set tRadResBod = $Replace(tSource.%Get("RAD_RES_BOD"), "xmlns=", "xmlns:aa=")
	    Do tSDA3RadResult.Stream.Write(tRadResBod)
	    	
	    Set tSDA3RadResult.EncounterNumber = tSource.%Get("RAD_ENC_FK")
		Set tSDA3RadResult.ResultTime = tSource.%Get("RAD_RES_DAT")
	    Set tSDA3RadResult.ResultStatus = "F"
		Set tSDA3RadResult.DocumentName = tSource.%Get("RAD_RES_NAM")
	    Set tSDA3RadResult.EnteredOn = tSource.%Get("RAD_RES_DAT")
	    Set tSDA3RadResult.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
	    Set tSDA3RadResult.EnteredBy = ..CodeTableClinician("User",tSource.%Get("RAD_CLI_COD"),tSource.%Get("RAD_CLI_CONS_COD"),tSource.%Get("RAD_CLI_CONS_DSC"),tSource.%Get("RAD_CLI_NAM"),pCodingStandard)
	    
	    Set target.Result = tSDA3RadResult 
	}
	
	Quit tSC
}

}
