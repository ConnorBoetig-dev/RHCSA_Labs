# RHCSA Lab Creation Context

This document provides Claude Code with comprehensive guidelines for creating high-quality RHCSA practice labs.

## 🎯 Lab Creation Formula

### Directory Structure Requirements
```
labs/lab##-descriptive-name/
├── setup.sh                 # Reset script (must work multiple times)
├── task.txt                 # Exam-realistic task description
├── verify.sh               # Automated verification script
├── walkthrough.md          # Complete step-by-step solution
└── cleanup.sh             # Optional cleanup script
```

### setup.sh Requirements
- **CRITICAL**: Must be idempotent (can run multiple times safely)
- Create all necessary directories, files, and initial conditions
- Set proper permissions and ownership
- Include error handling for existing files/directories
- Reset system to known initial state every time
- Test thoroughly before delivery

### task.txt Format
- Exam-realistic language and scenarios
- Clear, numbered tasks
- Specific requirements and constraints
- No Claude Code instructions (student-facing only)
- Professional, concise writing
- Include verification hints where appropriate

### verify.sh Specifications
- Check all task requirements automatically
- Provide clear success/failure messages
- Use color coding (green/red) for visual feedback
- Include detailed failure explanations
- Test edge cases and common mistakes
- Exit with appropriate codes (0=success, 1=failure)

### walkthrough.md Documentation
- Complete step-by-step command sequences
- Explain WHY each command is used
- Include expected output examples
- Cover common mistakes and troubleshooting
- Reference RHCSA exam objectives
- Use clear markdown formatting with code blocks

## 📚 Learning Philosophy

### Two-Phase Learning Approach
1. **Attempt Phase**: Student tries independently using task.txt
2. **Study Phase**: Student reviews walkthrough.md after attempting

### Progressive Difficulty Building
- Start with basic concepts
- Build complexity gradually
- Reference previous labs when building on concepts
- Introduce new tools/concepts systematically

### Real-World Scenarios
- Use realistic business scenarios (not academic examples)
- Include practical contexts (web servers, databases, etc.)
- Simulate actual system administration tasks
- Include security considerations

### Verification-Based Learning
- Every task must be automatically verifiable
- Students learn from immediate feedback
- Verification scripts teach proper testing methods

## 🔧 Technical Specifications

### Script Requirements
- All scripts executable (755 permissions)
- Proper shebang lines (`#!/bin/bash`)
- Error handling and input validation
- Consistent coding style and comments
- Work on RHEL 9 / Rocky Linux 9 / AlmaLinux 9

### Content Guidelines
- Realistic but simple file contents
- Appropriate file sizes (not too large)
- Meaningful filenames and directory names
- Proper system service integration
- Security best practices

### Error Handling Standards
- Check command success/failure
- Provide helpful error messages
- Graceful handling of missing dependencies
- Clear instructions for manual fixes if needed

### Integration with RHCSA Objectives
- Map each task to specific exam objectives
- Cover all major objective categories:
  - Essential tools and command line
  - File systems and storage
  - Users and groups
  - Networking
  - Services and processes
  - Security (SELinux, firewall, SSH)
  - System administration

## 💬 Communication Guidelines

### Explaining Concepts Effectively
- Start with the WHY before the HOW
- Use analogies for complex concepts
- Provide context for commands and options
- Explain common mistakes and how to avoid them
- Reference official documentation

### Claude Code Instructions Format
- Always include complete setup.sh with all requirements
- Provide exact file contents and permissions
- Include comprehensive verify.sh script
- Create detailed walkthrough.md
- Test all components before delivery

### Student Interaction Patterns
- Assume students will attempt before reading walkthrough
- Provide hints in task.txt without giving away solutions
- Include troubleshooting sections in walkthrough
- Encourage experimentation within safe boundaries

## 🎪 Lab Categories and Themes

### Essential Tools (Labs 1-8)
- Command line basics and navigation
- File operations and permissions
- Text processing and searching
- Archives and compression
- Input/output redirection
- Shell scripting basics

### System Operations (Labs 9-16)
- Process management
- Service management (systemd)
- Boot process and targets
- System monitoring and logging
- Performance tuning
- Network services

### Storage Management (Labs 17-22)
- Partitioning (MBR/GPT)
- LVM (Physical/Volume Groups/Logical Volumes)
- File systems (ext4, xfs, vfat)
- NFS and autofs
- Swap configuration
- Storage troubleshooting

### User and Security Management (Labs 23-28)
- User and group administration
- SSH key-based authentication
- sudo configuration
- SELinux management
- Firewall configuration
- Password policies and aging

### Advanced Integration (Labs 29-30)
- Multi-objective scenarios
- Real-world troubleshooting
- Comprehensive system setup
- Exam simulation scenarios

## 🔍 Quality Assurance Checklist

### Before Lab Delivery
- [ ] setup.sh runs multiple times without errors
- [ ] verify.sh accurately tests all requirements
- [ ] walkthrough.md commands execute successfully
- [ ] All file permissions and ownership correct
- [ ] Tasks map to specific RHCSA objectives
- [ ] Realistic scenario with business context
- [ ] Progressive difficulty appropriate for lab number
- [ ] Error messages are helpful and clear
- [ ] Documentation is complete and accurate

### Testing Protocol
- Run setup.sh twice to ensure idempotency
- Execute all walkthrough commands in sequence
- Test verify.sh with both correct and incorrect solutions
- Verify cleanup leaves system in clean state
- Test on fresh RHEL 9 / Rocky Linux 9 system

## 📋 Common Patterns and Templates

### Standard setup.sh Structure
```bash
#!/bin/bash
# Lab ## Setup Script

set -e  # Exit on error

echo "Setting up Lab ## environment..."

# Clean up any existing setup
[cleanup commands]

# Create directory structure
[mkdir commands with -p flag]

# Create files with content
[file creation commands]

# Set permissions and ownership
[chmod/chown commands]

echo "Lab ## setup complete!"
```

### Standard verify.sh Structure
```bash
#!/bin/bash
# Lab ## Verification Script

PASS=0
FAIL=0

check_task() {
    local task_num=$1
    local description=$2
    shift 2

    if "$@" &>/dev/null; then
        echo -e "\033[32m✓ Task $task_num: $description\033[0m"
        ((PASS++))
    else
        echo -e "\033[31m✗ Task $task_num: $description\033[0m"
        ((FAIL++))
    fi
}

[Individual task checks]

echo -e "\nResults: \033[32m$PASS passed\033[0m, \033[31m$FAIL failed\033[0m"
exit $FAIL
```

## 🎯 Success Metrics

A successful RHCSA lab should:
- Take 15-45 minutes for target skill level
- Cover 2-4 specific RHCSA objectives
- Include 5-10 discrete tasks
- Have 100% automated verification
- Provide complete learning through walkthrough
- Prepare students for real exam scenarios
- Build systematically on previous labs

## 📚 Reference Materials

- Red Hat Certified System Administrator (RHCSA) Exam Objectives
- RHEL 9 System Administrator's Guide
- systemd documentation
- SELinux User's and Administrator's Guide
- Previous lab structures in this project

---

**Note**: This context should be referenced for every new lab creation to ensure consistency, quality, and alignment with RHCSA exam preparation goals.