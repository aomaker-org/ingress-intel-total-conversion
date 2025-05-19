# Suggested Next Steps (as of 2025-05-19)

Based on the successful build of the `fekerr-experiments` branch in the `aomaker-org/ingress-intel-total-conversion` fork, here are suggested next steps:

## I. Finalize Current Setup & Changes:

1.  **Commit Pending Files (if not already done in "minor cleanups" commit):**
    * Ensure `mobile/keystore.properties` (with placeholder values) is committed.
    * Commit the utility scripts: `fek_wip/setenv.sh`, `fek_wip/build_fork_002.sh`, and `fek_wip/catclip`.
    * Commit the documentation files we've generated today (e.g., `gemini_004.md`, `gemini_005.md`, `gemini_006.md`, and this file `gemini_007_next_steps.md`) into `fek_wip/`.
    * **Example commit (if files are staged):**
        ```bash
        git commit -m "Finalize initial setup: add keystore placeholder and WIP scripts/docs"
        ```

2.  **Push `fekerr-experiments` Branch:**
    * Ensure all local commits on `fekerr-experiments` are pushed to your `origin` remote (`aomaker-org/ingress-intel-total-conversion`).
        ```bash
        git push origin fekerr-experiments
        ```

3.  **Consider `.gitignore`:**
    * If not already done, consider adding `fek_wip/logs/` to your project's `.gitignore` file to prevent accidentally committing build log files.
    * Also, check if other generated directories (like `build/` at the project root, or IDE-specific files) should be in `.gitignore`.

## II. Leverage the Full Build System:

* **Understanding:** We've established that the project uses a Python-based build system (`build.py`) which orchestrates JavaScript processing (via `build_plugin.py`) before the Android Gradle build (triggered by `build_mobile.py`).
* **Recommendation:** For builds that require up-to-date JavaScript assets (core IITC scripts and plugins) to be embedded in the mobile app, use the intended project build command:
    ```bash
    # From the project root directory
    python3 build.py mobile
    ```
    (Or use the npm script: `npm run build:mobile`)
* Your script `fek_wip/build_fork_002.sh` (which calls `gradlew` directly) remains useful for quick iterations on the Android Java/Kotlin code in the `mobile/` module, assuming the JS assets are current.

## III. Address Deprecation Warnings:

* The build log shows 100 Java deprecation warnings. These were enabled by the patch.
* **Action:** Refer to `fek_wip/mobile_gemini_002.md` (which contains the initial analysis of these warnings based on the old repository's build).
* **Strategy:**
    * Start with simpler deprecations (e.g., `Handler()` default constructor, `Html.fromHtml(String)`, `PreferenceManager` usage).
    * Make changes in small, focused commits.
    * Run `buildfek` (or `./fek_wip/build_fork_002.sh`) after each group of fixes to ensure the build remains successful and to see the warning count decrease.
    * Consult Android developer documentation for the recommended replacements for each deprecated API.

## IV. Further Development & Code Porting:

* **Porting More Changes:** If you have other specific commits or features from your old experimental repository (beyond commit `949921b...`) that you wish to bring into this new `fekerr-experiments` branch, you can use the same `git format-patch` and `git am` process for those commits.
* **New Features/Bug Fixes:** Begin any new development work planned for IITC-CE. Consider creating new feature branches off `fekerr-experiments` for larger, distinct pieces of work.

## V. Testing:

* **JavaScript Tests:** The `package.json` includes a test script (`npm run test` which runs `mocha --exit`). Explore and run these tests to ensure the JavaScript components are functioning as expected.
* **Android App Testing:**
    * Install the generated debug APK (`mobile/app/build/outputs/apk/debug/app-debug.apk`) on an Android emulator or device to test its functionality.
    * Test the features modified or affected by the patched changes.

## VI. Documentation:
* Continue to document significant steps, decisions, and findings in your `fek_wip/` directory.
* Consider updating or creating more formal project documentation if your changes become part of a contribution.

This provides a solid path forward for your work on the IITC-CE fork.
