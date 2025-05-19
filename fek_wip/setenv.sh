#!/bin/bash
#
# Project Environment Setup Script (fek_wip/setenv.sh)
#
# This script is intended to be SOURCED, not executed directly.
# Usage: . ./fek_wip/setenv.sh  OR  source ./fek_wip/setenv.sh
#
# It sets up project-specific environment variables, modifies PATH,
# and defines helpful aliases.
# An OLD_PATH variable is saved to allow manual restoration if needed.

echo "Setting up project environment from setenv.sh..."

# --- PATH Management ---
# Store the original PATH if this is the first time sourcing this session
if [ -z "$_SETENV_SOURCED_ONCE" ]; then
    export OLD_PATH="$PATH"
    export _SETENV_SOURCED_ONCE="true"
    echo "Original PATH saved to OLD_PATH."
else
    echo "PATH was previously modified by setenv.sh. Using originally saved OLD_PATH for restoration reference."
fi

# --- Project Directory Definitions ---
# Determine the script's own directory to reliably find the project root
# BASH_SOURCE[0] is the path to the script itself.
_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)"

# Assume this script (setenv.sh) is in fek_wip/, which is at the project root.
export PROJECT_ROOT="$(cd "$_SCRIPT_DIR/.." &> /dev/null && pwd)"
export FEK_WIP_DIR="$PROJECT_ROOT/fek_wip"

# --- Modify PATH ---
# Add fek_wip directory to the beginning of PATH
# This allows running scripts from fek_wip directly by name if they are executable
# and are located directly in fek_wip (not subdirectories).
# If build_fork_002.sh is in fek_wip, it could be called as 'build_fork_002.sh'
# after sourcing and making it executable.
echo "Prepending $FEK_WIP_DIR to PATH."
export PATH="$FEK_WIP_DIR:$PATH"

# --- Aliases ---
# Define project-specific aliases here
# The alias will execute the build_fork.sh script assumed to be in $FEK_WIP_DIR
BUILD_SCRIPT_PATH="$FEK_WIP_DIR/build_fork.sh"

if [ -f "$BUILD_SCRIPT_PATH" ]; then
    if [ ! -x "$BUILD_SCRIPT_PATH" ]; then
        echo "WARNING: Build script '$BUILD_SCRIPT_PATH' is not executable. Please run 'chmod +x $BUILD_SCRIPT_PATH'."
    fi
    alias buildfek="$BUILD_SCRIPT_PATH"
    echo "Alias created: 'buildfek' will run '$BUILD_SCRIPT_PATH'"
else
    echo "WARNING: Script '$BUILD_SCRIPT_PATH' not found. Alias 'buildfek' not created."
    echo "Make sure you have created 'build_fork_002.sh' in '$FEK_WIP_DIR'."
fi

# --- Other Useful Environment Variables (Examples - Customize as needed) ---
# You might want to set these if they aren't globally configured or if you need
# project-specific overrides. The gradle.properties sets org.gradle.java.home for Gradle.

# Example: Android SDK Root (ensure this matches your setup if you uncomment)
# export ANDROID_SDK_ROOT="$HOME/Android/sdk"
# echo "  ANDROID_SDK_ROOT (example) set to: $ANDROID_SDK_ROOT"

# Example: Specific Java Home (ensure this matches your setup if you uncomment)
# export JAVA_HOME="/usr/lib/jvm/java-21-openjdk-amd64"
# echo "  JAVA_HOME (example) set to: $JAVA_HOME"

# --- Final Messages ---
echo ""
echo "Project environment configured:"
echo "  PROJECT_ROOT:     $PROJECT_ROOT"
echo "  FEK_WIP_DIR:      $FEK_WIP_DIR"
echo "  PATH updated."
echo ""
echo "To restore PATH to its state before sourcing this script (in this terminal session):"
echo "  export PATH=\"\$OLD_PATH\""
echo "  unset _SETENV_SOURCED_ONCE" # Optional: allow re-saving OLD_PATH on next source
echo ""
echo "Remember to source this script: . fek_wip/setenv.sh"
echo "If the alias 'buildfek' was created, you can use it to run the build."
