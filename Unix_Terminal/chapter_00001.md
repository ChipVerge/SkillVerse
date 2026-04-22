# Chapter 1: Terminal Foundations

## What You Will Learn
- Distinguish shell vs. terminal emulator and how they connect to a TTY/PTY.
- Use standard streams (stdin, stdout, stderr) and interpret exit codes.
- Get help for commands with `man`, `--help`, and shell built-ins.
- Run and inspect simple commands (`echo`, `printf`, history, clearing the screen).

## Key Concepts
- **Terminal emulator**: The window/app providing input/output; **shell**: The program reading commands (e.g., bash, zsh).
- **TTY/PTY**: Pseudo-terminals back the emulator; commands read from stdin, write to stdout/stderr.
- **Exit codes**: `0` = success; non-zero = some error/condition; check with `$?`.
- **Built-ins vs. binaries**: Shell built-ins (`cd`, `alias`, `help`) vs. external programs (`ls`, `grep`).
- **Standard streams**: stdin, stdout, stderr; redirection uses them (covered deeper in Chapter 4).

## Essential Commands
- `echo`, `printf`: Print values; prefer `printf` for predictable formatting.
- `clear` or `Ctrl+L`: Clear visible screen.
- `history`, `!n`, `!!`: Recall commands; use with care when commands contain secrets.
- `type`, `which`, `command -V`: See how a command will resolve (built-in, alias, path).
- `man <cmd>`, `<cmd> --help`, `help <builtin>`: Read docs; `/` to search, `q` to quit in `man`.

### Examples
```sh
# Show how `ls` is resolved
type ls

# Print a formatted line
printf "User: %s\nHome: %s\n" "$USER" "$HOME"

# View help for a built-in
help cd

# View manual for grep (press q to exit)
man grep
```

## Exercises (Hands-On)
1) Identify shell and terminal: Run `echo $0` and note your shell; find the terminal emulator name.
2) Exit codes: Run `true`, `false`, and check `$?` after each. Create a nonexistent directory listing: `ls nosuchdir`; note exit code.
3) Command resolution: Compare `type echo`, `which echo`, and `command -V echo`. Do the same for `cd` and `ls`.
4) Use help: Open `man printf`; find the `%d` and `%s` specifiers. Use `grep -n "%s"` on the man output (with `man printf | grep -n "%s" | head`).
5) History: Run three commands, then inspect `history | tail -n 5`. Re-run the previous command with `!!` (ensure it is safe first).

## Mini-Lab: Build a Tiny Info Script
Goal: Write a one-liner that prints user, shell, and current TTY.

```sh
printf "User=%s\nShell=%s\nTTY=%s\n" "$USER" "$SHELL" "$(tty)"
```

Stretch: Save it as `~/bin/whoami-tty` (make sure `~/bin` is on PATH) and make it executable with `chmod +x ~/bin/whoami-tty`.

## Check Your Understanding
- What is the difference between stdout and stderr, and why does it matter?
- How do you determine whether a command is a shell built-in or an external binary?
- After running a command, how do you check if it succeeded?
- How do you search within a man page?

## Common Pitfalls
- Forgetting to quote variables when printing (e.g., paths with spaces) — will be revisited in Chapter 2.
- Assuming `which` shows aliases/functions; use `type` or `command -V` for full picture.
- Using history substitution (`!!`) blindly; always verify what will re-run.

## Prep for Next Chapter
- Practice absolute vs. relative paths with `pwd` and `cd`.
- Enable tab completion in your shell if not already on (typically default). 

##### Copyright (c) 2026 ChipVerge

