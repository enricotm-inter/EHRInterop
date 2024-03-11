Class Custom.EHRInterop.Core.Operation.SOAP.Client.SDASOAPServiceSoap Extends %SOAP.WebClient [ ProcedureBlock ]
{

Method Ping(pInput As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("Ping").Invoke($this,"http://www.intersystems.com/hs/custom/sda/Custom.EHRInterop.Service.SOAP.Service.Ping",.pInput)
}

Method SaveSDA(pRequest As Custom.EHRInterop.Core.Operation.SOAP.Client.s0.SaveSDARequest) As Custom.EHRInterop.Core.Operation.SOAP.Client.s0.SaveSDAResponse1 [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
 Quit ..WebMethod("SaveSDA").Invoke($this,"http://www.intersystems.com/hs/custom/sda/Custom.EHRInterop.Service.SOAP.Service.SaveSDA",.pRequest)
}

/// This is the URL used to access the web service.
Parameter LOCATION = "http://172.21.20.22:52773/csp/healthshare/hsedge/services/Custom.EHRInterop.Core.Service.SOAP.Service.cls";

/// This is the namespace used by the Service
Parameter NAMESPACE = "http://www.intersystems.com/hs/custom/sda";

/// Use xsi:type attribute for literal types.
Parameter OUTPUTTYPEATTRIBUTE = 1;

/// Determines handling of Security header.
Parameter SECURITYIN = "ALLOW";

/// This is the name of the Service
Parameter SERVICENAME = "SDASOAPService";

/// This is the SOAP version supported by the service.
Parameter SOAPVERSION = 1.1;

}
