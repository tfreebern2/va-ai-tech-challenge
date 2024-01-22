#!/bin/bash

# Check licenses
if [[ "$(uname -s)" =~ MINGW|MSYS ]]; then
    lic_ck.bat check-licenses --config license_config.yaml

    ## Static Code Analysis
    flutter analyze
    ### Run tests
    flutter test
else
    lic_ck check-licenses --config license_config.yaml

    ## Static Code Analysis
    fvm flutter analyze
    ### Run tests
    fvm flutter test
fi
