# Todo: Fix Android Build in Codespace

## Problem

The Android build for the `mobile` target is failing with the error: `SDK location not found`. This occurs during the Gradle configuration phase, specifically when trying to resolve dependencies for the `:app:compileDebugJavaWithJavac` task.

This error persists even after correctly configuring the Android SDK location via the two standard methods:
1.  Setting the `ANDROID_HOME` environment variable.
2.  Creating a `local.properties` file with the `sdk.dir` property.

## Environment Setup and Attempts to Fix

1.  **System:** GitHub Codespace.
2.  **Java:** Set to OpenJDK version 17.
3.  **Android SDK:**
    *   Downloaded the latest command-line tools (`commandlinetools-linux-11076708_latest.zip`).
    *   Installed into `/home/jules/android-sdk`.
    *   Used `sdkmanager` to install `platform-tools`, `platforms;android-33`, and `build-tools;33.0.1`.
    *   Accepted all SDK licenses using `sdkmanager --licenses`.
4.  **Configuration Attempts:**
    *   Set `ANDROID_HOME` and `ANDROID_SDK_ROOT` environment variables to `/home/jules/android-sdk`.
    *   Created `mobile/local.properties` with `sdk.dir=/home/jules/android-sdk`.
    *   Verified file permissions and paths are correct.
5.  **Troubleshooting:**
    *   Initialized the `mobile` git submodule.
    *   Ran Gradle with `--no-daemon` to avoid using a cached daemon.
    *   Cleaned the Gradle project (`./gradlew clean`) and deleted the `.gradle` directory.
    *   Used `strace` to confirm that `local.properties` is being read by the build process. `strace` also revealed an attempt to access a hardcoded path at `/usr/lib/android-sdk`, but creating a symlink there did not resolve the issue.
6.  **Dockerfile:**
    *   Created a `Dockerfile.iitc` to build the project in an isolated container.
    *   The Docker build failed with a `permission denied` error when trying to connect to the Docker daemon socket, indicating a lack of permissions to use Docker in the Codespace environment.

## Current Blocker

The build is blocked due to an unresolvable environment issue. The standard Android build process cannot find the SDK, and the Docker-based workaround is not feasible due to permissions.

## Next Steps

The user will investigate the Codespace environment to resolve the underlying issue preventing the build from finding the Android SDK.
