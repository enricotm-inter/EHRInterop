Class HSCUSTOM.EHRInterop.DSP.DT.SDA3.Medication Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Medication, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

    Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
	Set target = ##class(HS.SDA3.Medication).%New()
	
	Set target.ExternalId = tSource.%Get("MED_PK")
    
	Set target.FillerId = tSource.%Get("MED_PK")
	Set target.PlacerId = tSource.%Get("MED_PK")
    Set target.Status = tSource.%Get("MED_STA")
    Set target.DrugProduct = ..CodeTable("DrugProduct",tSource.%Get("MED_COD"),tSource.%Get("MED_DSC"),pCodingStandard)
    Set target.Route = ..CodeTable("Route",tSource.%Get("MED_ROU_COD"),tSource.%Get("MED_ROU_DSC"),pCodingStandard)
    Set target.Frequency = ..CodeTable("Frequency",tSource.%Get("MED_FRQ_COD"),tSource.%Get("MED_FRQ_DSC"),pCodingStandard)
    
    //Need to format correctly the Medication Date, from '2014-03-13-09:42:16' to '2014-03-13T09:42:16'
    Set tMedDat = $Extract(tSource.%Get("MED_DAT"),1,10)_"T"_$Extract(tSource.%Get("MED_DAT"),12,19)
    
    Set target.FromTime = tMedDat
    Set target.ToTime = tMedDat
    Set target.OrderedBy = ..CodeTableClinician("CareProvider",tSource.%Get("MED_CLI_COD"),tSource.%Get("MED_CLI_CONS_COD"),tSource.%Get("MED_CLI_CONS_DSC"),tSource.%Get("MED_CLI_NAM"),pCodingStandard)
    Set target.EncounterNumber = tSource.%Get("MED_ENC_FK")
    Set target.PrescriptionNumber = tSource.%Get("MED_PSC_COD")
    Set target.DoseQuantity = tSource.%Get("MED_DOS_VAL")
    Set target.DoseUoM = ..CodeTable("UoM",tSource.%Get("MED_UNI_COD"),tSource.%Get("MED_UNI_DSC"),pCodingStandard)
    Set target.EnteredOn = tMedDat
    Set target.EnteredAt = ..CodeTable("Organization",tSource.%Get("ENC_FAC_COD"),tSource.%Get("ENC_FAC_DSC"),pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("MED_CLI_COD"),tSource.%Get("MED_CLI_CONS_COD"),tSource.%Get("MED_CLI_CONS_DSC"),tSource.%Get("MED_CLI_NAM"),pCodingStandard)

	Quit tSC
}

}
