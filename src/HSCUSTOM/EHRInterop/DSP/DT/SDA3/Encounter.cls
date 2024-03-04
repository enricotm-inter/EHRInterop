Class HSCUSTOM.EHRInterop.DSP.DT.SDA3.Encounter Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Encounter, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

    Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)

	Set target = ##class(HS.SDA3.Encounter).%New()
	
	Set tAdmissionType = tSource.%Get("ENC_TYP")
	Set tCodFacility = tSource.%Get("ENC_FAC_COD")
	Set tFacility = tSource.%Get("ENC_FAC_DSC")

    Set target.EncounterNumber = tSource.%Get("ENC_PK")
    Set target.AdmissionType = ..CodeTable("AdmissionType",tAdmissionType,tAdmissionType,pCodingStandard)
    Set target.EncounterType = tAdmissionType
    Set target.AdmittingClinician = ..CodeTableClinician("CareProvider",tSource.%Get("ENC_CLI_COD"),tSource.%Get("ENC_CLI_CONS_COD"),tSource.%Get("ENC_CLI_CONS_DSC"),tSource.%Get("ENC_CLI_NAM"),pCodingStandard)
    Set target.AdmitReason = ..CodeTable("AdmitReason",tAdmissionType,tAdmissionType,pCodingStandard)
    
    /// HSAA Name set to SDA3 Code (if it exists) or Description(if code does not exist)</br>
    Set target.HealthCareFacility = ..CodeTable("HealthCareFacility",tFacility/*tCodFacility*/,tFacility,pCodingStandard)
    
    Set target.AssignedWard = tSource.%Get("ENC_WRD")
    Set target.AssignedBed = tSource.%Get("ENC_BED")
    
    /*If (tSource.%Get("COD_CONVENIO")'= "") 
    {
        Set tHF = ##class(HS.SDA3.HealthFund).%New()
        
        Set tHF.HealthFund              = ..CodeTable("HealthFund", tSource.%Get("COD_CONVENIO"), tSource.%Get("CONVENIO"),pCodingStandard)
        Set tHF.MembershipNumber        = tSource.%Get("CARTEIRINHA")
        
        Do target.HealthFunds.Insert(tHF)
    }*/
    
    If (tSource.%Get("ENC_SPE_COD")'="")
    {
    	Do target.Specialties.Insert(..CodeTable("CareProviderType",tSource.%Get("ENC_SPE_COD"),tSource.%Get("ENC_SPE_DSC"),pCodingStandard))
    }
    Set target.UpdatedOn = tSource.%Get("ENC_ADM_DAT")
    Set target.FromTime = tSource.%Get("ENC_ADM_DAT")
    Set target.ToTime = tSource.%Get("ENC_DIS_DAT")
    Set target.EnteredAt = ..CodeTable("Organization",tCodFacility,tFacility,pCodingStandard)
    Set target.EnteredBy = ..CodeTableClinician("User",tSource.%Get("ENC_CLI_COD"),tSource.%Get("ENC_CLI_CONS_COD"),tSource.%Get("ENC_CLI_CONS_DSC"),tSource.%Get("ENC_CLI_NAM"),pCodingStandard)
    
	Quit tSC
}

}
