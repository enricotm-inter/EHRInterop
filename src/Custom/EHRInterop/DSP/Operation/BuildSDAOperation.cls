Class Custom.EHRInterop.DSP.Operation.BuildSDAOperation Extends (Ens.BusinessOperation, HS.HC.Util.Trace.Helper)
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property SendingFacility As %String [ Required ];

Property SDATargetConfigName As Ens.DataType.ConfigName;

Property CodingStandard As %String [ Required ];

Property TraceSQLQueries As %Boolean;

Property TraceQueryExecTimes As %Boolean;

Property TrackQueryExecTimes As %Boolean;

Parameter SETTINGS = "SendingFacility:Data,CodingStandard:Data,SDATargetConfigName:Data:selector?multiSelect=1&context={Ens.ContextSearch/ProductionItems?targets=1&productionName=@productionId},TraceSQLQueries:Tracing,TraceQueryExecTimes:Tracing,TrackQueryExecTimes:Tracing";

Method EntityToSDA(pRequest As Custom.EHRInterop.Core.Msg.BuildSDARequest, Output pResponse As Ens.Response) As %Status
{
 	
	// Setting Isolation Level to Uncommited Read
	#; Set tSQLIsolationLevel = "SET ISOLATION TO DIRTY READ WITH WARNING;"
	#; Set tSC = ..Adapter.ExecuteUpdate(.tCount, tSQLIsolationLevel)
	#; https://docs.intersystems.com/irisforhealthlatest/csp/docbook/DocBook.UI.Page.cls?KEY=RSQL_SETTRANSACTION
	Set tSC = $$$OK

	$$$LOGINFO("EntityToSDA Init")
	
	// EHRInterop processing parameters
	Set tPatientID = pRequest.PatientID
	Set tEncounterID = $ZSTRIP($ZSTRIP(pRequest.EncounterID, "<>W"), "*C")
	Set tEntityID = $ZSTRIP($ZSTRIP(pRequest.EntityID, "<>W"), "*C")
	Set tEntityTypes = $LISTFROMSTRING(pRequest.EntityType, ",")
	Set tEntityHTypes = $LISTFROMSTRING($REPLACE($REPLACE($REPLACE(pRequest.EntityType, "PAT", ","), "ENC", ","), ",,", ""), ",")
	Set tSendingFacility = ..SendingFacility
	Set tCodFacility = tSendingFacility
	Set tFacility = tSendingFacility
	Set tAction = $ZSTRIP($ZSTRIP(pRequest.Action, "<>W"), "*C")
	Set tEventDescription = $ZSTRIP($ZSTRIP(pRequest.EventDescription, "<>W"), "*C")
	Set:($LISTFIND(tEntityTypes,"MRG") > 0) tAction = "Merge"
	Set tCodingStandard = ..CodingStandard
	Set tFilterByEnc = (tEncounterID '= "")
	Set tFilterByPK = (tEntityID '= "")

	// EHRInterop params/transaction validation
	If (..SDATargetConfigName = "") {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"SDATargetConfigName cannot be NULL")
	}
	If (tPatientID = "") {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"PatientID cannot be NULL")
	}
	ElseIf ('$LISTFIND(tEntityTypes, "PAT")) {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"'PAT' must be in EntityType")
	}
	ElseIf (tFilterByEnc && '$LISTFIND(tEntityTypes, "ENC")) {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"'ENC' must be in EntityType when EncounterId is not NULL")
	}
	ElseIf (tFilterByPK && ($LISTLENGTH(tEntityHTypes) '= 1)) {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"EntityID requires exactly one EntityType besides 'PAT' and 'ENC'")
	}
	$$$ThrowOnError(tSC)

	// Begin with SDA Container..
	Set tSDAContainer = ##Class(HS.SDA3.Container).%New()
	Set tSDAContainer.Action = tAction
	Set tSDAContainer.SendingFacility = tSendingFacility
	
	// Generating SDA XML Actions. Always be defined a PAT+ENC. Both categories are the minimum to generate a SDA.
	If ($LISTFIND(tEntityTypes,"PAT") > 0) { Set tSC = ..EntityPatient(.tSDAContainer,tPatientID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"ENC") > 0) { Set tSC = ..EntityEncounters(.tSDAContainer,tFilterByEnc,tPatientID,tEncounterID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"DXG") > 0) { Set tSC = ..EntityDiagnoses(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"DOC") > 0) { Set tSC = ..EntityDocuments(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"OBS") > 0) { Set tSC = ..EntityObservations(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"PRC") > 0) { Set tSC = ..EntityProcedures(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"SOC") > 0) { Set tSC = ..EntitySocialHistories(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"ILL") > 0) { Set tSC = ..EntityIllnessHistories(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"FAM") > 0) { Set tSC = ..EntityFamilyHistories(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"RAD") > 0) { Set tSC = ..EntityRadOrders(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"LAB") > 0) { Set tSC = ..EntityLabOrders(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"OTH") > 0) { Set tSC = ..EntityOtherOrders(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"MED") > 0) { Set tSC = ..EntityMedications(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"APT") > 0) { Set tSC = ..EntityAppointments(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	If ($LISTFIND(tEntityTypes,"ALT") > 0) { Set tSC = ..EntityAlerts(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tEntityID,tCodingStandard) }
	
	//Sending it to SDA Targets
	Set tSC = ..SendToSDATarget(tSendingFacility, tSDAContainer, pRequest.PatientID, pRequest.EncounterID, pRequest.EntityID, pRequest.EntityType)
	$$$ThrowOnError(tSC)

	$$$LOGINFO("EntityToSDA End")
	
	Quit $$$OK
}

Method EntityPatient(ByRef pSDAContainer As HS.SDA3.Container, pPatientID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLPatient = ##Class(Custom.EHRInterop.DSP.View.Patient).GetPatientByPat()
	If ..TraceSQLQueries { $$$TRACE("PAT tSQL: "_tSQLPatient) }
	Set tDT1 = $NOW()
	Set tSC = ..Adapter.ExecuteQuery(.tRSPatient, tSQLPatient, pPatientID)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSPatient.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Patient).Transform(tRSPatient, .tSDAPatient, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set pSDAContainer.Patient = tSDAPatient
	}
	
	Set tDT3 = $NOW()
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)

	If (tI '= 1) { $$$LOGWARNING("PAT Count Incorrect: Expected 1, found "_tI) }

	If ..TraceQueryExecTimes { $$$TRACE("PAT Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI) }
	
	If ..TrackQueryExecTimes
	{
		Set ^tEHRInteropDebug("PAT", "Fetch") = $GET(^tEHRInteropDebug("PAT", "Fetch"))+tFetchDur
		Set ^tEHRInteropDebug("PAT", "Iterate") = $GET(^tEHRInteropDebug("PAT", "Iterate"))+tIterateDur
		Set ^tEHRInteropDebug("PAT", "Count") = $GET(^tEHRInteropDebug("PAT", "Count"))+tI
	}
	
	Quit tSC
}

Method EntityEncounters(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pPatientID As %String, pEncounterID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLEncounters = ##Class(Custom.EHRInterop.DSP.View.Encounter).GetEncountersByPat(pFilterByEnc)
	If ..TraceSQLQueries { $$$TRACE("ENC tSQL: "_tSQLEncounters) }
	Set tDT1 = $NOW()
	Set tSC = ..Adapter.ExecuteQuery(.tRSEncounters, tSQLEncounters, pPatientID, pEncounterID)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSEncounters.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Encounter).Transform(tRSEncounters,.tSDAEncounter, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Encounters.Insert(tSDAEncounter)
		$$$ThrowOnError(tSC)
	}

	Set tDT3 = $NOW()
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)

	If ((pFilterByEnc) && (tI '= 1)) { $$$LOGWARNING("ENC Query Count INCORRECT, once FilteredByEnc: Expected 1, found "_tI) }
	
	If ..TraceQueryExecTimes { $$$TRACE("ENC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI) }
	
	If ..TrackQueryExecTimes
	{
		Set ^tEHRInteropDebug("ENC", "Fetch") = $GET(^tEHRInteropDebug("ENC", "Fetch"))+tFetchDur
		Set ^tEHRInteropDebug("ENC", "Iterate") = $GET(^tEHRInteropDebug("ENC", "Iterate"))+tIterateDur
		Set ^tEHRInteropDebug("ENC", "Count") = $GET(^tEHRInteropDebug("ENC", "Count"))+tI
	}
	
	Quit tSC
}

Method EntityDiagnoses(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLDiagnoses = ##Class(Custom.EHRInterop.DSP.View.Diagnosis).GetDiagnosesByPat(pFilterByEnc, pFilterByPK)
	If ..TraceSQLQueries { $$$TRACE("DXG tSQL: "_tSQLDiagnoses) }
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSDiagnoses, tSQLDiagnoses, tArgs...)
	$$$ThrowOnError(tSC)

	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSDiagnoses.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Diagnosis).Transform(tRSDiagnoses, .tSDADiagnosis, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Diagnoses.Insert(tSDADiagnosis)
		$$$ThrowOnError(tSC)
	}

	Set tDT3 = $NOW()
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)

	If ((pFilterByPK) && (tI '= 1)) { $$$LOGWARNING("DXG Query Count INCORRECT, once FilteredByPK: Expected 1, found "_tI) }
	
	If ..TraceQueryExecTimes { $$$TRACE("DXG Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI) }

	If ..TrackQueryExecTimes
	{
		Set ^tEHRInteropDebug("DXG", "Fetch") = $GET(^tEHRInteropDebug("DXG", "Fetch"))+tFetchDur
		Set ^tEHRInteropDebug("DXG", "Iterate") = $GET(^tEHRInteropDebug("DXG", "Iterate"))+tIterateDur
		Set ^tEHRInteropDebug("DXG", "Count") = $GET(^tEHRInteropDebug("DXG", "Count"))+tI
	}

	Quit tSC
}

Method EntityDocuments(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLDocuments = ##Class(Custom.EHRInterop.DSP.View.Document).GetDocumentsByPat(pFilterByEnc, pFilterByPK)
	If ..TraceSQLQueries { $$$TRACE("DOC tSQL: "_tSQLDocuments) }
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSDocuments, tSQLDocuments, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSDocuments.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Document).Transform(tRSDocuments, .tSDADocument, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Documents.Insert(tSDADocument)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)

	If ((pFilterByPK) && (tI '= 1)) { $$$LOGWARNING("DOC Query Count INCORRECT, once FilteredByPK: Expected 1, found "_tI) }

	If ..TraceQueryExecTimes { $$$TRACE("DOC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI) }
	
	If ..TrackQueryExecTimes
	{
		Set ^tEHRInteropDebug("DOC", "Fetch") = $GET(^tEHRInteropDebug("DOC", "Fetch"))+tFetchDur
		Set ^tEHRInteropDebug("DOC", "Iterate") = $GET(^tEHRInteropDebug("DOC", "Iterate"))+tIterateDur
		Set ^tEHRInteropDebug("DOC", "Count") = $GET(^tEHRInteropDebug("DOC", "Count"))+tI
	}
	
	Quit tSC
}

Method EntityObservations(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLObservations = ##Class(Custom.EHRInterop.DSP.View.Observation).GetObservationsByPat(pFilterByEnc, pFilterByPK)
	If ..TraceSQLQueries { $$$TRACE("OBS tSQL: "_tSQLObservations) }
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSObservations, tSQLObservations, tArgs...)
	$$$ThrowOnError(tSC)

	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSObservations.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Observation).Transform(tRSObservations, .tSDAObservation, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Observations.Insert(tSDAObservation)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)

	If ((pFilterByPK) && (tI '= 1)) { $$$LOGWARNING("OBS Query Count INCORRECT, once FilteredByPK: Expected 1, found "_tI) }

	If ..TraceQueryExecTimes { $$$TRACE("OBS Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI) }
	
	If ..TrackQueryExecTimes
	{
		Set ^tEHRInteropDebug("OBS", "Fetch") = $GET(^tEHRInteropDebug("OBS", "Fetch"))+tFetchDur
		Set ^tEHRInteropDebug("OBS", "Iterate") = $GET(^tEHRInteropDebug("OBS", "Iterate"))+tIterateDur
		Set ^tEHRInteropDebug("OBS", "Count") = $GET(^tEHRInteropDebug("OBS", "Count"))+tI
	}
	
	Quit tSC
}

Method EntityProcedures(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLProcedures = ##Class(Custom.EHRInterop.DSP.View.Procedure).GetProceduresByPat(pFilterByEnc, pFilterByPK)
	If ..TraceSQLQueries { $$$TRACE("PRC tSQL: "_tSQLProcedures) }
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSProcedures, tSQLProcedures, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSProcedures.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Procedure).Transform(tRSProcedures, .tSDAProcedure, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Procedures.Insert(tSDAProcedure)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)

	If ((pFilterByPK) && (tI '= 1)) { $$$LOGWARNING("OBS Query Count INCORRECT, once FilteredByPK: Expected 1, found "_tI) }

	If ..TraceQueryExecTimes { $$$TRACE("PRC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI) }
	
	If ..TrackQueryExecTimes
	{
		Set ^tEHRInteropDebug("PRC", "Fetch") = $GET(^tEHRInteropDebug("PRC", "Fetch"))+tFetchDur
		Set ^tEHRInteropDebug("PRC", "Iterate") = $GET(^tEHRInteropDebug("PRC", "Iterate"))+tIterateDur
		Set ^tEHRInteropDebug("PRC", "Count") = $GET(^tEHRInteropDebug("PRC", "Count"))+tI
	}
	
	Quit tSC
}

Method EntitySocialHistories(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLSocialHistories = ##Class(Custom.EHRInterop.DSP.View.SocialHistory).GetSocialHistoriesByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("SOC tSQL: "_tSQLSocialHistories)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSSocialHistories, tSQLSocialHistories, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSSocialHistories.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.SocialHistory).Transform(tRSSocialHistories, .tSDASocialHistory, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.SocialHistories.Insert(tSDASocialHistory)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("SOC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("SOC", "Fetch") = $GET(^tEHRInteropDebug("SOC", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("SOC", "Iterate") = $GET(^tEHRInteropDebug("SOC", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("SOC", "Count") = $GET(^tEHRInteropDebug("SOC", "Count"))+tI
	
	Quit tSC
}

Method EntityIllnessHistories(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLIllnessHistories = ##Class(Custom.EHRInterop.DSP.View.IllnessHistory).GetIllnessHistoriesByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("ILL tSQL: "_tSQLIllnessHistories)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSIllnessHistories, tSQLIllnessHistories, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSIllnessHistories.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.IllnessHistory).Transform(tRSIllnessHistories, .tSDAIllnessHistory, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.IllnessHistories.Insert(tSDAIllnessHistory)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("ILL Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("ILL", "Fetch") = $GET(^tEHRInteropDebug("ILL", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("ILL", "Iterate") = $GET(^tEHRInteropDebug("ILL", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("ILL", "Count") = $GET(^tEHRInteropDebug("ILL", "Count"))+tI
	
	Quit tSC
}

Method EntityFamilyHistories(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLFamilyHistories = ##Class(Custom.EHRInterop.DSP.View.FamilyHistory).GetFamilyHistoriesByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("FAM tSQL: "_tSQLFamilyHistories)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSFamilyHistories, tSQLFamilyHistories, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSFamilyHistories.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.FamilyHistory).Transform(tRSFamilyHistories, .tSDAFamilyHistory, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.FamilyHistories.Insert(tSDAFamilyHistory)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("FAM Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("FAM", "Fetch") = $GET(^tEHRInteropDebug("FAM", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("FAM", "Iterate") = $GET(^tEHRInteropDebug("FAM", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("FAM", "Count") = $GET(^tEHRInteropDebug("FAM", "Count"))+tI
	
	Quit tSC
}

Method EntityRadOrders(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLRadOrders = ##Class(Custom.EHRInterop.DSP.View.RadOrder).GetRadOrdersByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("RAD tSQL: "_tSQLRadOrders)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSRadOrders, tSQLRadOrders, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSRadOrders.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.RadOrder).Transform(tRSRadOrders, .tSDARadOrder, pCodingStandard)
		$$$ThrowOnError(tSC)
		
		Set tSC = pSDAContainer.RadOrders.Insert(tSDARadOrder)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("RAD Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("RAD", "Fetch") = $GET(^tEHRInteropDebug("RAD", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("RAD", "Iterate") = $GET(^tEHRInteropDebug("RAD", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("RAD", "Count") = $GET(^tEHRInteropDebug("RAD", "Count"))+tI
	
	Quit tSC
}

Method EntityLabOrders(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLLabOrders = ##Class(Custom.EHRInterop.DSP.View.LabOrder).GetLabOrdersByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("LAB tSQL: "_tSQLLabOrders)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSLabOrders, tSQLLabOrders, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSLabOrders.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.LabOrder).Transform(tRSLabOrders, .tSDALabOrder, pCodingStandard)
		$$$ThrowOnError(tSC)
		
		Set tSC = pSDAContainer.LabOrders.Insert(tSDALabOrder)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("LAB Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("LAB", "Fetch") = $GET(^tEHRInteropDebug("LAB", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("LAB", "Iterate") = $GET(^tEHRInteropDebug("LAB", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("LAB", "Count") = $GET(^tEHRInteropDebug("LAB", "Count"))+tI
		
	Quit tSC
}

Method EntityOtherOrders(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLOtherOrders = ##Class(Custom.EHRInterop.DSP.View.OtherOrder).GetOtherOrdersByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("OTH tSQL: "_tSQLOtherOrders)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSOtherOrders, tSQLOtherOrders, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSOtherOrders.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.OtherOrder).Transform(tRSOtherOrders, .tSDAOtherOrder, pCodingStandard)
		$$$ThrowOnError(tSC)
		
		Set tSC = pSDAContainer.OtherOrders.Insert(tSDAOtherOrder)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("OTH Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("OTH", "Fetch") = $GET(^tEHRInteropDebug("OTH", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("OTH", "Iterate") = $GET(^tEHRInteropDebug("OTH", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("OTH", "Count") = $GET(^tEHRInteropDebug("OTH", "Count"))+tI
		
	Quit tSC
}

Method EntityMedications(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLMedications = ##Class(Custom.EHRInterop.DSP.View.Medication).GetMedicationsByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("MED tSQL: "_tSQLMedications)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSMedications, tSQLMedications, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSMedications.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Medication).Transform(tRSMedications, .tSDAMedication, pCodingStandard)
		$$$ThrowOnError(tSC)
		
		Set tSC = pSDAContainer.Medications.Insert(tSDAMedication)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("MED Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("MED", "Fetch") = $GET(^tEHRInteropDebug("MED", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("MED", "Iterate") = $GET(^tEHRInteropDebug("MED", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("MED", "Count") = $GET(^tEHRInteropDebug("MED", "Count"))+tI
		
	Quit tSC
}

Method EntityAppointments(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLAppointments = ##Class(Custom.EHRInterop.DSP.View.Appointment).GetAppointmentsByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("APT tSQL: "_tSQLAppointments)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSAppointments, tSQLAppointments, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSAppointments.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Appointment).Transform(tRSAppointments, .tSDAAppointment, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Appointments.Insert(tSDAAppointment)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("APT Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("APT", "Fetch") = $GET(^tEHRInteropDebug("APT", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("APT", "Iterate") = $GET(^tEHRInteropDebug("APT", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("APT", "Count") = $GET(^tEHRInteropDebug("APT", "Count"))+tI
		
	Quit tSC
}

Method EntityAlerts(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %Boolean, pFilterByPK As %Boolean, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLAlerts = ##Class(Custom.EHRInterop.DSP.View.Alert).GetAlertsByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("ALT tSQL: "_tSQLAlerts)
	Set tDT1 = $NOW()
	Set:1 tArgs($INCREMENT(tArgs)) = pPatientID
	Set:pFilterByEnc tArgs($INCREMENT(tArgs)) = pEncounterID
	Set:pFilterByPK tArgs($INCREMENT(tArgs)) = pEntityID
	Set tSC = ..Adapter.ExecuteQuery(.tRSAlerts, tSQLAlerts, tArgs...)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	While (tRSAlerts.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Alert).Transform(tRSAlerts, .tSDAAlert, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set tSC = pSDAContainer.Alerts.Insert(tSDAAlert)
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.Functions.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("ALT Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	//Set ^tEHRInteropDebug("ALT", "Fetch") = $GET(^tEHRInteropDebug("ALT", "Fetch"))+tFetchDur
	//Set ^tEHRInteropDebug("ALT", "Iterate") = $GET(^tEHRInteropDebug("ALT", "Iterate"))+tIterateDur
	//Set ^tEHRInteropDebug("ALT", "Count") = $GET(^tEHRInteropDebug("ALT", "Count"))+tI
	
	Quit tSC
}

Method SendToSDATarget(pSendingFacility As %String, pSDAContainer As HS.SDA3.Container, pMRN As %String, pEncounter As %String, pEntityID As %String, pEntityType As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSDAXML = ##Class(%Stream.FileCharacter).%New()
	Set tSDAXML.TranslateTable = "UTF8"
	Set tSC = pSDAContainer.ToQuickXMLStream(.tSDAXML)
	//$$$TRACE("tSDAXML Size: "_tSDAXML.Size)
	If $$$ISERR(tSC) Quit tSC
	
	//Sending to N targets
	For i=1:1:$Length(..SDATargetConfigName, ",")
	{
		Set tSDATarget = $Piece(..SDATargetConfigName,",",i)
		Set tRequest = ##class(Custom.EHRInterop.Core.Operation.SOAP.Operation.Request.SaveSDARequest).%New()

		Set tRequest.pRequest.InfoID = $ZSTRIP(pSendingFacility_"_"_pMRN_"_"_pEncounter_"_"_pEntityID_"_"_pEntityType, "*C")
		Set tRequest.pRequest.TransactionID = ..%SessionId
		
		Set tRequest.pRequest.ContentStream = tSDAXML
		
		Set tResponse = ##Class(Custom.EHRInterop.Core.Operation.SOAP.Operation.Response.SaveSDAResponse).%New()
		Set tSC = ..SendRequestSync(tSDATarget, tRequest, .tResponse)
		
		If $$$ISERR(tSC)
		
		If ('$ISOBJECT(tResponse))
		{
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Response Null")
		}
		
		If ('tResponse.SaveSDAResult.Success)
		{
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Execution error in EDGE process")
		}
	}
	
	Quit tSC
}

XData MessageMap
{
<MapItems>
	<MapItem MessageType="Custom.EHRInterop.Core.Msg.BuildSDARequest"> 
		<Method>EntityToSDA</Method>
	</MapItem>
</MapItems>
}

}
