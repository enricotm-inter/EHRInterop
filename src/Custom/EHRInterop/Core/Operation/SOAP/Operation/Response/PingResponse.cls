Class Custom.EHRInterop.Core.Operation.SOAP.Operation.Response.PingResponse Extends Ens.Response [ ProcedureBlock ]
{

Property PingResult As %String;

Storage Default
{
<Data name="PingResponseDefaultData">
<Subscript>"PingResponse"</Subscript>
<Value name="1">
<Value>PingResult</Value>
</Value>
</Data>
<DefaultData>PingResponseDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
