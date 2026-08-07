#!/usr/bin/env bash
set -euo pipefail

# Guard: Ensure issue number and title are provided
if [ $# -lt 2 ]; then
    echo "Usage: $0 <issue-number> <issue-title>"
    exit 1
fi

ISSUE_NUM="$1"
ISSUE_TITLE="$2"

# Sanitize issue number to integer-like string
NUM=$(echo "$ISSUE_NUM" | tr -cd '0-9')
if [ -z "$NUM" ]; then
    echo "Error: Issue number must contain digits." >&2
    exit 1
fi

PLAN_FILE="issue-${NUM}.md"
CURRENT_DATE=$(date +%Y-%m-%d)

# Collision Prevention
if [ -f "$PLAN_FILE" ]; then
    echo "Error: '${PLAN_FILE}' already exists in the workspace root. Collision prevented." >&2
    exit 1
fi

cat <<EOF > "$PLAN_FILE"
# Issue ${NUM}: ${ISSUE_TITLE}

- **Status:** In Progress
- **Date:** ${CURRENT_DATE}
- **Issue Link:** [Link to upstream issue]
- **PR Link:** [Link to upstream PR once drafted]
- **Target Branch:** [e.g., fix/issue-${NUM} or feature/descriptive-name]
- **Subsystem:** [e.g., mesheryctl | controllers/chaosdaemon]

## Bug Repro

- **Failure Analysis:** [Describe the exact failure observed]
- **Reproduction Steps:**
  - [ ] Run command to reproduce: \`[Command]\`
- **Failure Output:**
\`\`\`text
[Paste raw compilation error, stack trace, or failure logs here]
\`\`\`

## Fix

- **Goal:** [Summary of the planned bug fix]
- **Approach:** [Explanation of code modifications and files modified]
- **Detailed Execution Checklist:**
  - [ ] **Task 1:** [Step-by-step implementation changes]
  - [ ] **Task 2:** [Verify build passes locally]

## Verify

- **Test Command:** \`[e.g., make test or go test ./...]\`
- **Test Output Summary:**
\`\`\`text
[Paste clean test run outputs or summary statistics here]
\`\`\`
- **Upstream Compliance:**
  - [ ] **DCO Sign-off:** (If required) Confirm commit includes -s flag
  - [ ] **Lint & Format:** [Confirm styling complies with repository rules]
  - [ ] **Tests:** (If applicable) Add new tests and verify all test suites pass successfully
- **Cleanup:**
  - [ ] **Reproduction Assets:** [Remove temporary reproduction scripts, manifests, or docker-compose configs]
  - [ ] **Debug Logs/Prints:** [Ensure temporary debug statements or prints are removed from code]
EOF

echo "Success: Created triage template at '$PLAN_FILE'"
echo "To view your active workspace status, run: git status"
