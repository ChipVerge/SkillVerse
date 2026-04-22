# Chapter 10: Putting It Together

## What You Will Learn
- Design and implement a small automation workflow end-to-end.
- Apply navigation, file ops, pipelines, scripting, and remote skills together.
- Add basic ergonomics: usage/help text, logging, and timing.
- Package your work so it is reusable.

## Capstone Ideas (Pick One)
- Log summarizer: Parse a log directory, extract top errors, email or save a report.
- Backup sync: Tar or `rsync` a project to a dated archive or remote host.
- Project scaffolder: Create a directory tree with starter files and git init.
- Remote fetcher: Pull data from an API with `curl`, transform, and store locally.

## Suggested Workflow
1) Define inputs/outputs: flags, source paths, destinations, temp directories.
2) Draft usage/help: `usage() { echo "Usage: $0 [options]"; }`.
3) Start with a skeleton script: shebang, `set -euo pipefail`, argument parsing (basic `while getopts "o:s:" opt; do ... done`).
4) Implement core steps:
   - Validate paths and permissions.
   - Use pipelines for filtering/formatting data.
   - Add logging to stderr (e.g., `echo "[info] ..." >&2`).
5) Add safety:
   - Trap cleanup: `trap 'rm -rf "$TMPDIR"' EXIT` for temp work.
   - Use `mktemp -d` for temporary directories.
   - Quote all expansions; handle spaces.
6) Test incrementally with small datasets; add `set -x` temporarily when debugging.
7) Package: place script in `~/bin`, mark executable, document prerequisites.

## Example Skeleton (Backup)
```sh
#!/usr/bin/env bash
set -euo pipefail
usage() { echo "Usage: $0 -s <source> -d <dest>" >&2; }
while getopts "s:d:" opt; do
  case $opt in
    s) src=$OPTARG;;
    d) dst=$OPTARG;;
    *) usage; exit 1;;
  esac
done
: "${src:?source required}" "${dst:?dest required}"

stamp=$(date +%Y%m%d-%H%M%S)
archive="$dst/backup-$stamp.tar.gz"

mkdir -p "$dst"
tar -czf "$archive" -C "$src" .
echo "Wrote $archive"
```

## Exercises (Hands-On)
1) Pick one capstone idea and sketch inputs/outputs; write a short README describing purpose and usage.
2) Implement argument parsing with `getopts`; add a `-h` flag for help.
3) Add logging functions (`log_info`, `log_warn`) that write to stderr.
4) Measure runtime with `time ./script.sh ...`; experiment with `pv` in pipelines if available.
5) Add a simple test: run the script against sample data and check expected outputs.

## Check Your Understanding
- Why is incremental testing crucial when chaining many commands?
- How do you ensure temporary files are always cleaned up?
- What makes a script portable across environments?

## Common Pitfalls
- Hardcoding paths and assumptions about the environment (shell, tools installed).
- Skipping error handling around `tar`, `ssh`, or `curl` calls; always check exit codes.
- Forgetting to document prerequisites and usage, making the script hard for others to run.

## Next Steps and Further Learning
- Add linting with `shellcheck` if available.
- Learn `make` to orchestrate tasks, and deepen git CLI skills.
- Explore container CLIs (Docker/Podman) and advanced shells (zsh/fish) for productivity.

##### Copyright (c) 2026 ChipVerge

