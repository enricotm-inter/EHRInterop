Class HSCUSTOM.EHRInterop.DSP.DT.SDA3.Procedure Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Procedure, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.Procedure).%New()

	Set target.ExternalId = tSource.%Get("PRC_PK")
    Set target.EncounterNumber = tSource.%Get("PRC_ENC_FK")
    Set target.Procedure = ..CodeTable("Procedure",tSource.%Get("PRC_COD"),tSource.%Get("PRC_DSC"),pCodingStandard)
    Set target.Clinician = ..CodeTableClinician("CareProvider",tSource.%Get("PRC_CLI_COD"),tSource.%Get("PRC_CLI_CONS_COD"),tSource.%Get("PRC_CLI_CONS_DSC"),tSource.%Get("PRC_CLI_NAM"),pCodingStandard)
    Set target.ProcedureTime = tSource.%Get("PRC_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
	Set target.EnteredOn = tSource.%Get("PRC_DAT")
	Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("PRC_CLI_COD"),tSource.%Get("PRC_CLI_CONS_COD"),tSource.%Get("PRC_CLI_CONS_DSC"),tSource.%Get("PRC_CLI_NAM"),pCodingStandard)

	Quit tSC
}

}
