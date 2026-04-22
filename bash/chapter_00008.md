# Practical Examples of Bash Scripting

Bash scripting excels at automating a wide range of tasks, from simple file manipulations to complex system administration. This section provides practical examples of Bash scripts that address common real-world scenarios.

## Backup Scripts: Automating Data Protection

Backup scripts are essential for safeguarding your data by automating the process of creating copies of files and directories. Regular backups protect against data loss due to hardware failures, accidental deletions, or other unforeseen events.

**Basic Backup Script:**

```bash
#!/bin/bash

# --- Configuration ---
source_dir="/path/to/source/directory"  # Directory to backup
backup_dir="/path/to/destination/backup" # Destination for backups
backup_prefix="daily_backup"           # Prefix for backup archive names

# --- Script Logic ---

# Ensure backup directory exists
mkdir -p "$backup_dir"

# Generate timestamp for backup archive name (YYYYMMDD format)
timestamp=$(date +%Y%m%d)

# Create a compressed tar archive of the source directory
backup_file="$backup_dir/${backup_prefix}_${timestamp}.tar.gz"
tar -czf "$backup_file" "$source_dir"

# Check if the backup was successful
if [ $? -eq 0 ]; then
  echo "Backup created successfully: $backup_file"
else
  echo "Error: Backup failed. See error messages above."
  exit 1  # Exit with a non-zero status to indicate failure
fi

echo "Backup process completed."
```

**Explanation:**

*   **Configuration Section:**  Variables at the beginning of the script (`source_dir`, `backup_dir`, `backup_prefix`) make it easy to customize the script without modifying the core logic.  **It's crucial to replace the placeholder paths** with your actual source and destination directories.
*   **Directory Creation:** `mkdir -p "$backup_dir"` ensures that the backup destination directory exists. The `-p` option creates parent directories if they don't exist, preventing errors.
*   **Timestamping:** `timestamp=$(date +%Y%m%d)` generates a timestamp in `YYYYMMDD` format, which is appended to the backup archive name, creating a dated backup.
*   **Tar Archiving and Compression:** `tar -czf "$backup_file" "$source_dir"` uses the `tar` command to:
    *   `-c`: Create a new archive.
    *   `-z`: Compress the archive using gzip.
    *   `-f "$backup_file"`: Specify the name of the archive file.
    *   `"$source_dir"`:  Specify the directory to be archived.
*   **Error Checking:** `if [ $? -eq 0 ]` checks the exit status of the `tar` command. If it's `0` (success), a success message is printed. Otherwise, an error message is displayed, and the script exits with a non-zero status (`exit 1`) to indicate failure.

**Enhancements and Considerations for Backup Scripts:**

*   **Incremental or Differential Backups:** For large datasets, consider implementing incremental or differential backups to save space and time by only backing up changes since the last full or previous backup.  Tools like `rsync` or `tar` with `--incremental` options can be used.
*   **Remote Backups:** Backing up data to a remote server or cloud storage provides offsite protection. You can use tools like `scp`, `rsync`, or specialized backup utilities for remote backups.
*   **Backup Rotation:** Implement a backup rotation strategy to manage backup storage space. This involves deleting older backups according to a schedule (e.g., keep daily backups for a week, weekly backups for a month, monthly backups for a year).
*   **Logging:** Add logging to record backup activities, successes, and failures. This can be helpful for monitoring and troubleshooting. You can redirect script output to a log file or use the `logger` command.
*   **Encryption:** For sensitive data, encrypt your backups to protect confidentiality. `tar` and other backup tools can be combined with encryption utilities like `gpg` or `openssl`.
*   **Testing Backups:** Regularly test your backups by restoring data to ensure they are working correctly and that you can recover data when needed.

## Automation Scripts: Streamlining Repetitive Tasks

Automation scripts are designed to automate repetitive tasks, saving you time, reducing errors, and increasing efficiency. Bash is well-suited for automating system administration tasks, file processing, and various other operations.

**Example: Batch File Renaming with Backup**

