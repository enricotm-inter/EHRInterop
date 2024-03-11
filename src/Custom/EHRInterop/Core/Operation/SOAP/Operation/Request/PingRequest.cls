Class Custom.EHRInterop.Core.Operation.SOAP.Operation.Request.PingRequest Extends Ens.Request [ ProcedureBlock ]
{

Parameter RESPONSECLASSNAME = "Custom.EHRInterop.Core.Operation.SOAP.Operation.Response.PingResponse";

Property pInput As %String;

Storage Default
{
<Data name="PingRequestDefaultData">
<Subscript>"PingRequest"</Subscript>
<Value name="1">
<Value>pInput</Value>
</Value>
</Data>
<DefaultData>PingRequestDefaultData</DefaultData>
<Type>%Storage.Persistent</Type>
}

}
