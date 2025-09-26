#!/bin/bash

echo "========================================"
echo "RHCSA Lab 03 - Verification Script"
echo "========================================"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

# Color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

# Function to check task completion
check_task() {
    local task_name="$1"
    local condition="$2"

    echo -n "Checking: $task_name... "

    if eval "$condition"; then
        echo -e "${GREEN}PASS${NC}"
        ((PASS_COUNT++))
        return 0
    else
        echo -e "${RED}FAIL${NC}"
        ((FAIL_COUNT++))
        return 1
    fi
}

# Function to provide detailed feedback
provide_feedback() {
    local task_num="$1"
    local feedback="$2"
    echo "  → Task $task_num: $feedback"
}

echo "Task 1: Checking if logs copied to workspace/analysis/"
if check_task "Log files in workspace/analysis/" "[[ -f workspace/analysis/system.log && -f workspace/analysis/security.log && -f workspace/analysis/access.log && -f workspace/analysis/application.log ]]"; then
    provide_feedback "1" "All log files successfully copied"
else
    provide_feedback "1" "Missing log files in workspace/analysis/"
    echo "       Expected: system.log, security.log, access.log, application.log"
fi
echo ""

echo "Task 2: Checking failed login count"
if check_task "Failed count file exists" "[[ -f results/failed-count.txt ]]"; then
    EXPECTED_COUNT=$(grep -c "FAILED" logs/security.log 2>/dev/null)
    ACTUAL_COUNT=$(cat results/failed-count.txt 2>/dev/null | tr -d '[:space:]')

    if [[ "$ACTUAL_COUNT" == "$EXPECTED_COUNT" ]]; then
        provide_feedback "2" "Correct count of failed logins: $ACTUAL_COUNT"
    else
        provide_feedback "2" "Incorrect count. Expected: $EXPECTED_COUNT, Found: $ACTUAL_COUNT"
        echo "       Hint: Use 'grep -c FAILED security.log'"
    fi
else
    provide_feedback "2" "File results/failed-count.txt not found"
fi
echo ""

echo "Task 3: Checking unique IP addresses"
if check_task "IP addresses file exists" "[[ -f results/ip-addresses.txt ]]"; then
    # Check if file contains IP addresses
    IP_COUNT=$(grep -E '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' results/ip-addresses.txt 2>/dev/null | wc -l)
    EXPECTED_IPS=$(awk '{print $1}' logs/access.log 2>/dev/null | sort -u | wc -l)

    if [[ $IP_COUNT -gt 0 ]]; then
        provide_feedback "3" "Found $IP_COUNT unique IP addresses"
        if [[ $IP_COUNT -ne $EXPECTED_IPS ]]; then
            echo "       Note: Expected $EXPECTED_IPS unique IPs from access.log"
        fi
    else
        provide_feedback "3" "No valid IP addresses found in file"
        echo "       Hint: Extract first field from access.log and use sort -u"
    fi
else
    provide_feedback "3" "File results/ip-addresses.txt not found"
fi
echo ""

echo "Task 4: Checking consolidated ERROR entries"
if check_task "All errors file exists" "[[ -f results/all-errors.txt ]]"; then
    ERROR_COUNT=$(grep -c "ERROR" results/all-errors.txt 2>/dev/null)
    EXPECTED_ERRORS=$(grep "ERROR" logs/*.log 2>/dev/null | wc -l)

    if [[ $ERROR_COUNT -gt 0 ]]; then
        provide_feedback "4" "Found $ERROR_COUNT ERROR entries"
        if [[ $ERROR_COUNT -lt $EXPECTED_ERRORS ]]; then
            echo "       Note: Some errors might be missing. Check all log files"
        fi
    else
        provide_feedback "4" "No ERROR entries found in file"
        echo "       Hint: Use 'grep ERROR logs/*.log >> all-errors.txt'"
    fi
else
    provide_feedback "4" "File results/all-errors.txt not found"
fi
echo ""

echo "Task 5: Checking error summary report"
if check_task "Error summary file exists" "[[ -f results/error-summary.txt ]]"; then
    LINE_COUNT=$(wc -l < results/error-summary.txt 2>/dev/null)

    if [[ $LINE_COUNT -le 5 && $LINE_COUNT -gt 0 ]]; then
        provide_feedback "5" "Error summary contains top entries"
        # Check if file appears to have counts
        if grep -q '^[[:space:]]*[0-9]' results/error-summary.txt 2>/dev/null; then
            echo "       Format appears correct with counts"
        else
            echo "       Warning: File should show count and error type"
        fi
    else
        provide_feedback "5" "Summary should contain top 5 (or fewer) error types"
        echo "       Hint: Use pipeline: grep | sort | uniq -c | sort -rn | head -5"
    fi
else
    provide_feedback "5" "File results/error-summary.txt not found"
fi
echo ""

echo "Task 6: Checking processing errors file"
if check_task "Processing errors file exists" "[[ -f results/processing-errors.txt ]]"; then
    provide_feedback "6" "Processing errors file created"
    if [[ -s results/processing-errors.txt ]]; then
        echo "       File contains error output (good for testing)"
    else
        echo "       File is empty (OK if no errors occurred)"
    fi
else
    provide_feedback "6" "File results/processing-errors.txt not found"
    echo "       Hint: Use 2> or 2>> to redirect stderr"
fi
echo ""

echo "Task 7 & 8: Checking report files moved to results/"
if check_task "Reports moved to results/" "[[ ! -d workspace/reports || -z \"$(ls -A workspace/reports 2>/dev/null)\" ]]"; then
    provide_feedback "7-8" "workspace/reports/ is empty (files moved)"

    # Check permissions on files in results/
    FILES_640=$(find results/ -type f -perm 640 2>/dev/null | wc -l)
    TOTAL_FILES=$(find results/ -type f 2>/dev/null | wc -l)

    if [[ $FILES_640 -eq $TOTAL_FILES && $TOTAL_FILES -gt 0 ]]; then
        echo "       Permissions were set correctly before moving"
    else
        echo "       Note: Some files may not have had 640 permissions set"
    fi
else
    provide_feedback "7-8" "Files still in workspace/reports/ or directory missing"
    echo "       All reports should be moved to results/"
fi
echo ""

echo "Task 9: Checking archived logs"
if check_task "Logs archived" "[[ -f archive/system.log && -f archive/security.log && -f archive/access.log && -f archive/application.log ]]"; then
    # Check permissions on archived files
    FILES_644=$(find archive/ -type f -perm 644 2>/dev/null | wc -l)

    if [[ $FILES_644 -eq 4 ]]; then
        provide_feedback "9" "All logs archived with correct 644 permissions"
    else
        provide_feedback "9" "Logs archived but permissions incorrect"
        echo "       Set 644 permissions on archived files"
    fi
else
    provide_feedback "9" "Not all logs archived to archive/"
fi

echo ""
echo "========================================"
echo "FINAL SCORE: $PASS_COUNT/$((PASS_COUNT + FAIL_COUNT)) tasks completed"
echo "========================================"

if [[ $FAIL_COUNT -eq 0 ]]; then
    echo -e "${GREEN}Excellent work! All tasks completed successfully!${NC}"
    echo "You have demonstrated proficiency with:"
    echo "- Input/output redirection (>, >>, 2>)"
    echo "- Text processing with grep"
    echo "- Pipeline commands"
    echo "- File permissions and organization"
    exit 0
else
    echo -e "${RED}Some tasks need attention. Review the feedback above.${NC}"
    echo "Run './setup.sh' to reset and try again."
    exit 1
fi