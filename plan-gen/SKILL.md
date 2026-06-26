---
name: plan-gen
description: Scaffolds a local plan.md template to sequence PRs and coordinate execution steps to prevent goal drift.
---

# Agent Execution Planning

## Overview

Complex software engineering tasks require systematic planning to prevent code duplication, architectural regressions, and AI agent execution drift. This skill automates the creation of a local, non-committed `PLAN-[TASK].md` file in the workspace root to serve as an execution anchor. It focuses on partitioning changes into logical, sequential Pull Requests (PRs) to simplify code review and ensure incremental stability.

---

## Automated Execution

To scaffold a new implementation plan, execute the script from the root of the workspace:

```bash
./plan-gen/plan-gen.sh "Description of the target task"
```

If the target file already exists, the script will fail with a non-zero exit status to prevent silent overwriting.

---

## Mandatory Plan Template Structure

The generated `PLAN-[TASK].md` file must adhere to the following schema:

```markdown
# Implementation Plan: [Task Title]

- **Status:** [In Progress | Completed | Aborted]
- **Date:** [YYYY-MM-DD]

## Goal

[Clear description of the primary objective.]

## Approach & Affected Files

- **Affected Components:** [List of files or packages]
- **Key Constraints:** [e.g., performance targets, backwards compatibility, no external dependencies]
- **Assumptions:** [Assumptions about the current implementation]

## Stacked PRs Strategy

To facilitate incremental review and parallel development, the implementation is organized as a stack of dependent Pull Requests:

1. [ ] **PR 1 (Base): [Logical Sub-task / Component]**
   - **Branch:** `[branch-name]` (stacked on `main`)
   - **Review Focus:** [e.g., API contracts, database schemas, core interface definitions]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]
2. [ ] **PR 2 (Upstack): [Logical Sub-task / Component]**
   - **Branch:** `[branch-name]` (stacked on PR 1 branch)
   - **Review Focus:** [e.g., business logic implementation, downstream handlers]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]

## Detailed Execution Checklist

- [ ] **Step 1: Preparation**
  - [ ] Analysis of existing implementation
  - [ ] Sandbox/mock setup
- [ ] **Step 2: Implementation**
  - [ ] Implement changes for PR 1
  - [ ] Implement changes for PR 2
- [ ] **Step 3: Verification**
  - [ ] Write unit tests for each PR boundary
  - [ ] Validate edge cases and rollback capability

## Verification & Rollback Commands

- **Automated Tests:** `[Test command, e.g., make test]`
- **Linting & Formatting:** `[Lint command, e.g., golangci-lint run]`
- **Rollback Strategy:** [Rollback steps or commands if verification fails]

## Open Questions & Risks

- [List any blockers or questions requiring feedback before execution]
```

---

## Verification Checklist

Prior to beginning work on the plan, verify that:

1. [ ] **PR Stack Defined:** The task is broken down into atomic, stacked PR boundaries and branch dependencies.
2. [ ] **Execution Checklist Defined:** The sub-tasks correspond to the defined PR sequence.
3. [ ] **Verification Commands Included:** Specific shell commands for testing are written down.
4. [ ] **Agent Anchored:** The agent refers back to this plan at the beginning and end of each turn.
