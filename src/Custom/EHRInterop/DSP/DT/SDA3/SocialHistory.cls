Class Custom.EHRInterop.DSP.DT.SDA3.SocialHistory Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.SocialHistory, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.SocialHistory).%New()
    
	Set target.ExternalId = tSource.%Get("SOC_PK")
	Set target.SocialHabit = ..CodeTable("SocialHabit",tSource.%Get("SOC_COD"),tSource.%Get("SOC_DSC"),pCodingStandard)
	Set target.SocialHabitComments = tSource.%Get("SOC_NOT")
    Set target.EnteredOn = tSource.%Get("SOC_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("SOC_CLI_COD"),tSource.%Get("SOC_CLI_CONS_COD"),tSource.%Get("SOC_CLI_CONS_DSC"),tSource.%Get("SOC_CLI_NAM"),pCodingStandard)
    Set target.EncounterNumber = tSource.%Get("SOC_ENC_FK")

	Quit tSC
}

}
