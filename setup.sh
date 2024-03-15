#!/bin/bash

# Compile all classes and create Foreign Tables
iris terminal iris '##class(%SYSTEM.OBJ).Load("/mnt/src/Custom/EHRInterop/Setup.cls","c")'
iris terminal iris '##class(Custom.EHRInterop.Setup).Run()'