```bash
#!/bin/bash

# --- Configuration ---
file_extension=".txt"      # Extension of files to process
backup_extension=".bak"     # Extension for backup files

# --- Script Logic ---

# Loop through all files with the specified extension in the current directory
for file in *"$file_extension"; do
  if [ -f "$file" ]; then # Ensure it's a regular file

    backup_file="${file}${backup_extension}" # Create backup filename

    # Check if backup file already exists - prevent accidental overwrite
    if [ -e "$backup_file" ]; then
      echo "Warning: Backup file '$backup_file' already exists. Skipping '$file'."
      continue # Skip to the next file
    fi

    # Create a backup of the original file
    cp "$file" "$backup_file"

    # Rename the original file (remove extension)
    new_filename="${file%"$file_extension"}" # Remove extension
    mv "$file" "$new_filename"

    echo "Renamed '$file' to '$new_filename' (backup created: '$backup_file')"
  else
    echo "Warning: '$file' is not a regular file. Skipping."
  fi
done

echo "Batch renaming process completed."
```

**Explanation:**

*   **Configuration Variables:**  `file_extension` and `backup_extension` variables at the beginning allow easy modification of the script's behavior to process different file types or use different backup extensions.
*   **Looping through Files:** `for file in *"$file_extension"` iterates through all files in the current directory that match the specified `file_extension` (e.g., `*.txt`).
*   **File Type Check:** `if [ -f "$file" ]` ensures that the script only processes regular files and not directories or other special file types.
*   **Backup Creation:**
    *   `backup_file="${file}${backup_extension}"` constructs the backup filename by appending the `backup_extension` to the original filename.
    *   `if [ -e "$backup_file" ]` checks if a backup file with the same name already exists to prevent accidental overwriting of existing backups.
    *   `cp "$file" "$backup_file"` creates a copy of the original file as a backup before renaming.
*   **Renaming:**
    *   `new_filename="${file%"$file_extension"}"` uses Bash's parameter expansion `${file%"$file_extension"}` to remove the specified `file_extension` from the end of the filename.
    *   `mv "$file" "$new_filename"` renames the original file to the new filename (without the extension).
*   **Informative Output:** The script provides messages indicating which files were renamed and whether backups were created, as well as warnings for non-regular files or existing backup files.

**Further Automation Script Ideas:**

*   **System Maintenance:** Scripts to clean up temporary files, rotate logs, check disk space, monitor system services, and perform other routine system maintenance tasks.
*   **Report Generation:** Scripts to extract data from various sources (log files, databases, APIs), process it, and generate reports in different formats (text, CSV, HTML).
*   **Software Deployment:** Scripts to automate the deployment of applications, including copying files, configuring settings, restarting services, and running tests.
*   **User Account Management:** Scripts to automate user creation, modification, and deletion, as well as managing user permissions and groups.
*   **Scheduled Tasks (Cron Jobs):** Use `cron` to schedule automation scripts to run automatically at specific times or intervals.

## Parsing Logs: Extracting Insights from Data

Log files are a valuable source of information about system events, application behavior, and security incidents. Bash scripts can be used to parse log files, extract relevant information, and generate summaries or alerts.

**Example: Extracting and Counting Error Messages from a Log File**

```bash
#!/bin/bash

log_file="/var/log/syslog"  # Path to the log file to analyze
search_pattern="error"      # Pattern to search for (case-insensitive)

# --- Script Logic ---

# Check if the log file exists
if [ ! -f "$log_file" ]; then
  echo "Error: Log file '$log_file' not found."
  exit 1
fi

# Use grep to find lines containing the search pattern (case-insensitive -i)
grep -i "$search_pattern" "$log_file" | while IFS= read -r log_line; do
  # Process each matching log line (for now, just print the line)
  echo "Found error: $log_line"
done

# Count the number of error lines found
error_count=$(grep -i -c "$search_pattern" "$log_file")
echo "Total error count: $error_count"

echo "Log parsing completed."
```

**Explanation:**

*   **Configuration:** `log_file` and `search_pattern` variables define the log file to analyze and the pattern to search for, making the script adaptable.
*   **Log File Existence Check:** `if [ ! -f "$log_file" ]` verifies that the specified log file exists before attempting to process it.
*   **`grep` for Pattern Matching:**
    *   `grep -i "$search_pattern" "$log_file"` uses `grep` to search for lines in the log file that contain the `search_pattern`. The `-i` option makes the search case-insensitive.
    *   The output of `grep` (matching lines) is piped (`|`) to a `while` loop.
