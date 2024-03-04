Class HSCUSTOM.EHRInterop.DSP.DT.SDA3.Diagnosis Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Diagnosis, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

	Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)

	Set target = ##class(HS.SDA3.Diagnosis).%New()
	
	Set target.ExternalId = tSource.%Get("DXG_PK")
	Set target.EncounterNumber = tSource.%Get("DXG_ENC_FK")
	Set target.IdentificationTime = tSource.%Get("DXG_DAT")
	Set target.DiagnosingClinician = ..CodeTableClinician("CareProvider",tSource.%Get("DXG_CLI_COD"),tSource.%Get("DXG_CLI_CONS_COD"),tSource.%Get("DXG_CLI_CONS_DSC"),tSource.%Get("DXG_CLI_NAM"),pCodingStandard)
	Set target.Diagnosis = ..CodeTable("Diagnosis",tSource.%Get("DXG_COD"), tSource.%Get("DXG_DSC"), tSource.%Get("DXG_TYP"))
	Set target.Status = ..CodeTable("DiagnosisStatus",tSource.%Get("DXG_STA"),tSource.%Get("DXG_STA"))
	Set target.EnteredOn = tSource.%Get("DXG_DAT")
	Set target.DiagnosisType = ..CodeTable("DiagnosisType",tSource.%Get("DXG_TYP_COD"),tSource.%Get("DXG_TYP_DSC"),pCodingStandard)
	
	Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("DXG_CLI_COD"),tSource.%Get("DXG_CLI_CONS_COD"),tSource.%Get("DXG_CLI_CONS_DSC"),tSource.%Get("DXG_CLI_NAM"),pCodingStandard)
	Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
	
	//Diagnosis Priority
	Set tDiagnPriority = 2
	If (tSource.%Get("DXG_PRI")) {
		Set tDiagnPriority = 1
	}
	Set target.DiagnosisPriority = tDiagnPriority
	
	//Present on Admission/Discharge
	Set tPresentOnCod = ""
	Set tPresentOnDsc = ""
	If (tSource.%Get("DXG_ADM")) { //Present on Admission?
		Set tPresentOnCod = "A"
		Set tPresentOnDsc = "Admission"
	}
	If (tSource.%Get("DXG_DCH")) { //Present on Discharge?
		Set tPresentOnCod = "D"
		Set tPresentOnDsc = "Discharge"
	}
	If (tSource.%Get("DXG_ADM")) && (tSource.%Get("DXG_DCH")) { //Present on Admission AND Discharge (is it possible?)
		Set tPresentOnCod = "AD"
		Set tPresentOnDsc = "Admission and Discharge"
	}
	Set target.PresentOnAdmission = ..CodeTable("PresentOnAdmission",tPresentOnCod,tPresentOnDsc,pCodingStandard)
	
	
	Quit tSC
}

}
