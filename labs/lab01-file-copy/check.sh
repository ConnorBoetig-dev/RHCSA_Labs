#!/bin/bash
echo "=== LAB 01 VERIFICATION ==="
echo "Checking backup directory:"
ls -1 backup/ | sort
echo ""
echo "Expected files in backup:"
echo "app.conf manual.txt system.log user-guide.txt"
echo ""
echo "Source directory (originals should remain):"
ls -1 source/
echo ""
if [[ $(ls backup/ | wc -l) -eq 4 ]]; then
    echo "✓ PASS: Backup contains 4 files"
else
    echo "✗ FAIL: Backup should contain 4 files"
fi