*   **Processing Log Lines (Within the `while` loop):**
    *   `while IFS= read -r log_line` reads each line from the output of `grep` into the `log_line` variable. `IFS=` and `-r` are used for robust line reading, especially when dealing with spaces or backslashes in log lines.
    *   `echo "Found error: $log_line"` (currently) simply prints each matching log line.  In a more advanced script, you could perform more complex processing on each `log_line` (e.g., extract specific fields, categorize errors, etc.).
*   **Counting Matches:** `error_count=$(grep -i -c "$search_pattern" "$log_file")` uses `grep -c` to count the number of lines that match the pattern. The `-c` option tells `grep` to only output the count instead of the matching lines.
*   **Outputting Results:** The script prints each found error line and the total count of errors.

**Advanced Log Parsing Techniques:**

*   **`awk` for Field Extraction and Processing:** `awk` is a powerful text processing tool ideal for extracting specific fields from structured log files (e.g., logs in CSV, space-delimited, or custom formats). You can use `awk` to filter logs based on fields, perform calculations, and format output.
*   **`sed` for Text Transformation:** `sed` (stream editor) is useful for performing text substitutions, deletions, and other transformations on log lines. You can use `sed` to clean up log data, reformat it, or extract specific parts of lines.
*   **Regular Expressions:** Use regular expressions with `grep`, `awk`, or `sed` for more complex pattern matching and extraction. Regular expressions allow you to define flexible patterns to find specific types of log entries.
*   **Log Rotation Analysis:** Analyze rotated log files (e.g., `syslog.1`, `syslog.2.gz`) by iterating through them and processing them sequentially or using tools like `zgrep` to search within compressed logs.
*   **Specialized Log Analysis Tools:** For more sophisticated log analysis, consider using specialized tools like `GoAccess` (for web server logs), `Logwatch`, `Fail2ban`, or centralized logging systems like the ELK stack (Elasticsearch, Logstash, Kibana) or Splunk. Bash scripts can be used to pre-process data before feeding it into these tools or to automate tasks related to these systems.

## System Monitoring Scripts: Keeping Tabs on System Health

System monitoring scripts are crucial for proactively tracking the health and performance of your systems. They can monitor resource usage, detect anomalies, and send alerts when critical thresholds are reached, allowing you to address issues before they cause significant problems.

**Example: Disk Usage Monitoring with Alerting**

```bash
#!/bin/bash

# --- Configuration ---
disk_mount_point="/"        # Mount point to monitor (e.g., "/", "/var", "/home")
usage_threshold=80          # Disk usage threshold in percentage
alert_email="admin@example.com" # Email address to send alerts to (optional)

# --- Script Logic ---

# Get disk usage percentage for the specified mount point
disk_usage=$(df "$disk_mount_point" | awk 'NR==2{ print $5 }' | sed 's/%//')

# Check if disk usage exceeds the threshold
if [ "$disk_usage" -gt "$usage_threshold" ]; then
  alert_message="Warning: Disk usage on '$disk_mount_point' is above ${usage_threshold}% (${disk_usage}%)."
  echo "$alert_message"

  # Optional: Send an email alert (requires mail command to be configured)
  if [ -n "$alert_email" ]; then # Check if alert_email is not empty
    echo "$alert_message" | mail -s "Disk Usage Alert" "$alert_email"
    echo "Alert email sent to $alert_email"
  fi
fi

echo "Disk usage monitoring completed."
```

**Explanation:**

*   **Configuration Variables:** `disk_mount_point`, `usage_threshold`, and `alert_email` variables make the script configurable for different mount points, thresholds, and alert destinations.
*   **Disk Usage Calculation:**
    *   `df "$disk_mount_point"`: The `df` command displays disk space usage information for the specified mount point.
    *   `awk 'NR==2{ print $5 }'`: `awk` is used to extract the 5th field (disk usage percentage) from the second line of `df`'s output (the second line contains the usage for the specified mount point; the first is the header). `NR==2` selects the second line, and `{ print $5 }` prints the 5th field.
    *   `sed 's/%//'`: `sed` removes the percentage sign (`%`) from the end of the disk usage value, making it a plain number for numerical comparison.
    *   `disk_usage=$(...)`: Command substitution captures the output of the pipeline into the `disk_usage` variable.
