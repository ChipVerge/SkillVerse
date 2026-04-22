# Chapter 6: Shell Scripting Essentials

## What You Will Learn
- Write portable shell scripts with safe defaults.
- Use variables, parameter expansion, conditionals, loops, and functions.
- Read user input and work with here-docs/strings.
- Add basic debugging and error handling.

## Key Concepts
- Shebang: `#!/usr/bin/env bash` (or `sh`); choose shell intentionally.
- Safety flags: `set -euo pipefail` and `IFS=$'\n\t'` for stricter behavior.
- Quoting discipline: prefer double quotes around variable expansions.
- Parameter expansion: defaults `${var:-fallback}`, substring `${var%/*}`, length `${#var}`.
- Functions: `foo() { ...; }` with `return` codes; local variables (`local` in bash/zsh).
- Conditionals: `[ ]`, `[[ ]]` (bash/zsh); test operators `-f`, `-d`, `-n`, `-z`, integers `-eq`, strings `==`.
- Loops: `for`, `while read -r`, `until`.
- Here-docs `cat <<'EOF' ... EOF` vs. here-strings `cmd <<< "text"`.

## Script Skeleton
```sh
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

usage() {
  echo "Usage: $0 <input_file>" >&2
}

main() {
  local file=${1:-}
  [[ -z $file ]] && usage && exit 1
  [[ ! -f $file ]] && echo "No such file: $file" >&2 && exit 1
  while IFS=, read -r col1 col2; do
    printf "%s -> %s\n" "$col1" "$col2"
  done < "$file"
}

main "$@"
```

## Exercises (Hands-On)
1) Write a script `greet.sh` that accepts a name and prints "Hello, <name>"; exit with error if no name.
2) Create `backup.sh` that copies files from a source directory to `~/backup` with a timestamp; check if source exists.
3) Write `rename-spaces.sh` to replace spaces with underscores in filenames within current directory using a loop.
4) Add `set -x` to one of your scripts to see tracing; remove it afterward.
5) Practice reading input safely: `while IFS= read -r line; do echo "$line"; done < file.txt`.

## Mini-Lab: Simple CSV Checker
- Input: CSV file where column 1 must be non-empty and column 3 must be an integer.
- Script tasks:
  - Validate args and file readability.
  - Read lines with `IFS=, read -r c1 c2 c3`.
  - If `c1` empty or `c3` not an integer (`[[ $c3 =~ ^[0-9]+$ ]]`), print an error with line number.
  - Exit non-zero if any row fails.

## Check Your Understanding
- Why use `set -euo pipefail`? What pitfalls remain even with it?
- How do `<<EOF` and `<<<` differ?
- When should you prefer `[[ ... ]]` over `[ ... ]`?

## Common Pitfalls
- Forgetting to quote variables, causing word-splitting or globbing surprises.
- Using `for f in $(ls)` which breaks on spaces; prefer `for f in *.txt; do ...; done` or `find` with `-print0` and `while IFS= read -r -d '' f; do ...; done`.
- Relying on bash-specific features in environments where only `sh` is available.

## Prep for Next Chapter
- Collect aliases and prompt tweaks you like; we'll fold them into startup files.

##### Copyright (c) 2026 ChipVerge

