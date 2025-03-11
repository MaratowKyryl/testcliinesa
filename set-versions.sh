#!/bin/bash

# Fetch latest tags
git fetch --tags

# Get latest Git tag
LATEST_TAG=$(git describe --tags --abbrev=0)

# Extract user-facing version (e.g., 1.0.1) and code version (e.g., 403)
USER_VERSION=$(echo "$LATEST_TAG" | cut -d'-' -f1)
CODE_VERSION=$(echo "$LATEST_TAG" | cut -d'-' -f2)

# Paths to project files
ROUTE_TO_ANDROID_VERSIONS_FILE="android/app/build.gradle"
ROUTE_TO_IOS_VERSIONS_FILE="ios/Shkolo.xcodeproj/project.pbxproj"

echo "Applying latest Git tag: $LATEST_TAG"
echo "User Version: $USER_VERSION"
echo "Code Version: $CODE_VERSION"

# Update iOS project versioning
sed -i "s/CURRENT_PROJECT_VERSION = [[:digit:]]*/CURRENT_PROJECT_VERSION = $CODE_VERSION/g" "$ROUTE_TO_IOS_VERSIONS_FILE"
sed -i "s/MARKETING_VERSION = [[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*/MARKETING_VERSION = $USER_VERSION/g" "$ROUTE_TO_IOS_VERSIONS_FILE"

# Update Android project versioning
sed -i "s/versionCode [[:digit:]]*/versionCode $CODE_VERSION/g" "$ROUTE_TO_ANDROID_VERSIONS_FILE"
sed -i "s/versionName \"[[:digit:]]*\.[[:digit:]]*\.[[:digit:]]*\"/versionName \"$USER_VERSION\"/g" "$ROUTE_TO_ANDROID_VERSIONS_FILE"

echo "Updated Android and iOS files successfully!"
