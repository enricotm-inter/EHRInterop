Class Custom.EHRInterop.Core.Msg.BuildSDARequest Extends Ens.Request
{

Property EntityID As %String;

Property PatientID As %String;

Property EncounterID As %String;

Property EntityType As %String(MAXLEN = 100);

Property EventDescription As %String(MAXLEN = 100);

Property Action As %String(MAXLEN = 100, VALUELIST = ",AddOrUpdate,DeletePatient") [ InitialExpression = "AddOrUpdate", Required ];

Property EntityHash As %String(MAXLEN = 100);

Property EntityDate As %DateTime;

Index EHRIBldSDAReqEtID On EntityID;

Index EHRBldSDAReqPatID On PatientID;

Index EHRBldSDAReqEncID On EncounterID;

Index EHRBldSDAReqEntTp On EntityType;

Index EHRBldSDAReqEvnDc On EventDescription;

Index EHRBldSDAReqAct On Action;

Index EHRIBldSDAReqEtHs On EntityHash;

Index EHRBldSDAReqEncDt On EntityDate;

Storage Default
{
<Data name="BuildSDARequestDefaultData">
<Subscript>"BuildSDARequest"</Subscript>
<Value name="1">
<Value>EntityID</Value>
</Value>
<Value name="2">
<Value>PatientID</Value>
</Value>
<Value name="3">
<Value>EncounterID</Value>
</Value>
<Value name="4">
<Value>EntityType</Value>
</Value>
<Value name="5">
<Value>EventDescription</Value>
</Value>
<Value name="6">
<Value>Action</Value>
</Value>
<Value name="7">
<Value>EntityHash</Value>
</Value>
<Value name="8">
<Value>EntityDate</Value>
</Value>
</Data>
<DefaultData>BuildSDARequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
