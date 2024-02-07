# EHR Interop - Induction Kit


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
- **host:** The IRIS instance host IP _(Commonly: "localhost")_
- **port:** The IRIS instance host port _(Commonly: 52773)_
- **username:** The username to login into the IRIS instance
- **ns:** The namespace within the IRIS instance to use
- **active:** Whether or not the server is connected to the IRIS instance _(Must be set to `true`)_
