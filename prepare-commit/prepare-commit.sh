#!/usr/bin/env bash
# prepare-commit.sh - Automated Git Commit and Metadata Prepper
# Ensures compliance with the project's commit and staging rules.

set -euo pipefail

# Force all Git commands to output raw text directly (prevents dropping into interactive pagers like 'less')
export GIT_PAGER=cat

# ANSI color codes for premium visual output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${BOLD}${BLUE}========================================================================${NC}"
echo -e "${BOLD}${CYAN}                   PREPARE-COMMIT ENGINE                                ${NC}"
echo -e "${BOLD}${BLUE}========================================================================${NC}"

# Ensure execution context is within a valid git repository
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo -e "${RED}${BOLD}Error:${NC} Execution context is not within a valid Git repository." >&2
    exit 1
fi

# 1. State Auditing Commands
echo -e "\n${BOLD}${CYAN}[1/3] Executing Git State Audits...${NC}"

echo -e "\n${BOLD}${YELLOW}>> git status${NC}"
git status

echo -e "\n${BOLD}${YELLOW}>> git diff HEAD${NC}"
# Limit diff output to stat first for safety, then show partial details
git diff HEAD --stat

echo -e "\n${BOLD}${YELLOW}>> git log -n 3${NC}"
git log -n 3 --oneline --color=always

# Detect changes
staged_files=$(git diff --cached --name-only)
unstaged_files=$(git diff --name-only)
untracked_files=$(git status --porcelain | grep '^[?][?]' | cut -c4- || true)

if [[ -z "$staged_files" && -z "$unstaged_files" && -z "$untracked_files" ]]; then
    echo -e "\n${YELLOW}${BOLD}No changes detected in working tree. Exiting...${NC}"
    exit 0
fi

# 2. Stage Analysis and Heuristics
echo -e "\n${BOLD}${CYAN}[2/3] Analyzing Staging and Metadata...${NC}"

# Resolve primary changed folder/file for staging commands and scope
primary_path=""
if [[ -n "$staged_files" ]]; then
    primary_path=$(echo "$staged_files" | head -n 1)
elif [[ -n "$unstaged_files" ]]; then
    primary_path=$(echo "$unstaged_files" | head -n 1)
else
    primary_path=$(echo "$untracked_files" | head -n 1)
fi

dir_name=$(dirname "$primary_path")
base_name=$(basename "$primary_path" | cut -f1 -d'.')
scope="core"
if [[ "$dir_name" != "." ]]; then
    scope=$(basename "$dir_name")
else
    scope="$base_name"
fi
scope=$(echo "$scope" | tr '[:upper:]' '[:lower:]' | tr -cd 'a-z0-9-')

# Determine type based on file pattern
change_type="feat"
if [[ "$primary_path" =~ (test|spec) ]]; then
    change_type="test"
elif [[ "$primary_path" =~ (docs|markdown|README|SKILL) ]]; then
    change_type="docs"
elif [[ "$primary_path" =~ (\.github|yml|yaml|Makefile|Dockerfile|config) ]]; then
    change_type="chore"
fi

# Build clean staging commands (directory level preferred if clean)
staging_command=""
if [[ "$dir_name" != "." && -d "$dir_name" ]]; then
    staging_command="git add ${dir_name}"
else
    staging_command="git add ${primary_path}"
fi

# Recommended Branch name
branch_name="${change_type}/prep-${scope}"
# Recommended Commit Message (Ensure under 72 characters)
commit_msg="${change_type}(${scope}): initialize work and refine metadata definitions"
if [ ${#commit_msg} -gt 72 ]; then
    commit_msg="${commit_msg:0:68}..."
fi

# 3. Draft commit.md File
echo -e "\n${BOLD}${CYAN}[3/3] Drafting commit.md...${NC}"

cat << EOF > commit.md
# Git Commit Info

## PR Description

### Summary
[Replace this line with 2 to 3 sentences explaining the problem being solved and the value of the change.]

### List of Changes
- [Describe the main improvement or purpose - focus on why it matters]
- [Describe system, workflow, safety, or review benefit]

### Verification
- [ ] [At least one automated test or check that was completed]
- [ ] [At least one manual validation step that still needs to be completed]

## Execution Commands
\`\`\`bash
git checkout -b ${branch_name}
${staging_command}
git commit -m "${commit_msg}"
\`\`\`
EOF

echo -e "${GREEN}${BOLD}Success:${NC} Created ${BOLD}commit.md${NC} draft in the workspace root."
echo -e "You can now edit ${BOLD}commit.md${NC} to fill in the summary and list of changes."
echo -e "${BOLD}${BLUE}========================================================================${NC}"
