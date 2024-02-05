Class Custom.EHRInterop.DSP.DT.SDA3.OtherOrder Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.OtherOrder, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

    Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.OtherOrder).%New()
	
	Set target.PlacerId	= tSource.%Get("OTH_PID")
    Set target.FillerId = tSource.%Get("OTH_FID")
    Set target.OrderItem = ..CodeTable("Order",tSource.%Get("OTH_COD"),tSource.%Get("OTH_DSC"),pCodingStandard)
    Set target.Status  = tSource.%Get("OTH_STA")
    Set target.OrderedBy = ..CodeTableClinician("CareProvider",tSource.%Get("OTH_CLI_COD"),tSource.%Get("OTH_CLI_CONS_COD"),tSource.%Get("OTH_CLI_CONS_DSC"),tSource.%Get("OTH_CLI_NAM"),pCodingStandard)
    Set target.SpecimenCollectedTime = tSource.%Get("OTH_ORD_DAT")
    Set target.EncounterNumber = tSource.%Get("OTH_ENC_FK")
	Set target.EnteredOn = tSource.%Get("OTH_ORD_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("OTH_CLI_COD"),tSource.%Get("OTH_CLI_CONS_COD"),tSource.%Get("OTH_CLI_CONS_DSC"),tSource.%Get("OTH_CLI_NAM"),pCodingStandard)
    Set target.FromTime = tSource.%Get("OTH_ORD_DAT")
    Set target.ToTime = tSource.%Get("OTH_ORD_DAT")
    
	Quit tSC
}

}
