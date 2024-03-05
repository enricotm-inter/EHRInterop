Class Custom.EHRInterop.DSP.DT.SDA3.LabOrder Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.LabOrder, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)

	Set target = ##class(HS.SDA3.LabOrder).%New()
	
	Set target.ExternalId = tSource.%Get("LAB_PK")
	
	Set tCodFacility = tSource.%Get("ENC_FAC_COD")
	Set tFacility = $ZCONVERT(tSource.%Get("ENC_FAC_DSC"),"U")
	
	Set target.PlacerId = tSource.%Get("LAB_PID")
    Set target.FillerId = tSource.%Get("LAB_FID")
    Set target.OrderItem = ..CodeTable("Order",tSource.%Get("LAB_COD"),tSource.%Get("LAB_DSC"),pCodingStandard)
    Set target.Status = tSource.%Get("LAB_STA")
    Set target.OrderedBy = ..CodeTableClinician("CareProvider",tSource.%Get("LAB_CLI_COD"),tSource.%Get("LAB_CLI_CONS_COD"),tSource.%Get("LAB_CLI_CONS_DSC"),tSource.%Get("LAB_CLI_NAM"),pCodingStandard)
    Set target.EnteringOrganization = ..CodeTable("HealthCareFacility",tFacility,tFacility,pCodingStandard)
    Set target.SpecimenCollectedTime = tSource.%Get("LAB_ORD_DAT")
    ;Set target.SpecimenReceivedTime = tSource.%Get("LAB_ORD_DAT")
    ;Set target.AuthorizationTime = tSource.%Get("LAB_ORD_DAT")
    ;Set target.ReassessmentTime = tSource.%Get("LAB_ORD_DAT")
    Set target.EncounterNumber = tSource.%Get("LAB_ENC_FK")
	Set target.EnteredOn = tSource.%Get("LAB_ORD_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("LAB_CLI_COD"),tSource.%Get("LAB_CLI_CONS_COD"),tSource.%Get("LAB_CLI_CONS_DSC"),tSource.%Get("LAB_CLI_NAM"),pCodingStandard)
    Set target.FromTime = tSource.%Get("LAB_ORD_DAT")
    Set target.ToTime = tSource.%Get("LAB_ORD_DAT")
    
    If (tSource.%Get("LAB_RES_BOD") '= "")
	{
		Set tSDA3LabResult = ##class(HS.SDA3.Result).%New()
	
		Set tSDA3LabResult.FileType = tSource.%Get("LAB_RES_BDT")
		
		Set tLabResBod = tSource.%Get("LAB_RES_BOD")
		Do tSDA3LabResult.Stream.Write(tLabResBod)
	    	
	    Set tSDA3LabResult.EncounterNumber = tSource.%Get("LAB_ENC_FK")
		Set tSDA3LabResult.ResultTime = tSource.%Get("LAB_RES_DAT")
	    Set tSDA3LabResult.ResultStatus = "F"
		Set tSDA3LabResult.DocumentName = tSource.%Get("LAB_RES_NAM")
	    Set tSDA3LabResult.EnteredOn = tSource.%Get("LAB_RES_DAT")
	    Set tSDA3LabResult.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
	    
	    Set target.Result = tSDA3LabResult
	}
	
	Quit tSC
}

}
