/// Custom.KPI.TriggerTime
Class Custom.EHRInterop.Core.KPI.TriggerTime Extends %DeepSee.KPI [ Language = objectscript ]
{

Parameter DOMAIN;

Parameter RESOURCE;

/// Este bloco de definição XData define o KPI.
XData KPI [ XMLNamespace = "http://www.intersystems.com/deepsee/kpi" ]
{
<kpi xmlns="http://www.intersystems.com/deepsee/kpi"
 name="EHRInterop.KPI.TriggerTime" sourceType="manual"
 caption=""
>
<property name="TriggerName" displayName="Trigger Name"/>
<property name="UpperDate" displayName="Upper Date"/>
<!--property name="LastKey" displayName="LastKey"/-->
<property name="MinutesSinceLastExec" displayName="Minutes Since Last Exec"/>
<filter name="Category" displayName="Category" valueList="TASY,HCBC,MVSANTANA,MVSALVALUS,GESTHOS,CLINIPAM" displayList="TASY CORP,HCBC,MV SANTANA,MV SALVALUS,GESTHOS,TASY CLINIPAM" multiSelect="false"/>
</kpi>
}

/// Notification that this KPI is being executed.
/// This is a good place to override properties, such as range and threshold.
Method %OnLoadKPI() As %Status
{
	Set category = ""
	Try 
	{
		Set filter = ..%filterValues
		
		If (filter.Category'="")
		{
			Set category = filter.Category
		}
		
		If (category'="")
		{
			Do ..ConsultarDados(category)
		}
		
	}
	Catch e {
	}
	
	Quit $$$OK
}

/// This callback is invoked from a dashboard when an action defined by this dashboard is invoked.
ClassMethod %OnDashboardAction(pAction As %String, pContext As %ZEN.proxyObject) As %Status
{
	// pAction is the name of the action (as defined in the XML list).
	// pContext contains information from the client
	// and can be used to return information.
	Quit $$$OK
}

Method %OnExecute() As %Status
{
	Do ..ConsultarDados("")
	
    Quit $$$OK
}

Method ConsultarDados(pCategory As %String) As %Status
{
	Try
	{
		Set tTrigger = ""
		Set ..%seriesCount= 0
		
		For
		{
			Set tTrigger = $O(^Ens.AppData(tTrigger))
			Quit:tTrigger=""
			
			Continue:tTrigger["FULL"
			
			Continue:tTrigger["ByPat"
			
			Continue:tTrigger["Treinamento"
			
			Continue:tTrigger["Test"
			
			If (pCategory'="")
			{
				Set tTriggerName=""
				
				Set tTriggerName = $Piece(tTrigger," ",1)
				
				If (tTriggerName'="")
				{
					Set pCategory		= $ZConvert(pCategory,"U")
					Set tTriggerName	= $ZConvert(tTriggerName,"U")
					
					Continue:tTriggerName'=pCategory
				}
			}
			
			Set tType=""
			For
			{
				Set tType = $O(^Ens.AppData(tTrigger,tType))
				Quit:tType=""
				
				
				If (tType = "adapter.sqlparam")
				{
					Set (tUpperDate,tLastKey,tMinutes)=""
					
					If ($Data(^Ens.AppData(tTrigger,"adapter.sqlparam","UpperDate"))=1)
					{
						Set tUpperDate = ^Ens.AppData(tTrigger,"adapter.sqlparam","UpperDate")
						
						Set tMinutes = $System.SQL.DATEDIFF("mi",tUpperDate,$SYSTEM.SQL.DATEADD("hh","0",$NOW()))
					}
					
					If ($Data(^Ens.AppData(tTrigger,"adapter.sqlparam","%LastKey"))=1)
					{
						Set tLastKey = ^Ens.AppData(tTrigger,"adapter.sqlparam","%LastKey")
					}
				}
				Else
				{
					Continue
				}
				
				Set ..%seriesCount=..%seriesCount+1
		    
			    Set ..%data(..%seriesCount,"TriggerName")=tTrigger
			    Set ..%data(..%seriesCount,"UpperDate")=tUpperDate
			    Set ..%data(..%seriesCount,"LastKey")=tLastKey
			    Set ..%data(..%seriesCount,"MinutesSinceLastExec")=tMinutes
			}
		}
	}
	Catch(e)
	{
	}
	
	Quit $$$OK
}

}
