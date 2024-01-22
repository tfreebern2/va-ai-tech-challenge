#!/bin/bash

# Run dart fix and apply
dart fix --apply lib

# Run dart format only on staged files
staged_files=$(git diff --cached --name-only -- '*.dart')
if [ -n "$staged_files" ]; then
  echo "Formatting staged Dart files:"
  echo "$staged_files"
  dart format $staged_files
  git add $staged_files
fi
