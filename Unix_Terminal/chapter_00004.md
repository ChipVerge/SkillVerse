# Chapter 4: Streams, Pipes, and Text Tools

## What You Will Learn
- Redirect input/output and chain commands with pipelines.
- Use common text-processing tools to filter, transform, and summarize data.
- Understand pipeline exit status and subshell vs. grouping.

## Key Concepts
- Standard streams: stdin (0), stdout (1), stderr (2).
- Redirection: `>` overwrite, `>>` append, `<` input, `2>` stderr, `&>` or `2>&1` combine.
- Pipelines: `cmd1 | cmd2`; each command reads from previous stdout.
- Subshell `( )` vs. grouping `{ }`: environment inheritance and side effects.
- `tee` to split output to file and stdout.
- Pipeline status: last command's exit code; use `set -o pipefail` in scripts to catch upstream failures.

## Essential Commands and Patterns
- `grep -n "pattern" file` (or `rg` if available) for searching.
- `sed 's/old/new/g'`, `sed -n '1,5p'` for line filtering.
- `awk '{print $1, $3}'` for column extraction and light processing.
- `cut -d, -f1,3`, `tr 'A-Z' 'a-z'`, `sort`, `uniq -c`, `wc -l`.
- `xargs -n1` to build commands from input.
- `tee file` to capture and continue the pipeline.

### Examples
```sh
# Save stdout, keep stderr on screen
mycmd >out.log

# Append both stdout and stderr
mycmd &>> combined.log

# Simple pipeline: find errors and count
grep -i "error" app.log | wc -l

# Extract column 1 from CSV, count frequency
cut -d, -f1 data.csv | sort | uniq -c | sort -nr | head

# Replace text inline (backup with .bak)
sed -i.bak 's/foo/bar/g' notes.txt

# Use tee to inspect and save
ps aux | grep nginx | tee /tmp/nginx.txt

# Subshell vs. grouping
(cd ~/nav_play && ls)   # does not change current shell
{ cd ~/nav_play; ls; }  # changes current shell
```

## Exercises (Hands-On)
1) Redirect: Run `echo "hello" > /tmp/hello.txt`, then append `world` with `>>` and view with `cat`.
2) Stderr: Run `ls nosuchfile 2> /tmp/err.log`; inspect the error file.
3) Pipeline: Count lines containing `WARN` in a log: `grep WARN app.log | wc -l`.
4) Columns: Given `data.csv`, extract column 2 and deduplicate: `cut -d, -f2 data.csv | sort | uniq`.
5) `tee`: Run `ls -l /usr/bin | tee /tmp/bin.txt | head`.

## Mini-Lab: Log Summary One-Liner
Goal: Find the top 5 IPs hitting your web server from `access.log`.
```sh
awk '{print $1}' access.log | sort | uniq -c | sort -nr | head -n 5
```
Stretch: Filter only status 500 lines before counting: `awk '$9==500 {print $1}' access.log | ...`.

## Check Your Understanding
- How do you redirect only stderr? How do you merge stderr into stdout?
- When do you need `tee` in a pipeline?
- What is the difference between `(cd /tmp; ls)` and `{ cd /tmp; ls; }`?

## Common Pitfalls
- Overwriting files unintentionally with `>`; consider `set -o noclobber` or use `>>` when appropriate.
- Forgetting quotes around patterns containing `?` or `*` when you intend literal matches.
- Assuming `sed -i` works the same across systems; BSD `sed` requires a backup suffix (e.g., `-i ''`).

## Prep for Next Chapter
- Keep a sample log and CSV handy; you'll need them while managing processes and automation.

##### Copyright (c) 2026 ChipVerge

