Class Custom.EHRInterop.DSP.Operation.BuildSDAOperation Extends (Ens.BusinessOperation, HS.HC.Util.Trace.Helper)
{

Parameter ADAPTER = "EnsLib.SQL.OutboundAdapter";

Property Adapter As EnsLib.SQL.OutboundAdapter;

Parameter INVOCATION = "Queue";

Property SendingFacility As %String [ Required ];

Property SOAPHost As Ens.DataType.ConfigName;

Property CodingStandard As %String [ Required ];

Parameter SETTINGS = "SendingFacility:Data,CodingStandard:Data,SOAPHost:Data";

Method EntityToSDA(pRequest As Custom.EHRInterop.Core.Msg.BuildSDARequest, Output pResponse As Ens.Response) As %Status
{
	// Setting Isolation Level to Uncommited Read
	#; Set tSQLIsolationLevel = "SET ISOLATION TO DIRTY READ WITH WARNING;"
	#; Set tSC = ..Adapter.ExecuteUpdate(.tCount, tSQLIsolationLevel)
	#; https://docs.intersystems.com/irisforhealthlatest/csp/docbook/DocBook.UI.Page.cls?KEY=RSQL_SETTRANSACTION
	Set tSC = $$$OK
	
	// EHRInterop processing parameters
	Set tPatientID = pRequest.PatientID
	Set tEncounterID = $ZSTRIP($ZSTRIP(pRequest.EncounterID, "<>W"), "*C")
	Set tEntityID = $ZSTRIP($ZSTRIP(pRequest.EntityID, "<>W"), "*C")
	Set tEntityTypes = $LISTFROMSTRING(pRequest.EntityType, ",")
	Set tEntityHTypes = $LISTFROMSTRING($REPLACE($REPLACE($REPLACE(pRequest.EntityType, "PAT", ","), "ENC", ","), ",,", ""), ",")
	Set tSendingFacility = ..SendingFacility
	Set tCodFacility = tSendingFacility
	Set tFacility = tSendingFacility
	Set tAction = "AddOrUpdate"
	Set:($LISTFIND(tEntityTypes,"MRG") > 0) tAction = "Merge"
	Set tCodingStandard = ..CodingStandard
	Set tFilterByEnc = (tEncounterID '= "")
	Set tFilterByPK = (tEntityID '= "")

	// EHRInterop parameters validation
	If (tPatientID = "") {
		Set tSC=$$$ERROR($$$EnsErrGeneral,"PatientID can not be NULL")
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
	If ($LISTFIND(tEntityTypes,"ENC") > 0) { Set tSC = ..EntityEncounters(.tSDAContainer,tFilterByEnc,tFilterByPK,tPatientID,tEncounterID,tCodingStandard) }
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
	
	//Sending it to HealthShare
	Set tSC = ..SendToHS(tSendingFacility, tSDAContainer, pRequest.PatientID, pRequest.EncounterID, pRequest.EntityID, pRequest.EntityType)
	$$$ThrowOnError(tSC)
	
	Quit $$$OK
}

Method EntityPatient(ByRef pSDAContainer As HS.SDA3.Container, pPatientID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLPatient = ##Class(Custom.EHRInterop.DSP.View.Patient).GetPatientByPat()
	$$$TRACE("PAT tSQL: "_tSQLPatient)
	Set tDT1 = $NOW()
	Set tSC = ..Adapter.ExecuteQuery(.tRSPatient, tSQLPatient, pPatientID)
	$$$ThrowOnError(tSC)
	
	Set tDT2 = $NOW()
	Set tI = 0
	If (tRSPatient.Next())
	{
		Set tI = tI+1
		Set tSC = ##Class(Custom.EHRInterop.DSP.DT.SDA3.Patient).Transform(tRSPatient, .tSDAPatient, pCodingStandard)
		$$$ThrowOnError(tSC)

		Set pSDAContainer.Patient = tSDAPatient
	}
	Else
	{
		Set tSC=$$$ERROR($$$EnsErrGeneral,"PatientID "_pPatientID_" did not return in HS_PATIENT")
		$$$ThrowOnError(tSC)
	}
	
	Set tDT3 = $NOW()
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("PAT Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("PAT", "Fetch") = $GET(^tMZ("PAT", "Fetch"))+tFetchDur
	Set ^tMZ("PAT", "Iterate") = $GET(^tMZ("PAT", "Iterate"))+tIterateDur
	Set ^tMZ("PAT", "Count") = $GET(^tMZ("PAT", "Count"))+tI
	
	Quit tSC
}

Method EntityEncounters(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	//Skip if EncounterId null BUT EntityId not null (otherwise it would generate all encounters from the patient)
	If ('pFilterByEnc && pFilterByPK)
	{
		$$$TRACE("SKIP ENC")
		Quit tSC
	}
	
	Set tSQLEncounters = ##Class(Custom.EHRInterop.DSP.View.Encounter).GetEncountersByPat(pFilterByEnc)
	$$$TRACE("ENC tSQL: "_tSQLEncounters)
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("ENC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("ENC", "Fetch") = $GET(^tMZ("ENC", "Fetch"))+tFetchDur
	Set ^tMZ("ENC", "Iterate") = $GET(^tMZ("ENC", "Iterate"))+tIterateDur
	Set ^tMZ("ENC", "Count") = $GET(^tMZ("ENC", "Count"))+tI
	
	Quit tSC
}

Method EntityDiagnoses(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLDiagnoses = ##Class(Custom.EHRInterop.DSP.View.Diagnosis).GetDiagnosesByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("DXG tSQL: "_tSQLDiagnoses)
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("DXG Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("DXG", "Fetch") = $GET(^tMZ("DXG", "Fetch"))+tFetchDur
	Set ^tMZ("DXG", "Iterate") = $GET(^tMZ("DXG", "Iterate"))+tIterateDur
	Set ^tMZ("DXG", "Count") = $GET(^tMZ("DXG", "Count"))+tI
	
	Quit tSC
}

Method EntityDocuments(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLDocuments = ##Class(Custom.EHRInterop.DSP.View.Document).GetDocumentsByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("DOC tSQL: "_tSQLDocuments)
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("DOC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("DOC", "Fetch") = $GET(^tMZ("DOC", "Fetch"))+tFetchDur
	Set ^tMZ("DOC", "Iterate") = $GET(^tMZ("DOC", "Iterate"))+tIterateDur
	Set ^tMZ("DOC", "Count") = $GET(^tMZ("DOC", "Count"))+tI
	
	Quit tSC
}

Method EntityObservations(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLObservations = ##Class(Custom.EHRInterop.DSP.View.Observation).GetObservationsByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("OBS tSQL: "_tSQLObservations)
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("OBS Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("OBS", "Fetch") = $GET(^tMZ("OBS", "Fetch"))+tFetchDur
	Set ^tMZ("OBS", "Iterate") = $GET(^tMZ("OBS", "Iterate"))+tIterateDur
	Set ^tMZ("OBS", "Count") = $GET(^tMZ("OBS", "Count"))+tI
	
	Quit tSC
}

Method EntityProcedures(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSQLProcedures = ##Class(Custom.EHRInterop.DSP.View.Procedure).GetProceduresByPat(pFilterByEnc, pFilterByPK)
	$$$TRACE("PRC tSQL: "_tSQLProcedures)
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("PRC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("PRC", "Fetch") = $GET(^tMZ("PRC", "Fetch"))+tFetchDur
	Set ^tMZ("PRC", "Iterate") = $GET(^tMZ("PRC", "Iterate"))+tIterateDur
	Set ^tMZ("PRC", "Count") = $GET(^tMZ("PRC", "Count"))+tI
	
	Quit tSC
}

Method EntitySocialHistories(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("SOC Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("SOC", "Fetch") = $GET(^tMZ("SOC", "Fetch"))+tFetchDur
	Set ^tMZ("SOC", "Iterate") = $GET(^tMZ("SOC", "Iterate"))+tIterateDur
	Set ^tMZ("SOC", "Count") = $GET(^tMZ("SOC", "Count"))+tI
	
	Quit tSC
}

Method EntityIllnessHistories(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("ILL Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("ILL", "Fetch") = $GET(^tMZ("ILL", "Fetch"))+tFetchDur
	Set ^tMZ("ILL", "Iterate") = $GET(^tMZ("ILL", "Iterate"))+tIterateDur
	Set ^tMZ("ILL", "Count") = $GET(^tMZ("ILL", "Count"))+tI
	
	Quit tSC
}

Method EntityFamilyHistories(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("FAM Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("FAM", "Fetch") = $GET(^tMZ("FAM", "Fetch"))+tFetchDur
	Set ^tMZ("FAM", "Iterate") = $GET(^tMZ("FAM", "Iterate"))+tIterateDur
	Set ^tMZ("FAM", "Count") = $GET(^tMZ("FAM", "Count"))+tI
	
	Quit tSC
}

Method EntityRadOrders(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("RAD Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("RAD", "Fetch") = $GET(^tMZ("RAD", "Fetch"))+tFetchDur
	Set ^tMZ("RAD", "Iterate") = $GET(^tMZ("RAD", "Iterate"))+tIterateDur
	Set ^tMZ("RAD", "Count") = $GET(^tMZ("RAD", "Count"))+tI
	
	Quit tSC
}

Method EntityLabOrders(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("LAB Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("LAB", "Fetch") = $GET(^tMZ("LAB", "Fetch"))+tFetchDur
	Set ^tMZ("LAB", "Iterate") = $GET(^tMZ("LAB", "Iterate"))+tIterateDur
	Set ^tMZ("LAB", "Count") = $GET(^tMZ("LAB", "Count"))+tI
		
	Quit tSC
}

Method EntityOtherOrders(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("OTH Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("OTH", "Fetch") = $GET(^tMZ("OTH", "Fetch"))+tFetchDur
	Set ^tMZ("OTH", "Iterate") = $GET(^tMZ("OTH", "Iterate"))+tIterateDur
	Set ^tMZ("OTH", "Count") = $GET(^tMZ("OTH", "Count"))+tI
		
	Quit tSC
}

Method EntityMedications(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("MED Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("MED", "Fetch") = $GET(^tMZ("MED", "Fetch"))+tFetchDur
	Set ^tMZ("MED", "Iterate") = $GET(^tMZ("MED", "Iterate"))+tIterateDur
	Set ^tMZ("MED", "Count") = $GET(^tMZ("MED", "Count"))+tI
		
	Quit tSC
}

Method EntityAppointments(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("APT Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("APT", "Fetch") = $GET(^tMZ("APT", "Fetch"))+tFetchDur
	Set ^tMZ("APT", "Iterate") = $GET(^tMZ("APT", "Iterate"))+tIterateDur
	Set ^tMZ("APT", "Count") = $GET(^tMZ("APT", "Count"))+tI
		
	Quit tSC
}

Method EntityAlerts(ByRef pSDAContainer As HS.SDA3.Container, pFilterByEnc As %String, pFilterByPK As %String, pPatientID As %String, pEncounterID As %String, pEntityID As %String, pCodingStandard As %String) As %Status
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
	
	Set tFetchDur = $SYSTEM.SQL.DATEDIFF("ms",tDT1,tDT2)
	Set tIterateDur = $SYSTEM.SQL.DATEDIFF("ms",tDT2,tDT3)
	$$$TRACE("ALT Timestamps: Fetch: "_tFetchDur_"ms; Iterate: "_tIterateDur_"ms; Count: "_tI)
	Set ^tMZ("ALT", "Fetch") = $GET(^tMZ("ALT", "Fetch"))+tFetchDur
	Set ^tMZ("ALT", "Iterate") = $GET(^tMZ("ALT", "Iterate"))+tIterateDur
	Set ^tMZ("ALT", "Count") = $GET(^tMZ("ALT", "Count"))+tI
	
	Quit tSC
}

Method SendToHS(pSendingFacility As %String, pSDAContainer As HS.SDA3.Container, pMRN As %String, pEncounter As %String, pEntityID As %String, pEntityType As %String) As %Status
{
	Set tSC = $$$OK
	
	Set tSDAXML = ##Class(%Stream.FileCharacter).%New()
	Set tSDAXML.TranslateTable = "UTF8"
	Set tSC = pSDAContainer.ToQuickXMLStream(.tSDAXML)
	$$$LOGINFO("tSDAXML Size: "_tSDAXML.Size) // Can be Removed;
	If $$$ISERR(tSC) Quit tSC
	
	//Sending to HS by SOAP
	If (..SOAPHost '= "")
	{
		Set tRequest = ##class(Custom.EHRInterop.Core.Operation.SOAP.Operation.Request.SaveSDARequest).%New()

		Set tRequest.pRequest.InfoID = $ZSTRIP(pSendingFacility_"_"_pMRN_"_"_pEncounter_"_"_pEntityID_"_"_pEntityType, "*C")
		Set tRequest.pRequest.TransactionID = ..%SessionId
		
		Set tRequest.pRequest.ContentStream = tSDAXML
		
		Set tResponse = ##Class(Custom.EHRInterop.Core.Operation.SOAP.Operation.Response.SaveSDAResponse).%New()
		Set tSC = ..SendRequestSync(..SOAPHost, tRequest, .tResponse)
		
		If $$$ISERR(tSC) Quit tSC
		
		If ('$ISOBJECT(tResponse))
		{
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Response Null")
			Quit tSC
		}
		
		If ('tResponse.SaveSDAResult.Success)
		{
			Set tSC=$$$ERROR($$$EnsErrGeneral,"Execution error in EDGE process")
			Quit tSC
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
