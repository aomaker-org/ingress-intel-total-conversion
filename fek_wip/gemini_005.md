# Project Understanding Summary (IITC-CE)

**Date:** 2025-05-19
**Based on:** Review of project files (`build.py`, `build_plugin.py`, `build_mobile.py`, `settings.py`, `buildsettings.py`, various wrappers, `package.json`, `eslint.config.js`, `jsdoc-conf.json`, `Gemfile`, etc.)

## I. Core Project Nature:
* **Ingress Intel Total Conversion - Community Edition (IITC-CE):** A browser-based modification for the Ingress Intel map.
* **Primary Components:** JavaScript-based UserScripts (a core script and numerous plugins) designed to run in browsers via extensions like Tampermonkey.
* **Mobile Application:** An Android wrapper app (located in the `mobile/` directory) that embeds the web components (likely via a WebView) to provide a native mobile experience.

## II. Build System & Orchestration:
The project employs a sophisticated, multi-layered build system primarily orchestrated by Python scripts, with specific tools for different components:

1.  **Python Build System (Top Level):**
    * **`build.py`:** The main build script acting as the primary orchestrator. It takes a build target name (e.g., "local", "dev", "mobile") as an argument.
    * **`settings.py`:** The central configuration loader. It dynamically loads settings from:
        * `buildsettings.py`: Contains default configurations and definitions for various build targets.
        * `localbuildsettings.py` (optional): Allows user-specific overrides without modifying tracked files.
        The `settings.py` module then makes these merged, effective settings available as its own attributes (e.g., `settings.namespace`, `settings.build_target_dir`). It also handles generation of build timestamps.
    * **`build_plugin.py`:** A powerful script responsible for processing individual JavaScript files (`.user.js`) into complete UserScripts. Its tasks include:
        * Parsing and dynamically generating/updating UserScript metablocks (versioning with timestamps, URLs, IDs, namespace, match rules, icons, grant).
        * Implementing a templating system (`'@keyword[:value]@'`) to inline resources like raw files, strings, images (as base64 data URIs), and CSS (with its own internal image-to-base64 conversion for `url()`s).
        * Bundling code from subdirectories (`@bundle_code@`).
        * Wrapping the final JavaScript in a chosen wrapper (from `pluginwrapper.py` or `pluginwrapper_noinject.py`) to ensure proper execution context and provide build info to the script.
        * Tracking file dependencies for the watch mode in `build.py`.
    * **`pluginwrapper.py` / `pluginwrapper_noinject.py`:** Provide the JavaScript wrapper code.
        * `pluginwrapper.py` (standard): Injects the script into the page's main context for full interaction. Includes logic for `window.bootPlugins` array for plugin initialization.
        * `pluginwrapper_noinject.py` (for `tmdev` target): Calls the plugin wrapper directly in the Tampermonkey sandbox for easier debugging.
    * **`build_mobile.py`:** Handles the Android-specific build phase. It's typically run as a `post_build` step for the "mobile" target defined in `buildsettings.py`. Its responsibilities include:
        * Copying the processed JavaScript assets (output from `build_plugin.py`, e.g., from `build/mobile/`) into the Android project's `mobile/assets/` directory.
        * Invoking Gradle (via `./gradlew`) with the appropriate task (e.g., `assembleDebug`, `bundleRelease`) based on settings.
        * Copying the final APK/AAB to the output directory.

2.  **Gradle (Android - `mobile/` directory):**
    * The standard build tool for the Android application.
    * Compiles Java/Kotlin, Android resources, and packages the APK/AAB.
    * Configuration is via `build.gradle` (app and project level) and `gradle.properties`.
    * Current setup targets Java 21, `compileSdkVersion 35`, `minSdkVersion 23`, `targetSdkVersion 35`.
    * Uses AGP `8.10.0` and Gradle `8.11.1`.
    * Requires `mobile/keystore.properties` for signing configuration (even if using dummy values for debug).

3.  **Fastlane (`Gemfile`, `fastlane/` directory):**
    * Indicated by the `Gemfile`. Fastlane is used for automating mobile app build, test, and release pipelines (e.g., uploading to app stores, managing signing). It likely orchestrates calls to the Python build system or Gradle.

4.  **NPM Scripts (`package.json`):**
    * Provide convenient shortcuts for developers:
        * `npm run build:local` -> `./build.py local`
        * `npm run build:mobile` -> `./build.py mobile` (confirms the primary way to trigger a full mobile build)
        * `npm run test` -> `mocha --exit`
        * `npm run fileserver` -> `./web_server_local.py local`

## III. Development Tooling & Practices:
* **JavaScript Development:**
    * **Linting/Formatting:** ESLint and Prettier are used for code quality and style consistency, configured via `eslint.config.js`.
    * **API Documentation:** JSDoc with the `tui-jsdoc-template` is used to generate API documentation from JS comments, configured in `jsdoc-conf.json`.
    * **Testing:** Mocha (test framework) and Chai (assertion library) are used for automated JavaScript testing.
* **Python Build Script Development:**
    * PEP 8 style guidelines are considered, with `setup.cfg` used to configure `pycodestyle` (e.g., ignoring E501 line length).
* **Local Development Aids:**
    * `web_server_local.py`: A simple HTTP server to serve built UserScripts locally for testing with UserScript managers via HTTP.
    * `tampermonkey_stubs_gen.py`: Generates a Tampermonkey-importable zip of script stubs that use `@require` to load UserScripts directly from the local filesystem (`file:///` URIs), facilitating rapid development and debugging in Chrome with Tampermonkey.
* **Metadata for Extensions:**
    * `web_meta_gen.py`: Generates `meta.json` which catalogs plugins and core script details for the IITC-Button browser extension.

## IV. Licensing:
* The core IITC-CE project is licensed under the permissive **ISC license**.
* Various third-party components are included, with their respective licenses detailed in `ATTRIBUTION.MD`.

This provides a comprehensive understanding of the project's build system as a combination of Python orchestration for JavaScript processing and asset preparation, which then feeds into the standard Gradle build for the Android mobile component, potentially further managed by Fastlane for release automation. Development is supported by a rich set of linting, testing, documentation, and local serving utilities.
