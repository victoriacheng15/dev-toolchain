#!/usr/bin/env bash
set -euo pipefail

# Guard: Ensure title is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <task-description>"
    exit 1
fi

TASK_TITLE="$1"

# Convert task title to uppercase and replace non-alphanumeric characters with underscores
TASK=$(echo "$TASK_TITLE" | tr '[:lower:]' '[:upper:]' | sed -E 's/[^A-Z0-9]+/_/g' | sed -E 's/^_+|_+$//g')
PLAN_FILE="PLAN-${TASK}.md"

# Collision Prevention
if [ -f "$PLAN_FILE" ]; then
    echo "Error: '${PLAN_FILE}' already exists in the workspace root. Collision prevented." >&2
    exit 1
fi

CURRENT_DATE=$(date +%Y-%m-%d)

cat <<EOF > "$PLAN_FILE"
# Implementation Plan: ${TASK_TITLE}

- **Status:** In Progress
- **Date:** ${CURRENT_DATE}

## Goal

${TASK_TITLE}

## Approach & Affected Files

- **Affected Components:**
  - [List of files or packages]
- **Key Constraints:**
  - [List constraints, e.g., no external dependencies, performance bounds]
- **Assumptions:**
  - [Assumptions about the current implementation]

## Stacked PRs Strategy

To facilitate incremental review and parallel development, the implementation is organized as a stack of dependent Pull Requests:

1. [ ] **PR 1 (Base): [Logical Sub-task / Component]**
   - **Branch:** \`[branch-name]\` (stacked on \`main\`)
   - **Review Focus:** [e.g., API contracts, database schemas, core interface definitions]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]
2. [ ] **PR 2 (Upstack): [Logical Sub-task / Component]**
   - **Branch:** \`[branch-name]\` (stacked on PR 1 branch)
   - **Review Focus:** [e.g., business logic implementation, downstream handlers]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]

## Detailed Execution Checklist

- [ ] **Step 1: Preparation**
  - [ ] Analyze existing code structure and imports
  - [ ] Verify test environment readiness
- [ ] **Step 2: Implementation**
  - [ ] Implement changes for PR 1
  - [ ] Implement changes for PR 2
- [ ] **Step 3: Verification**
  - [ ] Write unit tests for each PR boundary
  - [ ] Validate edge cases and rollback capability

## Verification & Rollback Commands

- **Automated Tests:** \`make test\`
- **Linting & Formatting:** \`make lint\`
- **Rollback Strategy:** [Rollback steps or commands if verification fails]

## Open Questions & Risks

- [List any blockers or questions requiring feedback before execution]
EOF

echo "Success: Created execution plan at '$PLAN_FILE'"
echo "To view your active workspace status, run: git status"
