#!/bin/bash

# Run dart fix and apply
dart fix --apply lib

# Run dart format only on staged files
staged_files=($(git diff --cached --name-only --relative -- '*.dart'))
formatted_files=()

for file in "${staged_files[@]}"; do
  # Check if the file exists before formatting
  if [ -e "$file" ]; then
    formatted_files+=("$file")
  else
    echo "Warning: File $file not found. Skipping formatting."
  fi
done

if [ ${#formatted_files[@]} -gt 0 ]; then
  echo "Formatting staged Dart files:"
  echo "${formatted_files[@]}"
  dart format "${formatted_files[@]}"
  git add "${formatted_files[@]}"
fi
