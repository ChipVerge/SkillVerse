# Chapter 8: Networking and Remote Workflows

## What You Will Learn
- Connect to remote systems securely with SSH.
- Transfer files with `scp`/`sftp` and set up SSH config entries.
- Use port forwarding for tunneling.
- Fetch resources and APIs with `curl`/`wget`.
- Inspect basic network state with `netstat`/`ss`.

## Key Concepts
- SSH key pairs: private vs. public; passphrases; agents (`ssh-agent` / `ssh-add`).
- `~/.ssh/config` for host aliases, identities, ports, and forwarding.
- Port forwarding: local `-L` and remote `-R`; SOCKS `-D`.
- Basic HTTP operations: `GET`, `HEAD`; status codes; headers.
- Network sockets and listening ports; privilege differences (<1024 vs higher).

## Essential Commands and Snippets
```sh
# Generate an ed25519 key
ssh-keygen -t ed25519 -C "you@example.com"

# Add key to agent
ssh-add ~/.ssh/id_ed25519

# SSH config entry (~/.ssh/config)
Host work
  HostName work.example.com
  User alice
  IdentityFile ~/.ssh/id_ed25519
  Port 22

# Connect using alias
ssh work

# Copy files
scp file.txt work:/home/alice/
scp -r dir/ work:/home/alice/dir

# Port forward local 8080 to remote 80
ssh -L 8080:localhost:80 work

# Fetch headers from a site
curl -I https://example.com

# Download a file
wget https://example.com/file.tar.gz

# List listening sockets
ss -tuln | head   # or netstat -tuln
```

## Exercises (Hands-On)
1) Generate a new SSH key (ed25519). View the public key and copy it to a test host (or a local VM) using `ssh-copy-id` if available.
2) Create an SSH config alias `playbox` pointing to a host/VM you control; test `ssh playbox`.
3) Transfer a file to the host with `scp` and verify its checksum on both ends (`sha256sum`).
4) Set up a local port forward: `ssh -L 9000:localhost:22 playbox` and test `ssh -p 9000 localhost` in another terminal.
5) Use `curl -s https://httpbin.org/get | head` to inspect JSON; pretty-print with `python -m json.tool` if `jq` is unavailable.

## Mini-Lab: Remote Log Grabber
- Goal: Fetch `/var/log/syslog` (or `/var/log/messages`) from a remote host, store locally with timestamp, and keep permissions sane.
- Steps:
  - Create `~/logs` locally.
  - `scp playbox:/var/log/syslog ~/logs/syslog-$(date +%Y%m%d).log`
  - Run `ls -lh ~/logs` to verify size and timestamp.

## Check Your Understanding
- What is stored in the private key vs. public key? Why protect the private key with a passphrase?
- How does `ssh -L` differ from `ssh -R`?
- When would you prefer `curl -I` over `curl -s`?

## Common Pitfalls
- Incorrect file permissions on `~/.ssh` or keys (fix with `chmod 700 ~/.ssh` and `chmod 600 ~/.ssh/*`).
- Forgetting to add the correct key to `ssh-agent`, leading to password prompts.
- Leaving long-running port forwards open and conflicting with local ports.

## Prep for Next Chapter
- Save a few failing command examples (PATH issues, permission errors) to practice troubleshooting.

##### Copyright (c) 2026 ChipVerge

