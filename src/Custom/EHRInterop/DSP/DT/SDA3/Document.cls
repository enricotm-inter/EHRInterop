Class Custom.EHRInterop.DSP.DT.SDA3.Document Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Document, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.Document).%New()
	
	Set tDocId = tSource.%Get("DOC_TYP_COD")_"_"_tSource.%Get("DOC_PK")
	Set target.ExternalId = tDocId
	Set target.DocumentNumber = tDocId
	
	Set target.EncounterNumber = tSource.%Get("DOC_ENC_FK")
    Set target.DocumentTime = tSource.%Get("DOC_DAT")
    Set target.Clinician = ..CodeTableClinician("CareProvider",tSource.%Get("DOC_CLI_COD"),tSource.%Get("DOC_CLI_CONS_COD"),tSource.%Get("DOC_CLI_CONS_DSC"),tSource.%Get("DOC_CLI_NAM"),pCodingStandard)
    Set target.DocumentType = ..CodeTable("DocumentType",tSource.%Get("DOC_TYP_COD"),tSource.%Get("DOC_TYP_DSC"),pCodingStandard)
    Set target.DocumentName = tSource.%Get("DOC_NAM")
    
    Set target.FileType = tSource.%Get("DOC_BDT")
    
    If (tSource.%Get("DOC_BOD") '= "")
	{
	    Set tDocBod = tSource.%Get("DOC_BOD")
	    Do target.Stream.Write(tDocBod)
	}
    
    Set target.Status = ..CodeTable("DocumentStatus",tSource.%Get("DOC_STA"),tSource.%Get("DOC_STA"),pCodingStandard)
    Set target.EnteredOn = tSource.%Get("DOC_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("DOC_CLI_COD"),tSource.%Get("DOC_CLI_CONS_COD"),tSource.%Get("DOC_CLI_CONS_DSC"),tSource.%Get("DOC_CLI_NAM"),pCodingStandard)
   
	Quit tSC
}

}
