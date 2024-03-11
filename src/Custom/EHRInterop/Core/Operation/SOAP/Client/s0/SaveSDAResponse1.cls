/// Criado a partir de: http://172.21.20.22:52773/csp/healthshare/hsedge/Custom.EHRInterop.Core.Service.SOAP.Service.cls?wsdl=1
Class Custom.EHRInterop.Core.Operation.SOAP.Client.s0.SaveSDAResponse1 Extends Custom.EHRInterop.Core.Operation.SOAP.Client.s0.EnsResponse [ ProcedureBlock ]
{

Parameter ELEMENTQUALIFIED = 1;

Parameter NAMESPACE = "http://www.intersystems.com/hs/custom/sda";

Parameter XMLNAME = "SaveSDAResponse";

Parameter XMLTYPE = "SaveSDAResponse";

Property Success As %Boolean(XMLNAME = "Success");

Property ErrorList As list Of %String(MAXLEN = "", XMLITEMNAME = "ErrorListItem", XMLNAME = "ErrorList", XMLPROJECTION = "COLLECTION");

Property ProcessingTransationID As %String(MAXLEN = "", XMLNAME = "ProcessingTransationID");

Storage Default
{
<Data name="SaveSDAResponse1State">
<Subscript>"SaveSDAResponse1"</Subscript>
<Value name="1">
<Value>Success</Value>
</Value>
<Value name="2">
<Value>ErrorList</Value>
</Value>
<Value name="3">
<Value>ProcessingTransationID</Value>
</Value>
</Data>
<State>SaveSDAResponse1State</State>
<Type>%Storage.Serial</Type>
}

}
