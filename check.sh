#!/bin/sh

# Fetch the latest changes
git fetch origin uat
git fetch origin main

# Check if there are any changes to merge
git diff --exit-code origin/uat..origin/main
if [ $? -eq 0 ]; then
  echo "No changes to merge. Skipping merge."
  exit 0
else
  # Proceed with the merge if changes are present
  echo "Changes detected. Merging develop into UAT."
fi
