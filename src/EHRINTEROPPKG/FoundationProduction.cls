Class SDAENGINEPKG.FoundationProduction Extends Ens.Production [ Not ProcedureBlock ]
{

XData ProductionDefinition
{
<Production Name="SDAENGINEPKG.FoundationProduction" TestingEnabled="true" LogGeneralTraceEvents="false">
  <Description></Description>
  <ActorPoolSize>1</ActorPoolSize>
  <Item Name="JG" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Port">55558</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Operation" Category="" ClassName="Custom.EHRInterop.DSP.Operation.BuildSDAOperation" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="CodingStandard">SERVINTE</Setting>
    <Setting Target="Host" Name="SendingFacility">SERVINTE</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Host" Name="SOAPHost">HSEDGESERVINTE SOAP Operation</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate PRC" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Procedure:TriggerPRCByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate OBS" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Observation:TriggerOBSByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate ENC" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Encounter:TriggerENCByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate DXG" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Diagnosis:TriggerDXGByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate DOC" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Document:TriggerDOCByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate PAT" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Patient:TriggerPATByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Adapter" Name="ConnectionAttributes"></Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate SOC" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.SocialHistory:TriggerSOCByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate ILL" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.IllnessHistory:TriggerILLByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate FAM" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.FamilyHistory:TriggerFAMByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate OTH" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.OtherOrder:TriggerOTHByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate MED" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Medication:TriggerMEDByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate APT" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Appointment:TriggerAPTByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByDate ALT" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">60</Setting>
    <Setting Target="Host" Name="InitialDate">2023-12-04 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows">999999</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[$MaxRows,&UpperDate,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Alert:TriggerALTByDate</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service ByPat" Category="" ClassName="Custom.EHRInterop.Core.Service.ByPat" PoolSize="1" Enabled="false" Foreground="false" Comment="Tributar los datos de un paciente creando una sola transacción (todos los datos del PAT en un solo SDA)" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">99999999</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Host" Name="PatientID">1720134</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Patient:TriggerByPat</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="Parameters">$PatientID</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Host" Name="EntityType">PAT,ENC,DOC</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service BySQL" Category="" ClassName="Custom.EHRInterop.Core.Service.BySQL" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">99999999</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Patient:TriggerBySQLLab</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Adapter" Name="Parameters"></Setting>
    <Setting Target="Adapter" Name="DeleteQuery">update interoperabilidad set estado = 'E' where secuencia = 11830</Setting>
    <Setting Target="Adapter" Name="StayConnected">1</Setting>
  </Item>
  <Item Name="Ens.Activity.Operation.Local" Category="" ClassName="Ens.Activity.Operation.Local" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
  </Item>
  <Item Name="HSEDGESERVINTE SOAP Operation" Category="" ClassName="Custom.EHRInterop.Core.Operation.SOAP.Operation.SDASOAPServiceSoap" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="SOAPCredentials">HS_Services</Setting>
    <Setting Target="Adapter" Name="SSLCheckServerIdentity">0</Setting>
    <Setting Target="Adapter" Name="WebServiceURL">http://192.168.71.95:52773/csp/healthshare/hsedgeservinte/services/Custom.EHRInterop.Service.SOAP.Service.cls</Setting>
    <Setting Target="Adapter" Name="ResponseTimeout">120</Setting>
  </Item>
  <Item Name="Ens.Alert" Category="" ClassName="EnsLib.EMail.AlertOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="Credentials">CorreoMonitoring</Setting>
    <Setting Target="Adapter" Name="SMTPPort">587</Setting>
    <Setting Target="Adapter" Name="SMTPServer">smtp.office365.com</Setting>
    <Setting Target="Adapter" Name="SSLConfig">MederiMailSSL*</Setting>
    <Setting Target="Adapter" Name="ContinueAfterBadSend">0</Setting>
    <Setting Target="Adapter" Name="From">monitoring.intersystem@mederi.com.co</Setting>
    <Setting Target="Adapter" Name="Recipient">marcelo.zagatti@intersystems.com,german.torres@mederi.com.co,paulo.reyes@mederi.com.co</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service Carga ENC" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">18000</Setting>
    <Setting Target="Host" Name="InitialDate">2022-01-01 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows"></Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga ENC</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG2</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Encounter:TriggerENCByDateDaily</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Operation Carga" Category="" ClassName="Custom.EHRInterop.DSP.Operation.BuildSDAOperation" PoolSize="3" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="CodingStandard">SERVINTE</Setting>
    <Setting Target="Host" Name="SendingFacility">SERVINTE</Setting>
    <Setting Target="Adapter" Name="DSN">irisJDBC</Setting>
    <Setting Target="Adapter" Name="JGService">JG</Setting>
    <Setting Target="Host" Name="SOAPHost">HSEDGESERVINTE SOAP Operation</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Host" Name="ThrottleDelay"></Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service Carga LAB" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">18000</Setting>
    <Setting Target="Host" Name="InitialDate">2022-01-01 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows"></Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG2</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.LabOrder:TriggerLABByDateDaily</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service Carga RAD" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">18000</Setting>
    <Setting Target="Host" Name="InitialDate">2022-01-01 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows"></Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG2</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.RadOrder:TriggerRADByDateDaily</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service Carga APT" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">18000</Setting>
    <Setting Target="Host" Name="InitialDate">2022-01-01 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows"></Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG2</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Appointment:TriggerAPTByDateDaily</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service Carga ENC Delete" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">999999</Setting>
    <Setting Target="Host" Name="InitialDate"></Setting>
    <Setting Target="Host" Name="MaxRows"></Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG2</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Encounter:TriggerENCByDelete</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Operation Carga ENC" Category="" ClassName="Custom.EHRInterop.DSP.Operation.BuildSDAOperation" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="CodingStandard">SERVINTE</Setting>
    <Setting Target="Host" Name="SendingFacility">SERVINTE</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG2</Setting>
    <Setting Target="Host" Name="SOAPHost">HSEDGESERVINTE SOAP Operation</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Host" Name="ThrottleDelay"></Setting>
  </Item>
  <Item Name="Servinte EHRInterop Service Carga DOC" Category="" ClassName="Custom.EHRInterop.Core.Service.ByDate" PoolSize="1" Enabled="false" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Adapter" Name="CallInterval">18000</Setting>
    <Setting Target="Host" Name="InitialDate">2022-01-01 00:00:00</Setting>
    <Setting Target="Host" Name="MaxRows"></Setting>
    <Setting Target="Host" Name="TargetHost">Servinte EHRInterop Operation Carga DOC</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG3</Setting>
    <Setting Target="Adapter" Name="KeyFieldName">INFO_ID</Setting>
    <Setting Target="Adapter" Name="Parameters"><![CDATA[&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate,&UpperDate]]></Setting>
    <Setting Target="Adapter" Name="Query">Custom.EHRInterop.DSP.View.Document:TriggerDOCByDateDaily</Setting>
    <Setting Target="Adapter" Name="DeleteQuery"></Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
  </Item>
  <Item Name="JG2" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Port">55556</Setting>
  </Item>
  <Item Name="JG3" Category="" ClassName="EnsLib.JavaGateway.Service" PoolSize="1" Enabled="true" Foreground="false" Comment="" LogTraceEvents="false" Schedule="">
    <Setting Target="Host" Name="Port">55557</Setting>
  </Item>
  <Item Name="Servinte EHRInterop Operation Carga DOC" Category="" ClassName="Custom.EHRInterop.DSP.Operation.BuildSDAOperation" PoolSize="3" Enabled="false" Foreground="false" Comment="" LogTraceEvents="true" Schedule="">
    <Setting Target="Host" Name="CodingStandard">SERVINTE</Setting>
    <Setting Target="Host" Name="SendingFacility">SERVINTE</Setting>
    <Setting Target="Adapter" Name="DSN">SERVINTE PROD REPLICA</Setting>
    <Setting Target="Adapter" Name="JGService">JG3</Setting>
    <Setting Target="Host" Name="SOAPHost">HSEDGESERVINTE SOAP Operation</Setting>
    <Setting Target="Adapter" Name="StayConnected">-1</Setting>
    <Setting Target="Host" Name="ThrottleDelay"></Setting>
  </Item>
</Production>
}

}
