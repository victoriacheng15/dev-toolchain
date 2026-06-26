#!/usr/bin/env bash
set -euo pipefail

# Guard: Ensure task description is provided
if [ $# -lt 1 ]; then
    echo "Usage: $0 <task-description>"
    exit 1
fi

TASK_DESC="$1"
CURRENT_DATE=$(date +%Y-%m-%d)

# Find the most recently modified PLAN-*.md file in the current directory
PLAN_FILE=$(find . -maxdepth 1 -name "PLAN-*.md" -printf '%T@ %p\n' | sort -n | tail -n 1 | cut -d' ' -f2- || true)

if [ -n "$PLAN_FILE" ]; then
    PLAN_FILE=${PLAN_FILE#./}
fi

# Revision Handling: Append if a plan already exists
if [ -n "$PLAN_FILE" ] && [ -f "$PLAN_FILE" ]; then
    # Ensure Revisions section exists
    if ! grep -q "^## Revisions & Updates" "$PLAN_FILE"; then
        echo -e "\n## Revisions & Updates\n" >> "$PLAN_FILE"
    fi
    echo "- [ ] **User Request (${CURRENT_DATE}):** ${TASK_DESC}" >> "$PLAN_FILE"
    echo "Success: Appended revision request to existing plan at '$PLAN_FILE'"
    exit 0
fi

# Scaffolding: Create new plan file
# Extract first 5 words of description to generate a clean task slug for the filename
FIRST_WORDS=$(echo "$TASK_DESC" | cut -d' ' -f1-5)
TASK=$(echo "$FIRST_WORDS" | tr '[:lower:]' '[:upper:]' | sed -E 's/[^A-Z0-9]+/_/g' | sed -E 's/^_+|_+$//g')
NEW_PLAN_FILE="PLAN-${TASK}.md"

cat <<EOF > "$NEW_PLAN_FILE"
# Implementation Plan: ${FIRST_WORDS}

- **Status:** In Progress
- **Date:** ${CURRENT_DATE}

## Goal

${TASK_DESC}

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

## Revisions & Updates

EOF

echo "Success: Created execution plan skeleton at '$NEW_PLAN_FILE'"
echo "To view your active workspace status, run: git status"
