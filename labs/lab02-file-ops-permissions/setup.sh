#!/bin/bash

# RHCSA Lab 02 - File Operations and Permissions Setup Script
# This script completely resets the lab environment to initial state

echo "Setting up RHCSA Lab 02 - File Operations and Permissions..."
echo "RESETTING: Removing any existing lab directories and files..."

# Remove all lab directories if they exist
rm -rf incoming/ workspace/ archive/ temp/ 2>/dev/null

echo "Creating fresh directory structure..."

# Create all required directories
mkdir -p incoming/
mkdir -p workspace/documents/
mkdir -p workspace/scripts/
mkdir -p workspace/configs/
mkdir -p archive/
mkdir -p temp/

echo "Creating initial files with content..."

# Create text files in incoming/
cat > incoming/project-notes.txt << 'EOF'
PROJECT NOTES - RHCSA Practice Lab
==================================
This file contains important project documentation.
Tasks to complete: file organization and permission management.
EOF

cat > incoming/team-contacts.txt << 'EOF'
TEAM CONTACT LIST
================
Admin Team: admin@company.com
Dev Team: dev@company.com
Operations: ops@company.com
EOF

cat > incoming/meeting-notes.txt << 'EOF'
DAILY STANDUP MEETING NOTES
===========================
Date: Today
Attendees: Development Team
Action Items:
- Complete file organization tasks
- Set proper file permissions
- Verify all configurations
EOF

# Create executable script in incoming/
cat > incoming/development-script.sh << 'EOF'
#!/bin/bash
# Development automation script
# Purpose: Automate common development tasks

echo "Running development automation..."
echo "Checking system status..."
whoami
date
echo "Development script execution complete."
EOF

# Create configuration file in incoming/
cat > incoming/app-config.conf << 'EOF'
# Application Configuration File
# Environment: Development
app_name=rhcsa_lab_app
port=8080
database_host=localhost
database_port=5432
log_level=debug
max_connections=100
EOF

echo "Setting initial problematic permissions..."

# Set incorrect permissions that need to be fixed
chmod 644 incoming/development-script.sh  # Script without execute permission
chmod 666 incoming/app-config.conf        # Config file world-writable

echo "Setting standard permissions on other files..."
chmod 644 incoming/*.txt

echo ""
echo "====================================================="
echo "Lab 02 setup complete! All previous changes have been reset."
echo "====================================================="
echo ""
echo "INITIAL STATE:"
echo "incoming/     - Contains files that need organization"
echo "workspace/    - Empty directories awaiting file organization"
echo "archive/      - Empty, for backup copies"
echo "temp/         - Empty temporary directory"
echo ""
echo "Use 'tree' to explore the structure, then read task.txt for instructions."
echo "Run './check.sh' anytime to verify your progress."
echo ""