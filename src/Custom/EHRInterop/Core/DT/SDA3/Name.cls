Class Custom.EHRInterop.Core.DT.SDA3.Name Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(source As %ResultSet, Output target As HS.SDA3.Name, pField As %String) As %Status
{
	Set tSC = $$$OK
	
    Set tName = $ZStrip($ZStrip(source.Get(pField), "*C"),"<>W")

    If (tName '= "")
    {
        While $Find(tName,"  ") > 0 
        {
            Set tName = $Replace(tName,"  "," ")
        }

        Set tPieces = $Length(tName," "), (tMiddleName, tSuffix) = ""
        Set tSurname = $Piece(tName," ",tPieces)
        
        If (",FILHO,JUNIOR,NETO,JR,JR.,"[(","_$ZConvert(tSurname,"U")_",")) 
        { 
            // Sufixo
            Set tPieces = tPieces - 1
            Set tSuffix = tSurname
            Set tSurname = $Piece(tName," ",tPieces)
        }

        Set tFirstName = $Piece(tName," ",1)
        
        If (tPieces > 2) 
        {
            Set tMiddleName = $Piece(tName," ",2,tPieces-1)
        }
        
        Set target = ##class(HS.SDA3.Name).%New()
        
        Set target.FamilyName = tSurname
        Set target.NameSuffix = tSuffix
        Set target.GivenName = tFirstName
        Set target.MiddleName = $Extract(tMiddleName,1,50)
    }
	
	Quit tSC
}

}
