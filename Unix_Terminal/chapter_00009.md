# Chapter 9: Troubleshooting and Diagnostics

## What You Will Learn
- Diagnose PATH and command resolution issues.
- Fix permission and ownership problems.
- Handle line ending and encoding mismatches.
- Identify disk space and open-file issues.
- Read system logs for clues.

## Key Concepts
- PATH lookup order; `type -a` to see resolution.
- Common errors: "command not found", "permission denied", CRLF line endings, stale sockets, full disks.
- Filesystems and inodes: disk full vs. inode exhaustion.
- Encoding basics: UTF-8 vs. others; `file` to identify.

## Essential Commands
- PATH/debug: `echo $PATH`, `type -a cmd`, `which -a cmd`, `hash -r` to clear cache (bash).
- Permissions: `ls -l`, `namei -l` (if available) to trace permissions along a path.
- Line endings: `file`, `dos2unix`, `unix2dos`.
- Disk: `df -h`, `du -sh *`, `du -sh .[!.]*` for dotfiles, `find . -size +100M`.
- Open files: `lsof -p <pid>`, `lsof -i :<port>`, `fuser <file>`.
- Logs: `dmesg | tail`, `journalctl -xe` (systemd), `/var/log/*`, `tail -f`.

### Examples
```sh
# PATH issues
which -a python
hash -r             # clear hashed commands in bash

# Permissions along path
namei -l /var/www/html/index.html

# Fix CRLF line endings
dos2unix script.sh

# Disk usage overview
df -h

du -sh ./* | sort -h | tail

# Find large files
find . -type f -size +200M -print

# Port in use
lsof -i :8080
```

## Exercises (Hands-On)
1) Break and fix PATH: temporarily set `PATH=/bin` and see which commands fail; restore and run `hash -r`.
2) Create a file with Windows line endings using an editor; detect with `file` and convert with `dos2unix`.
3) Fill a temp directory with files and find the largest 3: `find . -type f -printf '%s %p\n' | sort -nr | head -n 3` (BSD find may need `-size +1M -print`).
4) Start `python -m http.server 8000` (if Python exists); check which process holds port 8000 using `lsof -i :8000` and stop it.
5) Read recent kernel messages: `dmesg | tail` (may require `sudo` on some systems).

## Mini-Lab: PATH Fixer
- Scenario: `mytool` exists in `/opt/mytool/bin` but `command not found` occurs.
- Steps:
  - Verify location: `find /opt -maxdepth 2 -type f -name mytool -print`.
  - Export PATH: `export PATH="/opt/mytool/bin:$PATH"` in the current shell and test.
  - Add the export to your shell startup file responsibly.

## Check Your Understanding
- How do you check every directory where a command could be resolved?
- What symptoms indicate CRLF issues in shell scripts?
- How do you differentiate disk-full vs. inode exhaustion?

## Common Pitfalls
- Editing PATH with trailing colons or spaces, creating empty entries that resolve to current directory.
- Using `sudo` without `-E` and losing environment adjustments needed for a command (use carefully).
- Ignoring error output; stderr often explains the failure—capture it if needed.

## Prep for Next Chapter
- Gather a small workflow you can automate end-to-end for the capstone.

##### Copyright (c) 2026 ChipVerge

