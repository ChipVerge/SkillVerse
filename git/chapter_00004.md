# Essential Git Commands: A Quick Guide

This section provides a concise overview of essential Git commands you'll use daily. Each command is explained with key points, practical examples, and tips to enhance your Git workflow.

## `git init`

**Action**: **Initialize a new Git repository**. This command turns your project folder into a Git repository, allowing you to start tracking changes.

### Key Points:

- **One-Time Setup**: Use `git init` only once per project, typically at the very beginning.
- **Creates `.git` Directory**: This command creates a hidden `.git` directory in your project's root. This directory is the heart of Git, storing all version control information, configurations, and history.
- **Start Fresh**: Run `git init` in the root directory of your project _before_ you add any files or start committing.

### Example:

```bash
cd my-project
git init  # Initializes Git in 'my-project' directory
# Output: Initialized empty Git repository in /path/to/my-project/.git/
```

## `git clone`

**Action**: **Copy an existing Git repository** from a remote source (like GitHub, GitLab, etc.) to your local machine.

### Usage:

```bash
git clone https://github.com/user/repo.git
# Output: Cloning into 'repo'...
#         remote: Enumerating objects: ...
#         ...
#         Receiving objects: 100% (...), done.
#         Resolving deltas: 100% (...), done.
```

**Pro Tips**:

- **Secure Access with SSH**: For more secure and password-free interactions with remote repositories, use the SSH URL:

  ```bash
  git clone git@github.com:user/repo.git
  ```

  _(Requires SSH keys to be set up with your Git hosting service)_

- **Clone into a Specific Folder**: To clone the repository into a folder with a different name than the repository name, specify the folder name at the end of the command:

  ```bash
  git clone https://github.com/user/repo.git my-custom-folder-name
  # Clones 'repo' into a folder named 'my-custom-folder-name'
  ```

## `git status`

**Action**: **Check the current status of your working directory and staging area**. This command shows you the state of your repository, highlighting changes that are staged, unstaged, and untracked files.

### Sample Output:

```
On branch main
Your branch is up to date with 'origin/main'.

Changes not staged for commit:
  (use "git add <file>..." to update what will be committed)
        modified:   index.html

Untracked files:
  (use "git add <file>..." to include in what will be committed)
        new-file.txt

no changes added to commit (use "git add" and/or "git commit -a")
```

- **`On branch main`**: Indicates you are currently on the 'main' branch.
- **`Changes not staged for commit`**: Lists files that have been modified but not yet staged with `git add`.
- **`Untracked files`**: Lists files in your working directory that Git is not currently tracking.

**Concise Output with `-s` (short format)**: For a cleaner, more compact output, use the `-s` flag:

```bash
git status -s
# Output example:
#  M index.html
# ?? new-file.txt
```

- `M`: Modified (staged or unstaged)
- `??`: Untracked file
- `A`: Added (staged)
- `D`: Deleted (staged or unstaged)

## `git add`

**Action**: **Stage changes** to prepare them for the next commit. Staging is the step between making changes in your working directory and actually committing those changes to the repository history.

### Common Use Cases:

```bash
git add .                 # Stage all changes in the current directory and subdirectories
git add file1.js          # Stage changes in a specific file (file1.js)
git add *.css             # Stage changes in all files with the .css extension
git add directory/        # Stage all changes within 'directory/'
```

**Watch Out! Key Differences in `git add` behavior**:

- **`git add .` (Stage all)**: This command stages _all_ changes in your current directory and all subdirectories. This includes new files, modified files, and deleted files. It's convenient but use with caution to avoid accidentally staging files you didn't intend to commit (e.g., temporary files or build artifacts).
- **`git add -u` (Stage modified and deleted, but NOT new)**: This command stages only modifications and deletions of files that Git is already tracking. It will _not_ stage new, untracked files. This is useful when you only want to update existing files and not add new ones in a commit. To add new files, you still need to use `git add <new_file>` or `git add .`.

## `git commit`

**Action**: **Save staged changes** to your local repository with a descriptive message. This creates a new commit, which is a snapshot of your project at that specific point in time.

### Best Practices for Effective Commits:

