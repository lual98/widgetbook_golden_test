#!/bin/bash

# Extracts the latest release section from CHANGELOG.md for all packages
# and combines them into LATEST_CHANGELOG.md

OUTPUT_FILE="LATEST_CHANGELOG.md"
rm -f $OUTPUT_FILE

for pkg in packages/*; do
  if [ -f "$pkg/CHANGELOG.md" ]; then
    pkg_name=$(basename "$pkg")
    
    # Extract the latest section
    # We look for the first header starting with ## and take everything until the next one or end of file
    section=$(awk '
      /^## / {
        if (found) exit;
        found=1;
      }
      found { print }
    ' "$pkg/CHANGELOG.md")

    if [ ! -z "$section" ]; then
      echo "### $pkg_name" >> $OUTPUT_FILE
      echo "" >> $OUTPUT_FILE
      # We skip the first line of the section because it's the version header (## 1.2.3)
      # which is redundant if we are releasing all together.
      echo "$section" | tail -n +2 >> $OUTPUT_FILE
      echo "" >> $OUTPUT_FILE
    fi
  fi
done