Class Custom.EHRInterop.Core.DT.SDA3.NVPair Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(source As %ResultSet, Output target As HS.SDA3.NVPair, pCampo As %String, pName As %String, pDadoCustomizado As %String = "") As %Status
{
	Set tSC = $$$OK
	
	Set target = ##class(HS.SDA3.NVPair).%New()
        
	Set target.Name = pName
	Set:(pDadoCustomizado="") target.Value = $ZStrip(source.Get(pCampo),"*C")
	Set:(pDadoCustomizado'="") target.Value = $ZStrip(pDadoCustomizado,"*C")
	
	Quit tSC
}

}
