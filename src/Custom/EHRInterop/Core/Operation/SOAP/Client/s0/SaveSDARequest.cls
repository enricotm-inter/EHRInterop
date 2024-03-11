/// Criado a partir de: http://172.21.20.22:52773/csp/healthshare/hsedge/Custom.EHRInterop.Core.Service.SOAP.Service.cls?wsdl=1
Class Custom.EHRInterop.Core.Operation.SOAP.Client.s0.SaveSDARequest Extends Custom.EHRInterop.Core.Operation.SOAP.Client.s0.EnsRequest [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://www.intersystems.com/hs/custom/sda";

Parameter XMLNAME = "SaveSDARequest";

Property InfoID As %String(MAXLEN = "", XMLNAME = "InfoID");

Property TransactionID As %String(MAXLEN = "", XMLNAME = "TransactionID");

// Property ContentStream As %String(MAXLEN = "", XMLNAME = "ContentStream");

Property ContentStream As %Stream.GlobalCharacter(XMLNAME = "ContentStream");

Storage Default
{
<Data name="SaveSDARequestState">
<Subscript>"SaveSDARequest"</Subscript>
<Value name="1">
<Value>InfoID</Value>
</Value>
<Value name="2">
<Value>TransactionID</Value>
</Value>
<Value name="3">
<Value>ContentStream</Value>
</Value>
</Data>
<State>SaveSDARequestState</State>
<Type>%Storage.Serial</Type>
}

}
