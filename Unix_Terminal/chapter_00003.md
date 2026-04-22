# Chapter 3: File Management and Permissions

## What You Will Learn
- Create, copy, move, and delete files/directories safely.
- Inspect file contents with paging and slicing tools.
- Understand Unix permission bits, ownership, and umask defaults.
- Adjust permissions and ownership; use `sudo` basics.

## Key Concepts
- File types: regular files, directories, symlinks.
- Permission triads: user/group/other with `rwx`; numeric (e.g., 755) vs. symbolic (`u+rwx`).
- Default permissions and `umask`: subtracts from defaults to set new file/dir modes.
- Recursive operations: `cp -r`, `rm -r`, `chmod -R`, `chown -R` (use with care).

## Essential Commands
- Create/manage: `touch`, `cp`, `mv`, `rm`, `mkdir -p`, `rmdir`.
- View: `cat`, `less`, `head`, `tail`, `tail -f`.
- Permissions: `ls -l`, `chmod`, `chown`, `chgrp`, `umask`.
- Elevated: `sudo <cmd>` (if you have privileges); `sudo -l` to list allowed commands.

### Examples
```sh
# Copy directory recursively
cp -r src/ backup/src

# Move/rename file
mv notes.txt archive/notes-$(date +%Y%m%d).txt

# Remove a directory tree (confirm path carefully)
rm -r ~/nav_play/tmp

# Inspect permissions and ownership
ls -l ~/nav_play

# Set permissions: rw-r----- (640)
chmod 640 secrets.txt

# Add execute for user, read for group
chmod u+x,g+r script.sh

# Change owner and group (may require sudo)
sudo chown alice:staff project

# Show current umask
umask
```

## Exercises (Hands-On)
1) In `~/nav_play`, create `logs/app.log` and `data/input.txt`. Copy `input.txt` to `archive/input.bak`.
2) Move `logs/app.log` to `logs/app-1.log`, then back using `mv`.
3) Set permissions on `archive/input.bak` to `640`; verify with `ls -l`.
4) Make a directory `bin` and create a script `hello.sh`; run `chmod 755 bin/hello.sh` and execute it with `./bin/hello.sh`.
5) Check your `umask`, create a new file, and observe its default permissions.

## Mini-Lab: Permission Repair Drill
- Create `~/perm_lab` with `mkdir -p ~/perm_lab/{private,shared}`.
- In `private`, create `secret.txt`; set it to `600`.
- In `shared`, create `notes.txt`; set it to `664` and ensure the directory is `775`.
- Verify with `find ~/perm_lab -maxdepth 2 -type f -o -type d -exec ls -ld {} +`.

## Check Your Understanding
- How does `umask` influence new file permissions?
- When would you prefer symbolic `chmod` over numeric, and vice versa?
- Why is `rm -r` risky, and how can you mitigate mistakes?

## Common Pitfalls
- Using `rm -r` or `cp -r` with an unintended trailing slash or wildcard; double-check paths.
- Forgetting execute bit on scripts, leading to "Permission denied".
- Assuming `sudo` will preserve your environment; some variables are reset unless using `sudo -E` (use carefully).

## Prep for Next Chapter
- Keep a few sample files ready for experimenting with redirection, pipes, and text processing.

##### Copyright (c) 2026 ChipVerge

