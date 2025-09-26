# Lab 03 Walkthrough: Text Processing and Redirection

## Overview
This lab focuses on essential RHCSA skills for text processing, using grep, and understanding input/output redirection. These are fundamental skills for system administration and log analysis.

## Key Concepts

### Redirection Operators
- `>` : Redirect output to file (overwrite)
- `>>` : Redirect output to file (append)
- `<` : Redirect input from file
- `|` : Pipe output to another command
- `2>` : Redirect stderr to file
- `2>&1` : Redirect stderr to stdout
- `&>` : Redirect both stdout and stderr

### Grep Options
- `-c` : Count matching lines
- `-i` : Case insensitive search
- `-v` : Invert match (show non-matching lines)
- `-n` : Show line numbers
- `-E` : Extended regex (egrep)
- `-r` : Recursive search

## Complete Solution

### Initial Setup
```bash
# Run the setup script to initialize the lab
./setup.sh

# Explore the directory structure
tree
```

### Task 1: Copy Log Files for Analysis
```bash
# Copy all log files from logs/ to workspace/analysis/
cp logs/*.log workspace/analysis/

# Verify the copy
ls -la workspace/analysis/
```

### Task 2: Analyze Failed Login Attempts
```bash
# Count FAILED login attempts and save to file
grep -c "FAILED" workspace/analysis/security.log > workspace/reports/failed-count.txt

# Alternative: Count from original location
grep -c "FAILED" logs/security.log > workspace/reports/failed-count.txt
```

### Task 3: Extract Unique IP Addresses
```bash
# Extract first field (IP addresses) from access.log, sort, and get unique
awk '{print $1}' workspace/analysis/access.log | sort -u > workspace/reports/ip-addresses.txt

# Alternative using cut:
cut -d' ' -f1 workspace/analysis/access.log | sort -u > workspace/reports/ip-addresses.txt
```

### Task 4: Consolidate ERROR Entries
```bash
# Find all ERROR entries across all log files
grep "ERROR" workspace/analysis/*.log >> workspace/reports/all-errors.txt

# Alternative: Include filename in output
grep -H "ERROR" logs/*.log >> workspace/reports/all-errors.txt
```

### Task 5: Create Error Summary Report
```bash
# Extract error messages, count occurrences, sort by frequency, get top 5
grep "ERROR" workspace/analysis/*.log | sed 's/.*ERROR //' | sort | uniq -c | sort -rn | head -5 > workspace/reports/error-summary.txt

# Alternative: More detailed error extraction
grep -h "ERROR" logs/*.log | awk '{for(i=1;i<=NF;i++) if($i=="ERROR") {for(j=i+1;j<=NF;j++) printf "%s ", $j; print ""}}' | sort | uniq -c | sort -rn | head -5 > workspace/reports/error-summary.txt
```

### Task 6: Capture Processing Errors
```bash
# Test with an intentional error command
ls /nonexistent/directory 2> workspace/reports/processing-errors.txt

# Or append errors from multiple commands
cat /fake/file 2>> workspace/reports/processing-errors.txt
grep "pattern" /no/such/file 2>> workspace/reports/processing-errors.txt
```

### Task 7: Secure Report Files
```bash
# Set 640 permissions on all files in workspace/reports/
chmod 640 workspace/reports/*

# Verify permissions
ls -l workspace/reports/
```

### Task 8: Move Completed Reports
```bash
# Move all reports from workspace/reports/ to results/
mv workspace/reports/* results/

# Verify move completed
ls workspace/reports/  # Should be empty
ls results/           # Should contain all reports
```

### Task 9: Archive Original Logs
```bash
# Copy logs to archive with timestamp preservation
cp -p logs/*.log archive/

# Set proper permissions on archived files
chmod 644 archive/*.log

# Verify archival
ls -l archive/
```

## Complete Command Sequence (One-liner approach)
```bash
# For experienced users, here's the complete solution:
cp logs/*.log workspace/analysis/ && \
grep -c "FAILED" logs/security.log > workspace/reports/failed-count.txt && \
awk '{print $1}' logs/access.log | sort -u > workspace/reports/ip-addresses.txt && \
grep "ERROR" logs/*.log >> workspace/reports/all-errors.txt && \
grep "ERROR" logs/*.log | sed 's/.*ERROR //' | sort | uniq -c | sort -rn | head -5 > workspace/reports/error-summary.txt && \
ls /fake 2> workspace/reports/processing-errors.txt && \
chmod 640 workspace/reports/* && \
mv workspace/reports/* results/ && \
cp -p logs/*.log archive/ && \
chmod 644 archive/*.log
```

## Common Mistakes to Avoid

1. **Using > instead of >>** : The > operator overwrites files, while >> appends. Be careful when consolidating data.

2. **Forgetting to redirect stderr**: Regular output goes to stdout, but errors go to stderr. Use 2> to capture errors.

3. **Wrong pipeline order**: The order matters in pipelines. Always test each stage.

4. **Not preserving timestamps**: Use cp -p to preserve file attributes when archiving.

5. **Incorrect permission format**: Remember chmod uses octal (640, not 6-4-0).

## Real-World Applications

### Security Analysis
```bash
# Find all failed SSH attempts from a specific IP
grep "FAILED.*192.168.1.100" /var/log/secure

# Count login attempts per IP
awk '/FAILED/ {print $NF}' /var/log/secure | sort | uniq -c | sort -rn
```

### Performance Monitoring
```bash
# Extract response times from access logs
awk '{print $10}' access.log | sort -n | tail -10

# Find slow queries in database logs
grep "duration: [0-9]\{4,\}" postgresql.log
```

### Log Rotation Script
```bash
# Archive and compress old logs
find /var/log -name "*.log" -mtime +7 -exec gzip {} \; 2>/var/log/compression-errors.txt
```

## Advanced Grep Techniques

### Using Extended Regex
```bash
# Find IPs in specific ranges
grep -E "192\.168\.[0-9]{1,3}\.[0-9]{1,3}" access.log

# Find multiple patterns
grep -E "ERROR|CRITICAL|FATAL" application.log
```

### Context Lines
```bash
# Show 2 lines before and after match
grep -C 2 "ERROR" system.log

# Show 3 lines after match
grep -A 3 "Connection failed" application.log
```

## Pipeline Mastery

### Complex Pipeline Example
```bash
# Find top 10 requesting IPs with their request counts and total bytes
awk '{ip[$1]++; bytes[$1]+=$10} END {for (i in ip) print ip[i], i, bytes[i]}' access.log | \
sort -rn | \
head -10 | \
awk '{print "Count:", $1, "IP:", $2, "Bytes:", $3}'
```

## Verification
```bash
# Run the check script to verify all tasks
./check.sh
```

## Key Takeaways

1. **Always test commands** before redirecting output to important files
2. **Use append (>>) carefully** to avoid overwriting data
3. **Understand the difference** between stdout and stderr
4. **Master grep patterns** for efficient log analysis
5. **Practice pipeline construction** for complex data processing
6. **Remember file permissions** for security
7. **Document your commands** for future reference

## Next Steps

After completing this lab, you should be comfortable with:
- All forms of input/output redirection
- Using grep with various options and patterns
- Constructing pipelines for data processing
- Managing file permissions
- Organizing files and directories efficiently

These skills are essential for the RHCSA exam and daily system administration tasks.