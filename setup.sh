#!/bin/bash

# Start the iris instance with custom cpf file
ISC_CPF_MERGE_FILE=/mnt/merge.cpf iris start iris quietly
# Compile all classes and create Foreign Tables
iris terminal iris '##class(%SYSTEM.OBJ).Load("/mnt/src/Custom/EHRInterop/Setup.cls","c")'
iris terminal iris '##class(Custom.EHRInterop.Setup).Run()'
# Stop the iris instance
iris stop iris quietly