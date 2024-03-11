Class Custom.EHRInterop.Core.Service.ByPat Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Property Adapter As EnsLib.SQL.InboundAdapter;

Property PatientID As %String;

Property EntityType As %String(MAXLEN = 1000);

Property TargetHost As Ens.DataType.ConfigName [ Required ];

Parameter SETTINGS = "PatientID:Data,EntityType:Data,TargetHost:Data";

// Do ##class(EnsLib.SQL.InboundAdapter).ClearAllAppData("Tasy Oracle Service ByPat")

Method OnInit() As %Status
{
	Set tSC = $$$OK
	
	//Getting real query
	Set tQuerySrc = ..Adapter.Query
	Set tQueryStr = $ZOBJCLASSMETHOD($Piece(tQuerySrc,":",1),$Piece(tQuerySrc,":",2))
	Set ..Adapter.Query = tQueryStr
	
	Quit tSC
}

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	//Sending request to production
	Set tRequest = ##class(Custom.EHRInterop.Core.Msg.BuildSDARequest).%New()
	Set tRequest.EntityID = pInput.Get("ENTITY_ID")
	Set tRequest.PatientID = pInput.Get("PATIENT_ID")
	Set tRequest.EncounterID = pInput.Get("ENCOUNTER_ID")
	
	If (..EntityType '= "")
	{
		Set tRequest.EntityType= ..EntityType
	}
	Else
	{
		Set tRequest.EntityType = pInput.Get("ENTITY_TYPE")
	}
		
	Set tRequest.EntityDate = pInput.Get("ENTITY_DATE")
	Set tSC = ..SendRequestAsync(..TargetHost, tRequest)
	
	Quit $$$OK
}

}
