#!/bin/bash

# Get latest Git tag
LATEST_TAG=$(git describe --tags --abbrev=0)
USER_VERSION=$(echo "$LATEST_TAG" | cut -d'-' -f1)  # Extract user version (1.0.1)
CODE_VERSION=$(echo "$LATEST_TAG" | cut -d'-' -f2)  # Extract code version (403)

# Increment the code version
CODE_VERSION=$((CODE_VERSION + 1))

# Parse user version components
IFS='.' read -r MAJOR MINOR PATCH <<< "$USER_VERSION"

# Increment patch number
PATCH=$((PATCH + 1))

# If patch reaches 10, reset to 0 and increment minor version
if [[ "$PATCH" -eq 10 ]]; then
  PATCH=0
  MINOR=$((MINOR + 1))
fi

NEW_USER_VERSION="$MAJOR.$MINOR.$PATCH"
NEW_CODE_VERSION=$CODE_VERSION

# Paths to project files
ROUTE_TO_ANDROID_VERSIONS_FILE="android/app/build.gradle"
ROUTE_TO_IOS_VERSIONS_FILE="ios/Shkolo.xcodeproj/project.pbxproj"

# Update iOS project versioning
sed -i "s/CURRENT_PROJECT_VERSION = [[:digit:]]*/CURRENT_PROJECT_VERSION = $NEW_CODE_VERSION/g" "$ROUTE_TO_IOS_VERSIONS_FILE"
sed -i "s/MARKETING_VERSION = [[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*/MARKETING_VERSION = $NEW_USER_VERSION/g" "$ROUTE_TO_IOS_VERSIONS_FILE"

# Update Android project versioning
sed -i "s/versionCode [[:digit:]]*/versionCode $NEW_CODE_VERSION/g" "$ROUTE_TO_ANDROID_VERSIONS_FILE"
sed -i "s/versionName \"[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\"/versionName \"$NEW_USER_VERSION\"/g" "$ROUTE_TO_ANDROID_VERSIONS_FILE"

echo "Updated versions:"
echo "User Version: $NEW_USER_VERSION"
echo "Code Version: $NEW_CODE_VERSION"
