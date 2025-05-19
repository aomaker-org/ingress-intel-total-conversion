#!/bin/bash

# Script to build the Android mobile app with verbose logging.
# Version: build_fork_001
# Assumes it is run from the project root directory (e.g., ingress-intel-total-conversion/).

echo "Build script 'build_fork_001.sh' started..."

# Define directories
# Use PROJECT_ROOT if set by setenv.sh, otherwise assume current directory
# This allows the script to be run even if setenv.sh hasn't been sourced,
# but it's more robust if PROJECT_ROOT is correctly set by sourcing setenv.sh.
CURRENT_DIR_AS_ROOT=$(pwd)
EFFECTIVE_PROJECT_ROOT="${PROJECT_ROOT:-$CURRENT_DIR_AS_ROOT}"

MOBILE_DIR_NAME="mobile" # Just the directory name
MOBILE_DIR_PATH="$EFFECTIVE_PROJECT_ROOT/$MOBILE_DIR_NAME"

# Specific log directory for this script/version
LOG_DIR_RELATIVE="fek_wip/logs/build001"
LOG_DIR_ABSOLUTE="$EFFECTIVE_PROJECT_ROOT/$LOG_DIR_RELATIVE"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR_ABSOLUTE"

# Define log file with timestamp within the specific log directory
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
LOG_FILE="$LOG_DIR_ABSOLUTE/build_$TIMESTAMP.log"

echo "----------------------------------------------------------------------"
echo "Project Root (effective): $EFFECTIVE_PROJECT_ROOT"
echo "Mobile App Directory: $MOBILE_DIR_PATH"
echo "Log file will be: $LOG_FILE"
echo "----------------------------------------------------------------------"

# Check if mobile directory exists
if [ ! -d "$MOBILE_DIR_PATH" ]; then
    echo "ERROR: Directory '$MOBILE_DIR_PATH' not found."
    echo "Please ensure PROJECT_ROOT is set correctly (e.g., by sourcing setenv.sh)"
    echo "or run this script from the root of the ingress-intel-total-conversion project."
    exit 1
fi

# Navigate to the mobile directory
echo "Changing directory to $MOBILE_DIR_PATH..."
cd "$MOBILE_DIR_PATH" || { echo "ERROR: Failed to change directory to '$MOBILE_DIR_PATH'."; exit 1; }

# Run the Gradle build command
echo "Running Gradle build command (output will be in console and logged to $LOG_FILE)..."
# Using 'tee' to see output in console AND write to log file
# The 'set -o pipefail' ensures that if gradlew fails, the script gets its non-zero exit code
set -o pipefail
./gradlew assembleDebug --info --stacktrace 2>&1 | tee "$LOG_FILE"
BUILD_STATUS=${PIPESTATUS[0]} # Get exit status of gradlew, not tee
set +o pipefail # Reset pipefail option

# Navigate back to the original (effective project root) directory
echo "Changing directory back to $EFFECTIVE_PROJECT_ROOT..."
cd "$EFFECTIVE_PROJECT_ROOT" || { echo "ERROR: Failed to change directory back to '$EFFECTIVE_PROJECT_ROOT'."; exit 1; }

echo "----------------------------------------------------------------------"
if [ $BUILD_STATUS -eq 0 ]; then
    echo "BUILD SUCCESSFUL!"
    echo "Log file: $LOG_FILE"
else
    echo "BUILD FAILED (Exit Code: $BUILD_STATUS)."
    echo "Please check the log file for details: $LOG_FILE"
fi
echo "----------------------------------------------------------------------"

# Attempt to copy log file content to Windows clipboard using clip.exe
if command -v clip.exe &> /dev/null; then
    if [ -f "$LOG_FILE" ]; then
        echo "Attempting to copy log file content to Windows clipboard..."
        cat "$LOG_FILE" | clip.exe
        if [ $? -eq 0 ]; then
            echo "Log file content copied to clipboard."
        else
            echo "WARNING: Failed to copy log file content to clipboard using clip.exe."
            # Provide alternative way to access the log for Windows users
            WIN_LOG_PATH_APPROXIMATE=$(wslpath -w "$LOG_FILE" 2>/dev/null || echo "N/A (wslpath failed)")
            echo "You can access the log file at WSL path: $LOG_FILE"
            echo "Or from Windows at (if wslpath worked): $WIN_LOG_PATH_APPROXIMATE"
        fi
    else
        echo "WARNING: Log file '$LOG_FILE' not found. Cannot copy to clipboard."
    fi
else
    echo "INFO: clip.exe not found. Skipping clipboard copy."
    echo "Log file is available at: $LOG_FILE"
fi
echo "----------------------------------------------------------------------"

exit $BUILD_STATUS
