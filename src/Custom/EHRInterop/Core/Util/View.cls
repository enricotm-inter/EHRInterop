Class Custom.EHRInterop.Core.Util.View Extends %RegisteredObject
{

ClassMethod GetXDataQuery(pObj As %RegisteredObject, pQueryName As %String) As %String
{
	Set tQueryID = $CLASSNAME(pObj)_"||"_pQueryName
	Set tQueryXData = ##class(%Dictionary.CompiledXData).%OpenId(tQueryID)
	Set tSQL = tQueryXData.Data.Read()

	Quit tSQL
}

ClassMethod IncludeWhereByEnc(pSQL As %String) As %String
{
	//WhereByEnc template:
	// "/*& --AND XYZ_ENC_FK = ? &*/"

	Quit $Replace($Replace(pSQL, "/*& --", ""), "&*/", "")
}

ClassMethod IncludeWhereByPK(pSQL As %String) As %String
{
	//WhereByPK template:
	// "/*% --AND XYZ_PK = ? %*/"

	Quit $Replace($Replace(pSQL, "/*% --", ""), "%*/", "")
}

}
