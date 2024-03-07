#!/bin/bash

iris start iris quietly
iris terminal iris '##class(%SYSTEM.OBJ).Load("/mnt/src/Custom/EHRInterop/Setup.cls","c")'
iris terminal iris '##class(Custom.EHRInterop.Setup).Run()'
iris stop iris quietly
/tini -- /iris-main
