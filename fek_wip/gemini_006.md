# Git Command Summary (Recent Usage in Session: 2025-05-19)

This document summarizes key Git commands used or discussed during the current work session on the `ingress-intel-total-conversion` fork, along with their utility.

1.  **`gh repo clone <owner/repo_name>`**
    * **Example:** `gh repo clone aomaker-org/ingress-intel-total-conversion`
    * **Utility:** Clones a repository from GitHub using the GitHub CLI.
    * **Discussion:** Initially used to clone what was thought to be the direct upstream. We clarified that for a fork-based workflow where `origin` should be the personal fork, one should clone their own fork (e.g., `gh repo clone your-username/repo-name`). In this specific case, `aomaker-org/ingress-intel-total-conversion` *is* the user's fork of `IITC-CE/ingress-intel-total-conversion`.

2.  **`git switch -c <branch_name>`**
    * **Example:** `git switch -c fekerr-experiments`
    * **Utility:** Creates a new branch from the current commit (HEAD) and immediately switches the working directory to this new branch. Essential for isolating new development work from the main line (e.g., `main` or `master`).

3.  **`git remote -v`**
    * **Utility:** Lists all configured remote repositories along with their fetch and push URLs. Crucial for verifying that `origin` (typically your fork) and `upstream` (typically the original project you forked from) are pointing to the correct locations.
    * **Example Output (Corrected State):**
        ```
        origin  git@github.com:aomaker-org/ingress-intel-total-conversion.git (fetch)
        origin  git@github.com:aomaker-org/ingress-intel-total-conversion.git (push)
        upstream        git@github.com:IITC-CE/ingress-intel-total-conversion.git (fetch)
        upstream        git@github.com:IITC-CE/ingress-intel-total-conversion.git (push)
        ```

4.  **`git remote add upstream <repository_url>`**
    * **Example (if it hadn't been set):** `git remote add upstream https://github.com/IITC-CE/ingress-intel-total-conversion.git`
    * **Utility:** Adds a new remote repository reference. Conventionally, `upstream` is used to refer to the original repository from which a fork was made. This allows fetching updates from the original project to keep the fork current. (In this session, we found `upstream` was already correctly configured).

5.  **`git log -n <number>` or `git log --oneline -n <number>`**
    * **Example:** `git log -5` or `git log --oneline -5`
    * **Utility:** Displays the commit history. `-n <number>` limits the output to the specified number of recent commits. `--oneline` provides a compact, single-line view for each commit. Used to identify specific commit hashes and understand recent branch history.

6.  **`git format-patch -1 <commit_hash> --stdout > <output_patch_file>`**
    * **Example:** `git format-patch -1 949921b9275b6d296b4126f2b5a7cc69581760b7 --stdout > ~/iitc_changes_949921b.patch`
    * **Utility:** Creates a patch file from a single specified commit. The patch contains the diff introduced by that commit and metadata (author, date, commit message). Useful for transferring a specific set of changes between repositories or branches, especially when direct merging or cherry-picking isn't straightforward. `--stdout` directs output to standard out, which is then redirected to a file.

7.  **`git apply --check <patch_file_path>`**
    * **Example:** `git apply --check ~/iitc_changes_949921b.patch`
    * **Utility:** Performs a dry run to test if a patch can be applied cleanly to the current working tree. No output from this command typically indicates that the patch should apply without conflicts.

8.  **`git am --3way <patch_file_path>`**
    * **Example:** `git am --3way ~/iitc_changes_949921b.patch`
    * **Utility:** Applies a patch (or series of patches from an mbox file) created by `git format-patch`. It attempts to create new commits, preserving the original commit's author, date, and message. The `--3way` option tells Git to attempt a 3-way merge if conflicts are encountered, which can often resolve them automatically.
    * **On Failure:** If `git am` fails due to conflicts it can't resolve, it will stop and provide instructions. One can then resolve conflicts manually and run `git am --continue`, or abort the process with `git am --abort`.

9.  **`git mv <old_file_path> <new_file_path>`**
    * **Example:** `git mv mobile/gemini_002.md fek_wip/mobile_gemini_002.md`
    * **Utility:** Moves or renames a file that is already tracked by Git. This command is equivalent to running `mv <old> <new>`, then `git rm <old>`, and then `git add <new>`. It stages the move operation directly.

10. **`git status`**
    * **Utility:** Shows the current state of the working directory and the staging area. It lists which files are modified but not staged, which files are staged for the next commit, and which files are untracked. Essential for understanding what will be included in the next commit.

11. **`git add <file_or_directory_path>` or `git add .`**
    * **Example:** `git add mobile/keystore.properties`, `git add fek_wip/`, `git add .`
    * **Utility:** Adds file contents to the staging area (also known as the "index"). This prepares the changes to be included in the next commit. `git add .` stages all changes (new files and modifications to tracked files) in the current directory and its subdirectories.

12. **`git commit -m "<commit_message>"`**
    * **Example:** `git commit -m "Add placeholder keystore.properties and utility scripts"`
    * **Utility:** Records the changes currently in the staging area as a new commit in the local repository's history. The `-m` flag allows providing the commit message directly on the command line.

13. **`git push origin <branch_name>` (or `git push` if tracking is set)**
    * **Example:** `git push -u origin fekerr-experiments` (first push of the branch to set upstream tracking), then subsequent `git push`.
    * **Utility:** Uploads the local branch's commits (and associated objects) to the specified remote repository (`origin` in this case, pointing to `aomaker-org/ingress-intel-total-conversion`). This makes the local changes available on the remote fork.