- **Atomic Commits**: Create commits that are atomic, meaning each commit should represent a single, logical change or idea. This makes it easier to understand the history and revert changes if needed. Avoid bundling unrelated changes into one commit.
- **Conventional Commits Style**: Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification for writing commit messages. This provides a standardized format that improves readability and automation. Common commit types include:

  - `feat`: For new features.
  - `fix`: For bug fixes.
  - `docs`: For documentation changes.
  - `style`: For code style changes (formatting, etc.).
  - `refactor`: For code refactoring (no feature or bug fix).
  - `test`: For changes related to tests.
  - `chore`: For build process or tooling changes.

  **Examples of Conventional Commit Messages**:

  ```bash
  git commit -m "feat: add dark mode toggle"
  git commit -m "fix: resolve login button crash on mobile"
  git commit -m "docs: update README with installation instructions"
  ```

## `git push`

**Action**: **Upload local commits** from your current branch to a remote repository. This shares your work with collaborators and backs up your changes remotely.

### First Time Push? Set Upstream Branch:

When you push a local branch to a remote repository for the first time, establish a tracking connection by using the `-u` flag. This links your local branch to a corresponding remote branch, simplifying future pushes and pulls.

```bash
git push -u origin main
# Sets up tracking for local 'main' branch to 'origin/main'
```

- After the upstream is set, you can simply use `git push` for subsequent pushes from the same branch.

### Handling Rejected Push (Remote Changes Present):

If your `git push` is rejected because the remote repository has changes you don't have locally, you need to synchronize your local repository first. Use `git pull --rebase` to fetch and integrate remote changes before pushing again:

```bash
git pull --rebase origin main  # Fetch remote changes and reapply local commits on top
git push                      # Now push your changes
```

- `git pull --rebase` is generally preferred over `git pull` (which is equivalent to `git fetch` + `git merge`) as it keeps the commit history cleaner and linear.

## `git fetch`

**Action**: **Download remote changes** from a remote repository to your local repository, _without_ automatically merging them into your working branch. This allows you to review remote changes before integrating them.

```bash
git fetch origin  # Fetches updates from the 'origin' remote
# Output:
# remote: Enumerating objects: ..., done.
# remote: Counting objects: ..., done.
# ...
# From https://github.com/user/repo
#  * branch            main       -> FETCH_HEAD
```

- `git fetch origin` downloads the latest commits, branches, and tags from the `origin` remote. These changes are stored in your local repository as remote-tracking branches (e.g., `origin/main`) but do not modify your local working branches.

### Review Fetched Changes:

After fetching, you can inspect the changes using `git log` to see what's new in the remote branch without altering your local branch:

```bash
git log origin/main --oneline  # View a concise commit history of 'origin/main'
```

### `git fetch` vs `git pull`: Understanding the Difference

- **`git fetch`**: Downloads remote changes but keeps them separate. You need to explicitly merge them. This is a safer workflow as you can review changes before integrating.
- **`git pull`**: A convenience command that combines `git fetch` and `git merge`. It automatically fetches remote changes and then immediately merges them into your current branch. While quicker, it can lead to unexpected merge conflicts if you haven't reviewed the remote changes first.

**Recommendation**: For a more controlled workflow, especially in collaborative projects, prefer using `git fetch` to review remote changes, and then use `git merge` to integrate them when you are ready.

## `git pull`

**Action**: **Synchronize your local branch** with the remote branch. This command fetches changes from the remote repository and automatically merges them into your current local branch.

```bash
git pull origin main
# Fetches changes from 'origin/main' and merges into your current branch
# Output (if successful merge):
# From https://github.com/user/repo
#  * branch            main       -> FETCH_HEAD
# Updating ...
# ...
#  ... files changed, ... insertions(+), ... deletions(-)
```

**Conflict Alert: Resolving Merge Conflicts Manually**

If the remote repository has changes that conflict with your local changes (e.g., both you and someone else modified the same lines of code), `git pull` will result in a merge conflict. Git will pause the merge process and ask you to resolve these conflicts manually.

- **Identify Conflicting Files**: Git will indicate files with conflicts in the `git status` output.
- **Resolve Conflicts**: Open the conflicting files in a text editor. Look for conflict markers (`<<<<<<<`, `=======`, `>>>>>>>`) inserted by Git. Edit the file to resolve the conflicts, choosing which changes to keep or combining them. Remove the conflict markers after resolution.
- **Stage Resolved Files**: After resolving conflicts in a file, stage it using `git add <resolved_file>`.
- **Complete the Merge**: Once all conflicts are resolved and staged, finalize the merge with `git commit`. Git will usually pre-populate a commit message for a merge commit.

