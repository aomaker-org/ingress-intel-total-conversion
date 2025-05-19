#!/bin/bash

# Script to build the Android mobile app with verbose logging.
# Version: build_fork_001
# Assumes it is run from the project root directory (e.g., ingress-intel-total-conversion/).

echo "Build script 'build_fork_001.sh' started..."

# Define directories
PROJECT_ROOT=$(pwd) # Current directory when script is run
MOBILE_DIR="mobile"
# Specific log directory for this script/version
LOG_DIR_RELATIVE="fek_wip/logs/build001"
LOG_DIR_ABSOLUTE="$PROJECT_ROOT/$LOG_DIR_RELATIVE"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR_ABSOLUTE"

# Define log file with timestamp within the specific log directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR_ABSOLUTE/build_$TIMESTAMP.log"

echo "----------------------------------------------------------------------"
echo "Project Root: $PROJECT_ROOT"
echo "Mobile App Directory: $PROJECT_ROOT/$MOBILE_DIR"
echo "Log file will be: $LOG_FILE"
echo "----------------------------------------------------------------------"

# Check if mobile directory exists
if [ ! -d "$MOBILE_DIR" ]; then
    echo "ERROR: Directory '$MOBILE_DIR' not found in '$PROJECT_ROOT'."
    echo "Please run this script from the root of the ingress-intel-total-conversion project."
    exit 1
fi

# Navigate to the mobile directory
echo "Changing directory to $MOBILE_DIR..."
cd "$MOBILE_DIR" || { echo "ERROR: Failed to change directory to '$MOBILE_DIR'."; exit 1; }

# Run the Gradle build command
echo "Running Gradle build command (output will be in console and logged to $LOG_FILE)..."
# Using 'tee' to see output in console AND write to log file
# The 'set -o pipefail' ensures that if gradlew fails, the script gets its non-zero exit code
set -o pipefail
./gradlew assembleDebug --info --stacktrace 2>&1 | tee "$LOG_FILE"
BUILD_STATUS=${PIPESTATUS[0]} # Get exit status of gradlew, not tee
set +o pipefail # Reset pipefail option

# Navigate back to the original directory
echo "Changing directory back to $PROJECT_ROOT..."
cd "$PROJECT_ROOT" || { echo "ERROR: Failed to change directory back to '$PROJECT_ROOT'."; exit 1; }

echo "----------------------------------------------------------------------"
if [ $BUILD_STATUS -eq 0 ]; then
    echo "BUILD SUCCESSFUL!"
    echo "Log file: $LOG_FILE"
else
    echo "BUILD FAILED (Exit Code: $BUILD_STATUS)."
    echo "Please check the log file for details: $LOG_FILE"
fi
echo "----------------------------------------------------------------------"

exit $BUILD_STATUS
