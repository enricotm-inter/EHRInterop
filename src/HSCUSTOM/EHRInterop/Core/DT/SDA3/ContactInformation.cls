Class HSCUSTOM.EHRInterop.Core.DT.SDA3.ContactInformation Extends (Ens.DataTransform, HSCUSTOM.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(source As %ResultSet, Output target As HS.SDA3.ContactInfo) As %Status
{
	Set tSC = $$$OK
	
	Set target = ##class(HS.SDA3.ContactInfo).%New()
	
	Set target.HomePhoneNumber = $ZStrip($ZStrip(source.Get("PAT_TEL_RES"),"*C"), "<>W")
	Set target.WorkPhoneNumber = $ZStrip($ZStrip(source.Get("PAT_TEL_COM"),"*C"), "<>W")
	Set target.MobilePhoneNumber = $ZStrip($ZStrip(source.Get("PAT_TEL_MOB"),"*C"), "<>W")
	Set target.EmailAddress = $ZStrip($ZStrip(source.Get("PAT_EMA"),"*C"), "<>W")
   
	Quit tSC
}

}
