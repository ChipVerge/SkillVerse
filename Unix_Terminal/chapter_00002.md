# Chapter 2: Navigation and Discovery

## What You Will Learn
- Move confidently with absolute and relative paths (., .., ~).
- Use globbing and expansions to target sets of files.
- Apply quoting to control expansion and whitespace handling.
- Discover files and directories quickly with listing and search tools.

## Key Concepts
- Absolute vs. relative paths; home `~`; current `.`; parent `..`.
- Globbing: `*`, `?`, `[...]` patterns (simple, not regex).
- Brace expansion: `{a,b}`, `{1..3}` to generate strings before globbing.
- Quoting: single quotes prevent expansion; double quotes allow variable/command substitution.
- Tab completion: saves keystrokes and reduces typos.

## Essential Commands
- `pwd`: Print current directory.
- `cd <path>`, `cd -`, `cd ~user`: Change directory (dash returns to previous).
- `ls -lah`, `ls -R`: List with details, hidden files, recursion.
- `tree`: Visualize directory structure (if installed).
- `find <path> -name "pattern" -type f`: Recursive search by name.
- `locate <name>`: Database-backed search (may require `updatedb`).
- `realpath <path>`: Resolve to absolute path.
- `printf %q`: Show shell-escaped paths.

### Examples
```sh
pwd
cd ~/projects
ls -lah
cd -             # jump back

# Brace expansion to create paths
mkdir -p demo/{logs,tmp,data}

# Globbing vs. quoting
ls *.txt         # expands
ls "*.txt"       # literal string "*.txt"

# Find files named config.yml under current tree
find . -name "config.yml" -type f

# Locate binaries named python
locate bin/python | head
```

## Exercises (Hands-On)
1) Make a playground: `mkdir -p ~/nav_play/{src,bin,logs}` then move around using `cd`, `cd -`, `cd ..`.
2) Use `ls -la` to list dotfiles. Add `tree ~/nav_play` if available.
3) Create files: `touch ~/nav_play/src/app.{js,py,sh}`. Use `ls src/*.py` and compare to `ls "src/*.py"`.
4) Search: From `~/nav_play`, run `find . -type f -name "*.sh"`. Try `find . -maxdepth 2 -type f`.
5) Real path: From inside `~/nav_play/src`, run `realpath ../logs` and note the result.

## Mini-Lab: Organize a Notes Area
- Create `~/notes/{inbox,archive,ref}` and a `README.txt` inside each.
- Use `tree ~/notes` (or `find ~/notes -maxdepth 2 -type f`) to verify.
- List all txt files under notes: `find ~/notes -name "*.txt" -print`.

## Check Your Understanding
- How do glob patterns differ from regular expressions?
- What does `cd -` do? What about `cd ~user`?
- Why should you quote paths with spaces or wildcard characters?

## Common Pitfalls
- Forgetting quotes when paths contain spaces or `*`/`?` characters.
- Expecting `*.txt` to match in subdirectories (it matches only current directory unless used with tools like `find` or `shopt -s globstar` in Bash 4+).
- Relying on `locate` without updating its database; results can be stale.

## Prep for Next Chapter
- Keep the `~/nav_play` tree for practicing file creation, copying, and permissions.

##### Copyright (c) 2026 ChipVerge

