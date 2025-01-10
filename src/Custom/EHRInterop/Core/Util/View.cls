Class Custom.EHRInterop.Core.Util.View Extends %RegisteredObject
{

Parameter FilterByEncFKComment = "/** ";

Parameter FilterByPKComment = "/*** ";

ClassMethod GetXDataQuery(pObj As %RegisteredObject, pQueryName As %String) As %String
{
	Set tQueryID = $CLASSNAME(pObj)_"||"_pQueryName
	Set tQueryXData = ##class(%Dictionary.CompiledXData).%OpenId(tQueryID)
	Set tSQL = tQueryXData.Data.Read()

	Quit tSQL
}

ClassMethod IncludeWhereByEnc(pSQL As %String) As %String
{
	Quit $Replace(pSQL, ..#FilterByEncFKComment, "")
}

ClassMethod IncludeWhereByPK(pSQL As %String) As %String
{
	Quit $Replace(pSQL, ..#FilterByPKComment, "")
}

}
