Class Custom.EHRInterop.Setup Extends %RegisteredObject
{

/// Run this method to set up your IRIS environment
ClassMethod Run(compile As %Boolean = 1, sql As %Boolean = 1, mount As %Boolean = 1) As %Status
{
    Set tSC = $$$OK
    Set $NAMESPACE="EHRINTEROP"
    Do:(compile) CompileClasses()
    Do:(sql) CreateForeignTables()
    Do:(mount) MountNamespace()
    Return tSC
}

ClassMethod MountNamespace() As %Status
{
    Set tSC = $$$OK
    New $NAMESPACE
    Set $NAMESPACE="%SYS"
    Set db = ##class(SYS.Database).%New()
    Set db.Directory = "/usr/irissys/mgr/EHRINTEROP"
    Set tSC = db.%Save()
    Do db.Mount()
    Return tSC
}

ClassMethod CompileClasses() As %Status
{
    Set tSC = $$$OK
    #; Import and compile all of the classes
    Set srcPath = "/mnt/src"
    Write !, "Compiling classes on '"_srcPath_"...", !
    Set tSC = $SYSTEM.OBJ.ImportDir(srcPath,"","c",,1)
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
    write !, "Running "_$LL(queries)_" queries..."
    set tStatement = ##class(%SQL.Statement).%New()

    Set ptr = 0, errs = 0
    While $LISTNEXT(queries, ptr, query) {
        write !, query
        set tSC = tStatement.%Prepare(query)
        $$$ThrowOnError(tSC)
        set tRS = tStatement.%Execute()
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

}
