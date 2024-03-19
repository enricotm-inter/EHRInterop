Class Custom.EHRInterop.Setup Extends %RegisteredObject
{

/// Run this method to set up the IRIS environment
ClassMethod Run() As %Status
{
    Set tSC = $$$OK
    Set ns = "EHRINTEROP"
    Set user = "ehrinterop_client"
    Do CreateNamespace(ns)
    Set $NAMESPACE=ns
    Do CreateUser(user)
    Do CreateSQLGateway(ns, user)
    Do CreateForeignTables()
    Do CompileClasses()
    Return tSC
}

ClassMethod CreateNamespace(ns As %String) As %Status
{
    Set tSC = $$$OK
    New $NAMESPACE
    Set $NAMESPACE="%SYS"
    Set tStatement = ##class(%SQL.Statement).%New()
    Set query = "CREATE DATABASE "_ns
    Set tSC = tStatement.%Prepare(query)
    Set tRS = tStatement.%Execute()
    Set db = ##class(Config.Namespaces).Open(ns)
    Set db.Interop = 1
    Set tSC = db.%Save()
    Return tSC
}

ClassMethod CreateUser(user As %String) As %Status
{
    Set tSC = $$$OK
    Set tStatement = ##class(%SQL.Statement).%New()
    Set queryCreate = "CREATE USER "_user_" IDENTIFIED BY 1010"
    Set tSC = tStatement.%Prepare(queryCreate)
    Set tRS = tStatement.%Execute()
    Set queryGrant = "GRANT %All TO "_user
    Set tSC = tStatement.%Prepare(queryGrant)
    Set tRS = tStatement.%Execute()
    Return tSC
}

ClassMethod CreateSQLGateway(ns As %String, user As %String) As %Status
{
    Set tSC = $$$OK
    Set tSC = ##class(Ens.Config.Credentials).SetCredential("irisJDBC", user, "1010")
    Set tStatement = ##class(%SQL.Statement).%New()
    Set query = "INSERT INTO %Library.sys_SQLConnection "_
                "(Connection_Name, URL, Usr, driver, isJDBC, useCOALESCE, ReverseOJ, bUnicodeStream, bindTSasString, needlongdatalen, nodefq, nofnconv, nvl, useCAST, useCASTCHAR) "_
                "VALUES ('irisJDBC', 'jdbc:IRIS://localhost:1972/"_ns_"', '"_user_"', 'com.intersystems.jdbc.IRISDriver', 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0)"
    Set tSC = tStatement.%Prepare(query)
    Set tRS = tStatement.%Execute()
    Return tSC
}

ClassMethod CreateForeignTables() As %Status
{
    Set tSC = $$$OK
    #; Read the sql script
    Set sqlPath = "/mnt/query.sql"
    Set samplesPath = "/mnt/Samples"
    Set sqlFile = ##class(%File).%New(sqlPath)
    Set tSC = sqlFile.Open("RU")
    $$$ThrowOnError(tSC)
    Set sqlTxt = sqlFile.Read(.sqlLen, .tSC)

    #; Run the sql queries
    Set queries = $LFS(sqlTxt, "GO")
    Write !, "Running "_$LL(queries)_" queries..."
    Set tStatement = ##class(%SQL.Statement).%New()

    Set ptr = 0, errs = 0
    While $LISTNEXT(queries, ptr, query) {
        Write !, query
        Set tSC = tStatement.%Prepare(query)
        $$$ThrowOnError(tSC)
        Set tRS = tStatement.%Execute()
        Set:(tRS.%SQLCODE) errs = errs + 1
        Do tRS.%Display()
    }

    #; Output summary
    Write !, !, "Queries",
        !, "..........Errors: ", errs,
        !, "......Successful: ", $LL(queries)-errs,
        !, !
    Return tSC
}

ClassMethod CompileClasses() As %Status
{
    Set tSC = $$$OK
    Set srcPath = "/mnt/src"
    Write !, "Compiling classes on '"_srcPath_"...", !
    Set tSC = $SYSTEM.OBJ.ImportDir(srcPath,"","c",,1)
    Return tSC
}

}
