Class HSCUSTOM.EHRInterop.DSP.DT.SDA3.FamilyHistory Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.FamilyHistory, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.FamilyHistory).%New()
    
	Set target.ExternalId = tSource.%Get("FAM_PK")
    Set target.FamilyMember = ..CodeTable("FamilyMember",tSource.%Get("FAM_KIN_COD"),tSource.%Get("FAM_KIN_DSC"))
	Set target.NoteText = tSource.%Get("FAM_NOT")
	Set target.Status = tSource.%Get("FAM_STA")
	Set target.EnteredOn = tSource.%Get("FAM_DAT")
    Set target.FromTime = tSource.%Get("FAM_DAT")
    Set target.ToTime = tSource.%Get("FAM_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("FAM_CLI_COD"),tSource.%Get("FAM_CLI_CONS_COD"),tSource.%Get("FAM_CLI_CONS_DSC"),tSource.%Get("FAM_CLI_NAM"),pCodingStandard)
    Set target.EncounterNumber = tSource.%Get("FAM_ENC_FK")
	
	Quit tSC
}

}
