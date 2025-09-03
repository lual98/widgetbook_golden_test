#!/bin/bash

# Extracts the latest release section from CHANGELOG.md
# Usage: ./extract_latest_changelog.sh > LATEST_CHANGELOG.md

awk '
  /^## / {
    if (found) exit;
    if (!found) found=1;
  }
  found { print }
' CHANGELOG.md > LATEST_CHANGELOG.md