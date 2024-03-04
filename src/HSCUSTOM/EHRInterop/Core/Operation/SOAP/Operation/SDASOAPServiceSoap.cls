Class HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.SDASOAPServiceSoap Extends Ens.BusinessOperation [ ProcedureBlock ]
{

Method Ping(pRequest As HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Request.PingRequest, Output pResponse As HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Response.PingResponse) As %Library.Status
{
 Set ..Adapter.WebServiceClientClass = "HSCUSTOM.EHRInterop.Core.Operation.SOAP.Client.SDASOAPServiceSoap"
 Set tSC = ..Adapter.InvokeMethod("Ping",.PingResult,pRequest.pInput)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.PingResult=$get(PingResult)
 Quit $$$OK
}

Method SaveSDA(pRequest As HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Request.SaveSDARequest, Output pResponse As HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Response.SaveSDAResponse) As %Library.Status
{
 s pResponse = ##class(HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Response.SaveSDAResponse).%New()
 s pResponse.SaveSDAResult.Success = 1
 q $$$OK
 Set ..Adapter.WebServiceClientClass = "HSCUSTOM.EHRInterop.Core.Operation.SOAP.Client.SDASOAPServiceSoap"
 Set tSC = ..Adapter.InvokeMethod("SaveSDA",.SaveSDAResult,pRequest.pRequest)  Quit:$$$ISERR(tSC) tSC
 Set tSC = pRequest.NewResponse(.pResponse)  Quit:$$$ISERR(tSC) tSC
 Set pResponse.SaveSDAResult=$get(SaveSDAResult)
 Quit $$$OK
}

Parameter ADAPTER = "EnsLib.SOAP.OutboundAdapter";

XData MessageMap
{
<MapItems>
	<MapItem MessageType="HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Request.PingRequest">
		<Method>Ping</Method>
	</MapItem>
	<MapItem MessageType="HSCUSTOM.EHRInterop.Core.Operation.SOAP.Operation.Request.SaveSDARequest">
		<Method>SaveSDA</Method>
	</MapItem>
</MapItems>
}

}
