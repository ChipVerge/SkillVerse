# Chapter 7: Environment and Customization

## What You Will Learn
- Understand shell startup files and when they run.
- Manage PATH, aliases, and functions for productivity.
- Customize prompts and completions.
- Keep a portable, minimal dotfiles setup.

## Key Concepts
- Shell types: login vs. interactive vs. non-interactive; different files sourced.
- Common files: `/etc/profile`, `~/.profile`, `~/.bash_profile`, `~/.bashrc`, `~/.zshrc`.
- PATH order matters; earlier entries win. Prefer appending/prepending intentionally.
- `env` vs. `export`: exporting makes variables visible to child processes.
- Aliases for short commands; functions for logic; completions via shell frameworks or `bash-completion`.
- Prompts: `PS1` (primary), `PS2` (continuation); use simple, informative prompts.

## Essential Snippets
```sh
# ~/.bashrc (example)
# Safety and PATH
set -o vi                              # or `set -o emacs`
export PATH="$HOME/bin:$PATH"

# Aliases
alias ll='ls -lah'
alias gs='git status'

# Functions
mkcd() { mkdir -p "$1" && cd "$1"; }
extract() { case "$1" in *.tar.gz) tar -xzf "$1";; *.zip) unzip "$1";; *) echo "Unknown";; esac; }

# Prompt (bash)
PS1='\u@\h:\w$ '
```

## Exercises (Hands-On)
1) Identify which startup files your shell uses: open a new login shell and echo a marker from each file.
2) Add `~/bin` to PATH in `~/.profile` (login) and verify with `echo $PATH` after re-login.
3) Create an alias `lt` for `ls --tree` or `ls -R` fallback; test it.
4) Add a function `cproj` that `cd`s into your main projects folder.
5) Customize your prompt to show `user@host:cwd` and git branch if available (optional: use `__git_ps1`).

## Mini-Lab: Portable Dotfiles Starter
- Create `~/dotfiles` containing `bashrc` and `profile` snippets.
- In `~/.bashrc`, source the dotfiles version: `[ -f "$HOME/dotfiles/bashrc" ] && . "$HOME/dotfiles/bashrc"`.
- Add minimal content: PATH update, aliases, `mkcd`, prompt.
- Test by opening a new terminal; ensure no errors when files are missing on another machine.

## Check Your Understanding
- What is the difference between `~/.profile` and `~/.bashrc`? When is each read?
- How does PATH ordering influence which binary runs?
- When should you choose a function instead of an alias?

## Common Pitfalls
- Editing the wrong startup file and wondering why changes do not apply.
- Prepending duplicate PATH entries, leading to long PATH strings and unexpected binaries.
- Overly complex prompts harming performance on slow remote shells.

## Prep for Next Chapter
- Generate or locate your SSH keys and think about common remote hosts you access.

##### Copyright (c) 2026 ChipVerge

