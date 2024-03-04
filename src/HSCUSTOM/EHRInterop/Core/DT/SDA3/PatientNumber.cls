Class HSCUSTOM.EHRInterop.Core.DT.SDA3.PatientNumber Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(source As %ResultSet, Output target As HS.SDA3.PatientNumber, pField As %String, pNumberType As %String, pOrganizationCode As %String, pOrganization As %String) As %Status
{
	Set tSC = $$$OK
	
	If (source.Get(pField) '="")
	{
		Set target = ##class(HS.SDA3.PatientNumber).%New()
		
		Set target.Number = $ZStrip(source.Get(pField), "*C")
		Set target.Organization = ..CodeTable("Organization",pOrganizationCode,pOrganization)
		Set target.NumberType = pNumberType
	}
   
	Quit tSC
}

}
