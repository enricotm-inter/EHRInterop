Class HSCUSTOM.EHRInterop.DSP.DT.SDA3.IllnessHistory Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.IllnessHistory, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.IllnessHistory).%New()
    
	Set target.ExternalId = tSource.%Get("ILL_PK")
	Set target.NoteText = tSource.%Get("ILL_NOT")
	Set target.Condition = ..CodeTable("PastHistoryCondition",tSource.%Get("ILL_COD"),tSource.%Get("ILL_DSC"))
    Set target.Clinician = ..CodeTableClinician("CareProvider",tSource.%Get("ILL_CLI_COD"),tSource.%Get("ILL_CLI_CONS_COD"),tSource.%Get("ILL_CLI_CONS_DSC"),tSource.%Get("ILL_CLI_NAM"),pCodingStandard)
    Set target.ActionCode = tSource.%Get("ILL_STA")
    Set target.FromTime = tSource.%Get("ILL_DAT")
	Set target.EnteredOn = tSource.%Get("ILL_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("ILL_CLI_COD"),tSource.%Get("ILL_CLI_CONS_COD"),tSource.%Get("ILL_CLI_CONS_DSC"),tSource.%Get("ILL_CLI_NAM"),pCodingStandard)
    Set target.EncounterNumber = tSource.%Get("ILL_ENC_FK")
    
	Quit tSC
}

}