## `git checkout`

**Action**: **Switch branches** or **restore files** to a previous state. `git checkout` is a versatile command used for branch management and undoing changes.

### Switching and Creating Branches:

- **Switch to an Existing Branch**: To switch from your current branch to another existing branch (e.g., `main`):

  ```bash
  git checkout main  # Switch to the 'main' branch
  # Output: Switched to branch 'main'
  #        Your branch is up to date with 'origin/main'.
  ```

- **Create and Switch to a New Branch**: To create a new branch and immediately switch to it, use the `-b` flag followed by the new branch name:

  ```bash
  git checkout -b new-feature  # Create a branch named 'new-feature' and switch to it
  # Output: Switched to a new branch 'new-feature'
  ```

### Undoing Changes to a File:

To discard local changes in a specific file and revert it to the version from the last commit (in `HEAD`):

```bash
git checkout HEAD -- style.css  # Revert 'style.css' to the version in the last commit
# Output: Updated 1 path from the index
```

- This is useful for discarding unwanted local modifications in a file and resetting it to its committed state. Be careful, as this action is irreversible and will discard your local changes.

## `git log`

**Action**: **View commit history**. `git log` displays a history of commits in your repository, allowing you to review past changes, commit messages, authors, and dates.

### Handy Flags for `git log`:

- **`--oneline`**: Displays commit history in a compact, single-line format, showing only the commit SHA and the first line of the commit message.

  ```bash
  git log --oneline
  # Output example:
  # a1b2c3d (HEAD -> main, origin/main) feat: add dark mode toggle
  # e5f6g7h fix: resolve login button crash
  # ...
  ```

- **`-p` or `--patch`**: Shows the detailed changes (patches) introduced in each commit, displaying the line-by-line additions and deletions.

  ```bash
  git log -p -2 # Show patches for the last 2 commits
  ```

- **`--graph --decorate --oneline`**: Visualizes the branch and merge history in a graphical format, along with branch and tag decorations, in a compact one-line format.

  ```bash
  git log --graph --decorate --oneline --all
  # Output (example):
  # * a1b2c3d (HEAD -> main, origin/main) feat: add dark mode toggle
  # |
  # * e5f6g7h fix: resolve login button crash
  # | * i8j9k0l (feature/new-ui) feat: implement new UI components
  # |/
  # * ...
  ```

- **`-<n>`**: Limit the number of commits displayed to the last `<n>` commits. For example, `-2` shows the last two commits.

  ```bash
  git log -2
  ```

## `git diff`

**Action**: **Show differences between commits, branches, working directory, and staging area**. `git diff` is used to inspect changes at various stages of your Git workflow.

### Common `git diff` Use Cases:

- **`git diff` (Working Directory Changes)**: Shows the differences between your working directory and the staging area. This displays unstaged changes – modifications you've made but haven't yet added with `git add`.

  ```bash
  git diff # Shows unstaged changes
  ```

- **`git diff --staged` (Staged Changes)**: Shows the differences between the staging area and the last commit (`HEAD`). This displays changes that are staged and ready to be committed.

  ```bash
  git diff --staged # Shows staged changes
  ```

- **`git diff <commit> <commit>` (Compare Commits)**: Compares two commits and shows the changes introduced between them. You can use commit SHAs, branch names, or tags to specify commits. `HEAD~3` refers to the commit that was made 3 commits before the current `HEAD`.

  ```bash
  git diff HEAD~3 HEAD  # Compare changes between the commit 3 commits ago and the latest commit
  ```

## `git reset`

**Action**: **Undo commits or unstage files**. `git reset` is a powerful command to undo changes in your repository, but it should be used with caution, especially the `--hard` option, as it can lead to data loss.

### Soft Reset (`--soft`) - Undo Commit, Keep Changes:

```bash
git reset --soft HEAD~1
# Undoes the last commit, but keeps the changes in the staging area
```

- `--soft HEAD~1` moves the branch pointer back by one commit (effectively undoing the last commit), but it leaves the changes from that commit staged. This is useful if you want to modify the last commit message or make further changes before recommitting.

### Hard Reset (`--hard`) - DANGER! - Discard Commits and Changes:

