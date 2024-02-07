# EHR Interop - Induction Kit

---
## Setting up `settings.json`

Rename the file inside `.vscode` from `settings.json.example` to `settings.json`  
```
└── .vscode
    └── settings.json
```
Change the respective values in `settings.json` so VS Code can connect to your IRIS instance
```
{
    "objectscript.conn": {
        "host": "localhost",
        "port": 52773,
        "username": "your-username",
        "ns": "your-namespace",
        "active": false,
    }
}
```
- **host:** The IRIS instance host IP *(Commonly: "localhost")*
- **port:** The IRIS instance host port *(Commonly: 52773)*
- **username:** The username to login into the IRIS instance
- **ns:** The namespace within the IRIS instance to use
- **active:** Whether or not the server is connected to the IRIS instance *(Must be set to `true`)*
  
For more information on how to configure a server inside VS Code, check the [documentation](https://docs.intersystems.com/components/csp/docbook/DocBook.UI.Page.cls?KEY=GVSCO_config#GVSCO_config_basics_settings).

---
## Running `RunMe.cls`


Compile the file `RunMe.cls` inside the folder `src/Custom/EHRInterop`
```
└── src
    └── Custom
        └── EHRInterop
            ...
            └── RunMe.cls
```

> ***DISCLAIMER:** This may be done only once. After compiling it for the first time, there is no need to redo it.*

After compiling it, open an IRIS Terminal and run the following command:
```
Do ##class(Custom.EHRInterop.RunMe).Run()
```

If everything was done successfully, a prompt should appear asking for the root path of the directory:
```
Give the full path for the root directory: 
```
> ***DISCLAIMER:** Make sure to give the **full** path of the directory, not just the relative one.*

After giving the path, it should compile all the other classes and run the necessary SQL statements to create the [Foreign Tables](https://docs.intersystems.com/supplychain20231/csp/docbook/Doc.View.cls?KEY=RSQL_createforeigntable) to all the csv files inside `ForeignTable/Samples`
```
[...]

Queries
..........Errors: 1
......Successful: 11
```
> ***DISCLAIMER:** It is expected to receive 1 query error the first time you run the command, due to the `DROP FOREIGN SERVER ...` statement.*

### If everything worked, the IRIS instance is ready for testing the EHR Interop Induction Kit!
