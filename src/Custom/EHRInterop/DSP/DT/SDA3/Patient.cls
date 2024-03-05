Class Custom.EHRInterop.DSP.DT.SDA3.Patient Extends (Ens.DataTransform, Custom.EHRInterop.Core.Util.SDA3)
{

ClassMethod Transform(pSource As %ResultSet, Output target As HS.SDA3.Patient, pCodingStandard As %String) As %Status
{
	Set tSC = $$$OK

    Set tSC = ..ToDynamicObj(pSource, .tSource)
	$$$ThrowOnError(tSC)
	
    Set target = ##class(HS.SDA3.Patient).%New()
    
    Set tSDA3Name = ""
    Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.Name).Transform(pSource, .tSDA3Name, "PAT_NAM")
    $$$ThrowOnError(tSC)

    If ($IsObject(tSDA3Name))
    {
        Set target.Name = tSDA3Name
    }

    Set target.MothersMaidenName = $Extract(tSource.%Get("PAT_MOT"),1,50)
    
    //Zagatti, 23-11-07: removed because it was generating a wrong fullname (family + first with PAT_ALI)
    /*Set tSDA3Alias = ""
    Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.Name).Transform(tSource, .tSDA3Alias, "PAT_ALI")
    $$$ThrowOnError(tSC)
    
    If ($IsObject(tSDA3Alias))
    {
        Set tSC = target.Aliases.Insert(tSDA3Alias)
        $$$ThrowOnError(tSC)
    }*/
    
    //Set target.PrimaryLanguage = ..CodeTable("Language","PT","Portuguese")
    
    Set target.Religion = ..CodeTable("Religion", tSource.%Get("PAT_REL_DSC"), tSource.%Get("PAT_REL_DSC"))
    Set target.MaritalStatus = ..CodeTable("MaritalStatus", tSource.%Get("PAT_CIV_DSC"), tSource.%Get("PAT_CIV_DSC"))
    Set target.Gender = ..CodeTable("Gender", tSource.%Get("PAT_GEN"), tSource.%Get("PAT_GEN"))
    Set target.Race = ..CodeTable("Race", tSource.%Get("PAT_RAC_DSC"),tSource.%Get("PAT_RAC_DSC"))
    Set target.Citizenship = ..CodeTable("Citizenship", tSource.%Get("PAT_NTL_DSC"),tSource.%Get("PAT_NTL_DSC"))
    
    
    If (tSource.%Get("PAT_BIR_DAT")'="")
    {
        Set target.BirthTime = tSource.%Get("PAT_BIR_DAT")_"T00:00:00"
    }
    
    If (tSource.%Get("PAT_FAT")'="")
    {
        Set tSDA3SupportContact = ""
        Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.Contact).Transform(pSource, .tSDA3SupportContact, "PAT_FAT", "Father")
        $$$ThrowOnError(tSC)
        
        If ($IsObject(tSDA3SupportContact))
        {
            Set tSC = target.SupportContacts.Insert(tSDA3SupportContact)
            $$$ThrowOnError(tSC)
        }
    }
    
    If (tSource.%Get("PAT_CPL")'="")
    {
        Set tSDA3SupportContact = ""
        Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.Contact).Transform(pSource, .tSDA3SupportContact, "PAT_CPL", "Spouse")
        $$$ThrowOnError(tSC)
        
        If ($IsObject(tSDA3SupportContact))
        {
            Set tSC = target.SupportContacts.Insert(tSDA3SupportContact)
            $$$ThrowOnError(tSC)
        }
    }

    If (tSource.%Get("PAT_DTH_DAT")'="")
    {
        Set target.DeathTime = tSource.%Get("PAT_DTH_DAT")_"T00:00:00"
        Set target.IsDead = 1
        
        If (tSource.%Get("PAT_DTH_LOC") '= "")
        {
            Set target.DeathLocation = tSource.%Get("PAT_DTH_LOC")
        }
    }
    
    If (tSource.%Get("PAT_SSN") '= "")
    {
        Set tSDA3PatientNumber = ""
        Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.PatientNumber).Transform(pSource, .tSDA3PatientNumber, "PAT_SSN", "SSN", "SSN", "SSN")
        $$$ThrowOnError(tSC)

        If ($IsObject(tSDA3PatientNumber))
        {
            Set tSC = target.PatientNumbers.Insert(tSDA3PatientNumber)
            $$$ThrowOnError(tSC)
        }
    }

    If (tSource.%Get("PAT_DL") '= "") 
    {
        Set tSDA3PatientNumber = ""
        Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.PatientNumber).Transform(pSource, .tSDA3PatientNumber, "PAT_DL", "DL", "DL", "DL")
        $$$ThrowOnError(tSC)

        If ($IsObject(tSDA3PatientNumber))
        {
            Set tSC = target.PatientNumbers.Insert(tSDA3PatientNumber)
            $$$ThrowOnError(tSC)
        }
    }

    /*If ($ZSTRIP(tSource.%Get("CNS"),"*C") '= "") 
    {
        Set tSDA3PatientNumber = ""
        Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.PatientNumber).Transform(tSource, .tSDA3PatientNumber,"CNS","CNS","MS","Ministério da Saúde")
        $$$ThrowOnError(tSC)

        If ($IsObject(tSDA3PatientNumber))
        {
            Set tSC = target.PatientNumbers.Insert(tSDA3PatientNumber)
             $$$ThrowOnError(tSC)
        }
    }*/
    
    If (tSource.%Get("PAT_PK") '= "") 
    {
        Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.PatientNumber).Transform(pSource, .tSDA3PatientNumber, "PAT_PK", "MRN", pCodingStandard, pCodingStandard)
        $$$ThrowOnError(tSC)

        If ($IsObject(tSDA3PatientNumber))
        {
            Set tSC = target.PatientNumbers.Insert(tSDA3PatientNumber)
            $$$ThrowOnError(tSC)
        }
    }

    Set tSDA3Address = ""
    Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.Address).Transform(pSource, .tSDA3Address)
    $$$ThrowOnError(tSC)

    If ($IsObject(tSDA3Address))
    {
        Set tSC = target.Addresses.Insert(tSDA3Address)
        $$$ThrowOnError(tSC)
    }
    
    Set tSDA3ContactInfo = ""
    Set tSC = ##Class(Custom.EHRInterop.Core.DT.SDA3.ContactInformation).Transform(pSource, .tSDA3ContactInfo)
    $$$ThrowOnError(tSC)

    If ($IsObject(tSDA3ContactInfo))
    {
        Set target.ContactInfo = tSDA3ContactInfo
    }
	
	Quit tSC
}

}
