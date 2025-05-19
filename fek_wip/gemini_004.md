# Project Status Summary (fek_wip/gemini_004.md)

**Date:** 2025-05-19
**Current Local Repository:** `~/src/ingress-intel-total-conversion` (clone of `aomaker-org/ingress-intel-total-conversion`)
**Current Git Branch:** `fekerr-experiments`

## I. Repository & Branch Setup:
* **Fork:** The local repository is a clone of your fork located at `https://github.com/aomaker-org/ingress-intel-total-conversion.git`.
* **Remotes:**
    * `origin`: Correctly points to your fork (`git@github.com:aomaker-org/ingress-intel-total-conversion.git`).
    * `upstream`: Correctly points to the true original project (`git@github.com:IITC-CE/ingress-intel-total-conversion.git`).
* **Working Branch:** All work is being done on the local branch `fekerr-experiments`.

## II. Key Changes Applied to `fekerr-experiments`:
1.  **Patched Initial Build Changes:**
    * Generated a patch from commit `949921b...` (message: "changes, updates for first build") from an older, separate repository.
    * Successfully applied this patch using `git am`. This commit introduced:
        * Updates to `mobile/app/build.gradle` (SDK versions 35/23/35, Java 21, `buildConfig=true`, deprecation warning flags).
        * Updates to `mobile/build.gradle` (project-level: AGP 8.10.0, MavenCentral, deprecation warning flags).
        * Updates to `mobile/gradle.properties` (JDK home for Java 21).
        * Updates to `mobile/gradle/wrapper/gradle-wrapper.properties` (Gradle 8.11.1).
        * Changes to `mobile/app/src/main/AndroidManifest.xml` (added `android:exported="true"`).
        * Removal of NFC NDEF logic in `mobile/app/src/main/java/org/exarhteam/iitc_mobile/IITC_Mobile.java`.
        * Creation of placeholder `mobile/app/PUT_RELEASE_KEYSTORE_HERE`.
        * Creation of initial doc files `mobile/gemini_002.md` and `mobile/readme_fek.md` (as per the patch).
2.  **Documentation Reorganization:**
    * The docs created by the patch (`mobile/gemini_002.md`, `mobile/readme_fek.md`) were moved to `fek_wip/mobile_gemini_002.md` and `fek_wip/mobile_readme_fek.md` respectively, in a dedicated commit.
3.  **Build Fix - `keystore.properties`:**
    * The build initially failed due to a missing `mobile/keystore.properties` file.
    * A subsequent failure (`path may not be null`) occurred when this file was empty.
    * **Fix:** Created `mobile/keystore.properties` and populated it with placeholder values for `storeFile`, `storePassword`, `keyAlias`, and `keyPassword`. This file is now staged for the next commit.

## III. Utility Scripts (in `fek_wip/`):
* **`setenv.sh`:** Created to set project-specific environment variables (`PROJECT_ROOT`, `FEK_WIP_DIR`), add `fek_wip/` to `PATH`, and define an alias `buildfek`. Staged for commit.
* **`build_fork_002.sh` (renamed from `build_fork_001.sh`):** Created to automate Android builds from the `mobile/` directory. It runs `./gradlew assembleDebug --info --stacktrace`, logs output to `fek_wip/logs/build002/` (timestamped), displays output via `tee`, and copies the log to the Windows clipboard. Staged for commit.
* **`catclip` (Python script, formerly `catclip.py`):** Created to facilitate sending file contents. Updated to default to "Yes" for copying and include a "Quit" option. Staged for commit.
* This documentation file (`gemini_004.md`) and others (`gemini_005.md`, etc.) are being prepared.

## IV. Build Status:
* **SUCCESSFUL:** The command `./gradlew assembleDebug --info --stacktrace` (run via the `build_fork_002.sh` script) now completes successfully.
* **Deprecation Warnings:** 100 Java deprecation warnings are present in the build log, as expected from the enabled build flags.

## V. Git Status:
* The `fekerr-experiments` branch contains the applied patch, the documentation move commit, and staged changes including `mobile/keystore.properties` and the `fek_wip/` utility scripts and this/other summary docs.
* The user is about to commit these staged changes and push the `fekerr-experiments` branch to `origin`.