```bash
git reset --hard HEAD~3
# WARNING: Discards the last 3 commits AND all changes in the working directory!
```

- `--hard HEAD~3` is a **destructive command**. It moves the branch pointer back by three commits, and critically, it **permanently deletes** all changes in the working directory and staging area _from those commits onwards_. Use `--hard` reset only when you are absolutely sure you want to discard commits and all associated changes. **This action is generally irreversible and should be used with extreme caution.**

## `git stash`

**Action**: **Temporarily shelve changes** that you don't want to commit immediately. `git stash` is useful when you need to switch branches to work on something else, but you're not ready to commit your current changes. It saves your uncommitted changes and reverts your working directory to a clean state.

```bash
git stash  # Saves your uncommitted changes to a new stash
# Output: Saved working directory and index state WIP on main: ...
#         HEAD is now at ... <commit message>
```

### Common `git stash` Workflow:

1.  **Stash Changes**: When you need to switch context but aren't ready to commit:

    ```bash
    git stash
    ```

2.  **List Stashes**: To see a list of your saved stashes:

    ```bash
    git stash list
    # Output example:
    # stash@{0}: WIP on main: ... Commit message of when stash was created
    # stash@{1}: WIP on feature-branch: ... Another stash
    ```

3.  **Apply and Delete the Most Recent Stash**: To bring back your stashed changes and remove the stash from the stash list, use `git stash pop`:

    ```bash
    git stash pop
    # Output: On branch main
    #         Changes to be committed:
    #         ... staged changes from stash ...
    #         Changes not staged for commit:
    #         ... unstaged changes from stash ...
    #         Dropped refs/stash@{0} ... (message about dropped stash)
    ```

    - `git stash pop` applies the changes from the most recent stash and then removes that stash from the stash list.

### Scenario Example: Handling Urgent Fixes

Imagine you are working on a feature on your `main` branch, and suddenly an urgent bug fix is needed on a `hotfix-branch`. Here’s how `git stash` can help:

```bash
# 1. You are working on 'main' branch with uncommitted changes
# ... working on main branch ...

git stash                  # 2. Stash your current changes on 'main'
# Output: Saved working directory and index state ...

git checkout hotfix-branch  # 3. Switch to 'hotfix-branch'
# Output: Switched to branch 'hotfix-branch'

# 4. Fix the urgent bug on 'hotfix-branch'
# ... fix bug ...
git add .
git commit -m "fix: urgent bug fix for ..."
git push origin hotfix-branch

git checkout main         # 5. Switch back to 'main' branch
# Output: Switched to branch 'main'

git stash pop             # 6. Reapply your stashed changes back onto 'main'
# Output: On branch main
#         ... your stashed changes are now back in your working directory ...
```

This workflow allows you to quickly switch to a hotfix branch, resolve an urgent issue, and then return to your original task on the `main` branch without losing your work in progress.

### **Essential Git Commands: Quick Reference**

| Command                     | Action                                                                     |
| :-------------------------- | :------------------------------------------------------------------------- |
| `git init`                  | Initialize a new Git repository in the current directory                   |
| `git clone <URL>`           | Copy a remote repository to your local machine                             |
| `git status`                | Show the status of your working directory and staging area                 |
| `git add <file(s)>`         | Stage changes for the next commit                                          |
| `git commit -m "<message>"` | Save staged changes to your local repository with a message                |
| `git push`                  | Upload local commits to a remote repository                                |
| `git pull`                  | Download and merge remote changes into your current local branch           |
| `git fetch`                 | Download remote changes without merging                                    |
| `git checkout <branch>`     | Switch to a different branch                                               |
| `git checkout -b <branch>`  | Create a new branch and switch to it                                       |
| `git log --oneline`         | View commit history in a compact format                                    |
| `git diff`                  | Show changes between working directory and staging area (unstaged changes) |
| `git diff --staged`         | Show changes between staging area and the last commit (staged changes)     |
| `git reset --soft HEAD~1`   | Undo the last commit but keep changes staged                               |
| `git reset --hard HEAD~<n>` | **Danger**: Discard last `<n>` commits and all changes!                    |
| `git stash`                 | Temporarily save uncommitted changes                                       |
| `git stash list`            | List all saved stashes                                                     |
| `git stash pop`             | Apply and remove the most recent stash                                     |

##### Copyright (c) 2026 ChipVerge
