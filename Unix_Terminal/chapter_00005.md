# Chapter 5: Processes and Job Control

## What You Will Learn
- Inspect running processes and system load.
- Send signals to control or terminate processes.
- Run jobs in the background and manage them interactively.
- Schedule or time-limit commands.

## Key Concepts
- PIDs, PPIDs, process groups, and sessions.
- Signals: SIGINT (2), SIGTERM (15), SIGKILL (9), SIGHUP (1).
- Foreground vs. background jobs; job IDs (`%1`, `%2`).
- Priorities: `nice` values and `renice` to adjust.
- Time-limited execution with `timeout`.

## Essential Commands
- Listing: `ps -ef` or `ps aux`, `pgrep <name>`, `top`/`htop`.
- Controlling: `kill -SIGTERM <pid>`, `pkill <pattern>`, `killall <name>` (system-dependent).
- Job control: append `&`, `jobs`, `fg %1`, `bg %1`, `Ctrl+Z` to suspend.
- Background resilience: `nohup <cmd> &`, `disown` (shell builtin).
- Timing: `timeout 30s <cmd>`.
- Scheduling: `at 10:00 < <file>`; `crontab -e` for recurring tasks (if available).

### Examples
```sh
# Start a long task in background
sleep 300 &
jobs
fg %1          # bring it back

# Find PIDs for "nginx" and terminate
pgrep nginx
pkill -TERM nginx

# Run command for at most 5 seconds
timeout 5s curl -I https://example.com

top            # or htop if installed

# Keep running after terminal closes
nohup ./server >server.log 2>&1 &
```

## Exercises (Hands-On)
1) Start `sleep 120 &`, list jobs, bring it foreground, then interrupt with `Ctrl+C`.
2) Launch `tail -f /etc/hosts` and suspend with `Ctrl+Z`; resume in background with `bg %1`; bring it back with `fg %1`.
3) Use `ps -ef | grep ssh` to locate SSH processes; try `pgrep ssh`.
4) Create a CPU-bound loop: `python -c "while True: pass"` (if python installed); find its PID and terminate with `kill -TERM <pid>`.
5) Run a command with `timeout 3s sleep 10` and observe exit status `$?`.

## Mini-Lab: Resource Watchdog
- Start `yes > /dev/null &` to simulate load (stop it after!).
- In another shell, observe with `top` or `htop`.
- Use `renice` to lower its priority, then `kill` to stop it.

## Check Your Understanding
- What is the difference between SIGTERM and SIGKILL? When would you use each?
- How do you resume a stopped job in the background? In the foreground?
- How do you find all processes matching a name without using `ps | grep`?

## Common Pitfalls
- Killing the wrong process due to an overly broad pattern with `pkill`.
- Forgetting that `nohup` still writes output unless redirected.
- Assuming `timeout` is available on every system; some minimal environments may lack it.

## Prep for Next Chapter
- Gather a few repetitive tasks you wish to automate; you'll script them next.

##### Copyright (c) 2026 ChipVerge

