Class HSCUSTOM.EHRInterop.RunMe Extends %RegisteredObject
{

/// Run this method to set up your IRIS environment
ClassMethod Run(compile As %Boolean = 1, sql As %Boolean = 1) As %Status
{
    Set tSC = $$$OK

    #; Set root directory path
    Set dirPath = "/mnt"

    If (compile) {
        #; Import and compile all of the classes
        Set srcPath = dirPath_"/src"
        Write !, "Compiling classes on '"_srcPath_"...", !
        Set tSC = $SYSTEM.OBJ.ImportDir(srcPath,"","c",,1)
    }

    If (sql) {
        #; Read the sql script
        Set sqlPath = dirPath_"/ForeignTable/scriptFTs.sql"
        Set samplesPath = dirPath_"/ForeignTable/Samples"
        Set sqlFile = ##class(%File).%New(sqlPath)
        Set tSC = sqlFile.Open("RU")
        $$$ThrowOnError(tSC)
        Set sqlTxt = sqlFile.Read(.sqlLen, .tSC)
        Set sqlTxt = $REPLACE(sqlTxt, "samplesPathPlaceholder", samplesPath)

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
    }
    
    Return tSC
}

}
