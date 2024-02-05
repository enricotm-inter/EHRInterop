Class Custom.EHRInterop.Core.DT.SDA3.Address Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(source As %ResultSet, Output target As HS.SDA3.Address) As %Status
{
	Set tSC = $$$OK
	
	Set target = ##class(HS.SDA3.Address).%New()
	
	Set tStreet = $ZStrip($ZStrip(source.Get("PAT_ADR_STR"),"<>W"),"*C")
	Set tNumber = $ZStrip($ZStrip(source.Get("PAT_ADR_NUM"),"<>W"),"*C")
	Set:(tNumber'="") tStreet = tStreet_", "_tNumber
	Set tCompl = $ZStrip($ZStrip(source.Get("PAT_ADR_CPL"),"<>W"),"*C")
	Set:(tCompl'="") tStreet = tStreet_" - "_tCompl
	
	Set tCity=""
	Set:($ZStrip($ZStrip(source.Get("PAT_ADR_CIT"),"<>W"),"*C")'="") tCity = $ZStrip($ZStrip(source.Get("PAT_ADR_CIT"),"<>W"),"*C")
	
	Set target.Street = $Extract(tStreet,1,50)
	Set:(tCity'="") target.City = ..CodeTable("City", tCity, tCity)
	Set target.State = ..CodeTable("State", source.Get("PAT_ADR_UF_DSC") /*source.Get("PAT_ADR_UF_COD")*/, source.Get("PAT_ADR_UF_DSC")) 
	Set target.Zip = ..CodeTable("Zip", source.Get("PAT_ADR_ZIP"), source.Get("PAT_ADR_ZIP"))
	Set target.Country = ..CodeTable("Country", source.Get("PAT_ADR_CTR"), source.Get("PAT_ADR_CTR"))
     
	Quit tSC
}

}
