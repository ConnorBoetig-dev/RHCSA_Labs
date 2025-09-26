#!/bin/bash
# Lab 01 Reset Script

echo "Setting up Lab 01: File Copy Operations..."

# Remove old files and create fresh directories
rm -rf work backup source temp 2>/dev/null
mkdir -p work backup source temp

# Create simple source files
echo "config data v1.0" > source/app.conf
echo "user manual text" > source/manual.txt
echo "log entries here" > source/system.log
echo "temp work file" > work/draft.txt

echo "Lab setup complete!"
echo "Ready to practice file copy operations"
