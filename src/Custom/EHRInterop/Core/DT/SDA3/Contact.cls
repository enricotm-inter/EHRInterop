Class Custom.EHRInterop.Core.DT.SDA3.Contact Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(source As %ResultSet, Output target As HS.SDA3.SupportContact, pField As %String, pContactType As %String = "") As %Status
{
	Set tSC = $$$OK
	
	If (source.Get(pField) '= "")
	{
		Set target = ##class(HS.SDA3.SupportContact).%New()
		
		Set tSDA3Name = ""
		Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.Name).Transform(source, .tSDA3Name, pField)
		$$$ThrowOnError(tSC)

		Set target.Name = tSDA3Name
		Set:pContactType'="" target.ContactType = ..CodeTableText("ContactType",pContactType)
	}
        
	Quit tSC
}

}
