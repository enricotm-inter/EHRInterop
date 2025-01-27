Class Custom.EHRInterop.Core.Service.ByDate Extends Ens.BusinessService
{

Parameter ADAPTER = "EnsLib.SQL.InboundAdapter";

Property Adapter As EnsLib.SQL.InboundAdapter;

Property InitialDate As %DateTime [ Required ];

Property MaxRows As %Integer [ Required ];

Property TargetHost As Ens.DataType.ConfigName [ Required ];

Parameter SETTINGS = "MaxRows:Data,InitialDate:Data,TargetHost:Data";

// Do ##class(EnsLib.SQL.InboundAdapter).ClearAllAppData("Servinte EHRInterop Service ByDate ALT")

Method OnInit() As %Status
{
	Set tSC = $$$OK
	
	//Getting real query
	Set tQuerySrc = ..Adapter.Query
	Set tQueryStr = $ZOBJCLASSMETHOD($Piece(tQuerySrc,":",1),$Piece(tQuerySrc,":",2))
	Set ..Adapter.Query = tQueryStr
	
	//Initializing UpperDate with InitialDate
	Do ..Adapter.InitializePersistentValue(..%ConfigName,"UpperDate",..InitialDate)
	
	Quit tSC
}

Method OnTask() As %Status
{
	Set tSQLIsolationLevel = "SET ISOLATION TO DIRTY READ WITH WARNING;"
	Set tSC = ..Adapter.ExecuteUpdate(.tCount, tSQLIsolationLevel)
	
	Quit ##super()
}

Method OnProcessInput(pInput As EnsLib.SQL.Snapshot, Output pOutput As %RegisteredObject) As %Status
{
	//Setting upper date boundary
	Set tEntityDate = pInput.Get("ENTITY_DATE")
	Do ..Adapter.SetPersistentValue(..%ConfigName,"UpperDate",tEntityDate)
	
	//Sending request to production
	Set tRequest = ##class(Custom.EHRInterop.Core.Msg.BuildSDARequest).%New()
	Set tRequest.EntityID = $ZSTRIP(pInput.Get("ENTITY_ID"), "*C")
	Set tRequest.PatientID = $ZSTRIP(pInput.Get("PATIENT_ID"), "*C")
	Set tRequest.EncounterID = $ZSTRIP(pInput.Get("ENCOUNTER_ID"), "*C")
	Set tRequest.EntityType = $ZSTRIP(pInput.Get("ENTITY_TYPE"), "*C")
	Set tRequest.EventDescription = ""
	Set tRequest.Action = "AddOrUpdate"
	Set tRequest.EntityHash = ""
	Set tRequest.EntityDate = tEntityDate
	Set tSC = ..SendRequestAsync(..TargetHost, tRequest)
	
	Quit $$$OK
}

}
