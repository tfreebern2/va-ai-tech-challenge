#!/bin/bash

# Check licenses
if [[ "$(uname -s)" =~ MINGW|MSYS ]]; then
    lic_ck.bat check-licenses --config license_config.yaml
else
    lic_ck check-licenses --config license_config.yaml
fi

# Static Code Analysis
ANALYZE_OUTPUT=""
if [[ "$(uname -s)" =~ MINGW|MSYS ]]; then
    ANALYZE_OUTPUT=$(flutter analyze)
else
    ANALYZE_OUTPUT=$(fvm flutter analyze)
fi

echo "$ANALYZE_OUTPUT"

# Check if there are any issues found by Flutter analyze
if echo "$ANALYZE_OUTPUT" | grep -q "info •"; then
    echo "Analysis found issues."
    exit 1
fi

# Run tests
if [[ "$(uname -s)" =~ MINGW|MSYS ]]; then
    flutter test
else
    fvm flutter test
fi