*   **Threshold Check:** `if [ "$disk_usage" -gt "$usage_threshold" ]` compares the extracted disk usage with the configured `usage_threshold`.
*   **Alerting:**
    *   If the disk usage exceeds the threshold, an `alert_message` is constructed.
    *   `echo "$alert_message"`: The alert message is printed to the console.
    *   **Optional Email Alert:**
        - `if [ -n "$alert_email" ]`: Checks if the `alert_email` variable is not empty (meaning an email address is configured).
        - `echo "$alert_message" | mail -s "Disk Usage Alert" "$alert_email"`: If an email address is configured, the `mail` command is used to send an email alert.  **Note:** This requires the `mail` command to be installed and properly configured on your system to send emails.  You might need to install a mail transfer agent (MTA) like `postfix` or `sendmail` and configure it.
*   **Informative Output:** The script prints a message indicating the completion of disk usage monitoring.

**System Resources to Monitor (Beyond Disk Usage):**

*   **CPU Usage:** Monitor CPU load average, per-core usage, and identify CPU-intensive processes using commands like `top`, `uptime`, `mpstat`, or `/proc/loadavg`.
*   **Memory Usage:** Track RAM usage, swap usage, and identify memory-hungry processes using commands like `free`, `vmstat`, `top`, or `/proc/meminfo`.
*   **Network Traffic:** Monitor network interface traffic, bandwidth usage, and network connections using commands like `ifconfig`, `ip`, `netstat`, `ss`, or `tcpdump`.
*   **Process Monitoring:** Monitor specific processes or services to ensure they are running and responsive. You can use `ps`, `pgrep`, or process monitoring tools.
*   **System Load:** Monitor system load average as an overall indicator of system load.
*   **Login Attempts/Security Events:** Monitor log files for failed login attempts, security breaches, or other security-related events.
*   **Custom Application Metrics:** Monitor application-specific metrics by querying application logs, APIs, or using monitoring agents.

**Alerting Mechanisms:**

*   **Email Alerts:** Use the `mail` command (as shown in the example) or more advanced email sending tools to send email notifications.
*   **SMS/Text Message Alerts:** Integrate with SMS gateway services or use command-line SMS tools to send text message alerts to mobile devices.
*   **Push Notifications:** Use push notification services to send alerts to mobile apps or desktop notification systems.
*   **Logging to Centralized Monitoring Systems:** Integrate your scripts with centralized monitoring platforms like Nagios, Zabbix, Prometheus, Grafana, or cloud-based monitoring services to send alerts and visualize monitoring data.

## Exercise: Batch Rename `.log` Files with Backup

**Task:**

Create a Bash script that renames all files in a directory ending with the extension `.log` to `.log.bak`.  The script should:

1.  **Iterate** through all files in the **current directory** that have the `.log` extension.
2.  For each `.log` file found:
    *   **Create a backup** of the original `.log` file by copying it to a file with the same name but with the extension `.log.orig` (e.g., `mylog.log` becomes `mylog.log.orig`).
    *   **Rename** the original `.log` file to have the extension `.log.bak` (e.g., `mylog.log` becomes `mylog.log.bak`).
    *   **Print a message** indicating the renaming operation performed for each file.
3.  Include **error handling** to check if backup files already exist and prevent overwriting them. If a backup file already exists, print a warning message and skip renaming the current `.log` file.

**Example Solution:**

```bash
#!/bin/bash

# Script to rename .log files to .log.bak with backup to .log.orig

# Loop through all .log files in the current directory
for log_file in *.log; do
  if [ -f "$log_file" ]; then # Ensure it's a regular file

    backup_orig_file="${log_file}.orig" # Filename for .log.orig backup
    backup_bak_file="${log_file}.bak"    # Filename for .log.bak rename

    # Check if .log.orig backup already exists
    if [ -e "$backup_orig_file" ]; then
      echo "Warning: Backup file '$backup_orig_file' already exists. Skipping '$log_file'."
      continue # Skip to the next file
    fi

    # Check if .log.bak file already exists (prevent potential conflicts)
    if [ -e "$backup_bak_file" ]; then
      echo "Warning: Rename target '$backup_bak_file' already exists. Skipping '$log_file'."
      continue # Skip to the next file
    fi


    # Create backup to .log.orig
    cp "$log_file" "$backup_orig_file"

    # Rename .log to .log.bak
    mv "$log_file" "$backup_bak_file"

    echo "Renamed '$log_file' to '$backup_bak_file' (original backed up to '$backup_orig_file')"

  else
    echo "Warning: '$log_file' is not a regular file. Skipping."
  fi
done

echo "Log file renaming process completed."
```

##### Copyright (c) 2026 ChipVerge

