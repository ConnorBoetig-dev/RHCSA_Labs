#!/bin/bash

# RHCSA Lab 02 - File Operations and Permissions Verification Script

echo "========================================"
echo "RHCSA Lab 02 - Verification Results"
echo "========================================"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Function to check and report results
check_result() {
    local test_name="$1"
    local condition="$2"

    if [ "$condition" = "true" ]; then
        echo "✓ PASS: $test_name"
        ((PASS_COUNT++))
    else
        echo "✗ FAIL: $test_name"
        ((FAIL_COUNT++))
    fi
}

# Task 1: Check all .txt files (except meeting-notes.txt) are in workspace/documents/
echo "Task 1: Move Text Files to workspace/documents/"
if [ -f "workspace/documents/project-notes.txt" ] && [ -f "workspace/documents/team-contacts.txt" ]; then
    check_result "project-notes.txt and team-contacts.txt moved to workspace/documents/" "true"
else
    check_result "project-notes.txt and team-contacts.txt moved to workspace/documents/" "false"
fi

# Task 2: Check daily-standup.txt exists in workspace/documents/
echo ""
echo "Task 2: Move and Rename Meeting Notes"
if [ -f "workspace/documents/daily-standup.txt" ]; then
    check_result "meeting-notes.txt renamed to daily-standup.txt in workspace/documents/" "true"
else
    check_result "meeting-notes.txt renamed to daily-standup.txt in workspace/documents/" "false"
fi

# Task 3: Check app-config.conf exists in archive/ (backup copy)
echo ""
echo "Task 3: Create Backup Copy"
if [ -f "archive/app-config.conf" ]; then
    check_result "app-config.conf backup copy created in archive/" "true"
else
    check_result "app-config.conf backup copy created in archive/" "false"
fi

# Task 4: Check app-config.conf moved to workspace/configs/
echo ""
echo "Task 4: Move Configuration File"
if [ -f "workspace/configs/app-config.conf" ]; then
    check_result "app-config.conf moved to workspace/configs/" "true"
else
    check_result "app-config.conf moved to workspace/configs/" "false"
fi

# Task 5: Check development-script.sh moved to workspace/scripts/ and is executable
echo ""
echo "Task 5: Move Script and Fix Permissions"
if [ -f "workspace/scripts/development-script.sh" ]; then
    if [ -x "workspace/scripts/development-script.sh" ]; then
        check_result "development-script.sh moved to workspace/scripts/ and is executable" "true"
    else
        check_result "development-script.sh moved to workspace/scripts/ and is executable" "false"
        echo "  → Script exists but is not executable (missing execute permission)"
    fi
else
    check_result "development-script.sh moved to workspace/scripts/ and is executable" "false"
fi

# Task 6: Check config files have 640 permissions
echo ""
echo "Task 6: Configuration File Permissions (640)"
if [ -f "workspace/configs/app-config.conf" ]; then
    PERM=$(stat -c "%a" workspace/configs/app-config.conf)
    if [ "$PERM" = "640" ]; then
        check_result "app-config.conf has 640 permissions (rw-r-----)" "true"
    else
        check_result "app-config.conf has 640 permissions (rw-r-----)" "false"
        echo "  → Current permissions: $PERM (expected: 640)"
    fi
else
    check_result "app-config.conf has 640 permissions (rw-r-----)" "false"
fi

# Task 7: Check directories have 755 permissions
echo ""
echo "Task 7: Directory Permissions (755)"
DIRS=("workspace" "workspace/documents" "workspace/scripts" "workspace/configs")
for dir in "${DIRS[@]}"; do
    if [ -d "$dir" ]; then
        PERM=$(stat -c "%a" "$dir")
        if [ "$PERM" = "755" ]; then
            check_result "$dir has 755 permissions (rwxr-xr-x)" "true"
        else
            check_result "$dir has 755 permissions (rwxr-xr-x)" "false"
            echo "  → Current permissions: $PERM (expected: 755)"
        fi
    else
        check_result "$dir has 755 permissions (rwxr-xr-x)" "false"
    fi
done

# Bonus check: Verify incoming/ directory is empty
echo ""
echo "Bonus Check: Complete File Organization"
if [ -z "$(ls -A incoming/ 2>/dev/null)" ]; then
    check_result "incoming/ directory is empty (all files properly moved)" "true"
else
    check_result "incoming/ directory is empty (all files properly moved)" "false"
    echo "  → Files remaining in incoming/: $(ls incoming/ 2>/dev/null)"
fi

# Final Results
echo ""
echo "========================================"
echo "VERIFICATION SUMMARY"
echo "========================================"
echo "PASSED: $PASS_COUNT tests"
echo "FAILED: $FAIL_COUNT tests"
echo ""

if [ $FAIL_COUNT -eq 0 ]; then
    echo "🎉 EXCELLENT! All tasks completed successfully!"
    echo "You have successfully completed RHCSA Lab 02."
    echo "Your file organization and permission management skills are solid."
else
    echo "❌ Some tasks need attention. Review the failed checks above."
    echo "Tip: Use 'ls -la' to check file locations and permissions."
    echo "Tip: Use 'tree' to see the overall directory structure."
fi

echo ""
echo "Run './setup.sh' to reset the lab and try again."
echo "========================================"