# RHCSA Lab 02 - File Operations and Permissions Walkthrough

## Complete Solution Guide

This walkthrough provides the exact command sequence to complete all tasks in Lab 02.

---

## Initial Setup and Exploration

First, run the setup script and explore the initial state:

```bash
# Reset the lab to initial state
./setup.sh

# Explore the directory structure
tree

# Check initial file permissions in incoming/
ls -la incoming/
```

**Expected Initial State:**
- `incoming/development-script.sh` should have `644` (not executable)
- `incoming/app-config.conf` should have `666` (world-writable - security issue)
- All `.txt` files should have `644` permissions

---

## Task 1: Move Text Files (Except meeting-notes.txt)

**Objective:** Move `project-notes.txt` and `team-contacts.txt` to `workspace/documents/`

```bash
# Move the specified text files
mv incoming/project-notes.txt workspace/documents/
mv incoming/team-contacts.txt workspace/documents/

# Verify the move
ls workspace/documents/
ls incoming/  # Should not show these files anymore
```

**Explanation:**
- `mv` command moves files from source to destination
- These files are completely relocated (not copied)
- `meeting-notes.txt` stays in `incoming/` for special handling in Task 2

---

## Task 2: Move and Rename Meeting Notes

**Objective:** Move `meeting-notes.txt` and rename it to `daily-standup.txt`

```bash
# Move and rename in one command
mv incoming/meeting-notes.txt workspace/documents/daily-standup.txt

# Verify the operation
ls workspace/documents/
# Should show: project-notes.txt, team-contacts.txt, daily-standup.txt
```

**Explanation:**
- `mv source destination` can rename during move operation
- The file is moved AND renamed in a single operation
- Original `meeting-notes.txt` no longer exists

---

## Task 3: Create Backup Copy

**Objective:** Copy `app-config.conf` to `archive/` for backup

```bash
# Create backup copy (original remains in incoming/)
cp incoming/app-config.conf archive/

# Verify both copies exist
ls incoming/app-config.conf      # Original should still exist
ls archive/app-config.conf       # Backup copy should exist
```

**Explanation:**
- `cp` creates a copy while leaving the original file intact
- This creates a backup before moving the original file
- Both locations now have the same file content

---

## Task 4: Move Original Configuration File

**Objective:** Move `app-config.conf` from `incoming/` to `workspace/configs/`

```bash
# Move the original config file
mv incoming/app-config.conf workspace/configs/

# Verify the move
ls workspace/configs/            # Should show app-config.conf
ls incoming/app-config.conf      # Should give "No such file" error
ls archive/app-config.conf       # Backup copy should still exist
```

**Explanation:**
- Now we have the backup in `archive/` and working copy in `workspace/configs/`
- Original file no longer exists in `incoming/`

---

## Task 5: Move Script and Fix Permissions

**Objective:** Move `development-script.sh` to `workspace/scripts/` and make it executable

```bash
# Move the script
mv incoming/development-script.sh workspace/scripts/

# Check current permissions (should be 644 - not executable)
ls -la workspace/scripts/development-script.sh

# Make it executable (755 permissions)
chmod 755 workspace/scripts/development-script.sh

# Verify it's now executable
ls -la workspace/scripts/development-script.sh
# Should show: -rwxr-xr-x
```

**Alternative Permission Methods:**
```bash
# Method 1: Add execute permission for all
chmod +x workspace/scripts/development-script.sh

# Method 2: Use octal notation (755)
chmod 755 workspace/scripts/development-script.sh

# Method 3: Specific permission syntax
chmod u+x,g+x,o+x workspace/scripts/development-script.sh
```

---

## Task 6: Set Configuration File Permissions

**Objective:** Set secure permissions (640) on files in `workspace/configs/`

```bash
# Set secure permissions on config file
chmod 640 workspace/configs/app-config.conf

# Verify the permissions
ls -la workspace/configs/
# Should show: -rw-r----- (640 permissions)
```

**Permission Breakdown (640):**
- `6` (110 binary) = `rw-` (owner: read + write)
- `4` (100 binary) = `r--` (group: read only)
- `0` (000 binary) = `---` (others: no access)

---

## Task 7: Verify Directory Permissions

**Objective:** Ensure all workspace directories have 755 permissions

```bash
# Check current directory permissions
ls -la workspace/

# Set 755 permissions on all workspace directories if needed
chmod 755 workspace/
chmod 755 workspace/documents/
chmod 755 workspace/scripts/
chmod 755 workspace/configs/

# Verify all directory permissions
ls -la workspace/
# All directories should show: drwxr-xr-x (755)
```

**Directory Permission Breakdown (755):**
- `7` (111 binary) = `rwx` (owner: read + write + execute)
- `5` (101 binary) = `r-x` (group: read + execute)
- `5` (101 binary) = `r-x` (others: read + execute)

---

## Final Verification

```bash
# Run the verification script
./check.sh

# Should show all PASS results if completed correctly
```

---

## Quick Command Reference

| Task | Command | Purpose |
|------|---------|---------|
| Move file | `mv source dest` | Relocate file |
| Move + rename | `mv source newname` | Move and rename |
| Copy file | `cp source dest` | Create duplicate |
| Make executable | `chmod +x file` | Add execute permission |
| Set specific perms | `chmod 640 file` | Set exact permissions |
| Check permissions | `ls -la` | View file permissions |
| Check structure | `tree` | View directory tree |

---

## Common Mistakes to Avoid

1. **Using `cp` instead of `mv`**: Tasks specifically ask to "move" files, not copy them
2. **Forgetting to make script executable**: Scripts need execute permissions to run
3. **Wrong permission numbers**:
   - 755 for directories and executable files
   - 640 for secure config files
   - 644 for regular files
4. **Not checking final state**: Always verify with `ls -la` and `tree`
5. **Leaving files in `incoming/`**: All files should be moved out

---

## Permission Quick Reference

| Octal | Binary | Symbolic | Meaning |
|-------|--------|----------|---------|
| 0 | 000 | `---` | No permissions |
| 4 | 100 | `r--` | Read only |
| 5 | 101 | `r-x` | Read + execute |
| 6 | 110 | `rw-` | Read + write |
| 7 | 111 | `rwx` | Read + write + execute |

**Common Permission Patterns:**
- `644` = `-rw-r--r--` (regular files)
- `755` = `-rwxr-xr-x` (executable files, directories)
- `640` = `-rw-r-----` (secure config files)

---

## Time Estimate: 10-15 minutes
## Difficulty: Beginner to Intermediate
## RHCSA Skills Covered: File operations, permission management, directory organization