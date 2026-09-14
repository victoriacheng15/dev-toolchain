---
name: plan-gen
description: Scaffolds a local PLAN-[TASK].md template to sequence PRs and coordinate execution steps to prevent goal drift.
version: 1.0.0
license: MIT
inputs:
  task_description:
    type: string
    description: Detailed description of the task or request.
    required: true
outputs:
  - "PLAN-[TASK].md"
on_failure:
  policy: retry
  max_retries: 3
---

# Agent Execution Planning

## Overview

Complex software engineering tasks require systematic planning to prevent code duplication, architectural regressions, and AI agent execution drift. This skill standardizes the creation and revision of a local, non-committed `PLAN-[TASK].md` file in the workspace root to serve as an execution anchor. It focuses on partitioning changes into logical, sequential Pull Requests (PRs) to simplify code review and ensure incremental stability.

---

## Execution Workflow

When planning a task or incorporating user feedback, follow these procedural steps:

1. **Locate or Name Plan File:**
   - Scan the workspace root for an existing `PLAN-*.md` or `plan.md` file.
   - If a plan file already exists, proceed to the **Revision Workflow**.
   - If no plan file exists, derive a task slug from the task description (uppercase alphanumeric separated by underscores, e.g., `PLAN-[TASK].md`) or use `plan.md`.

2. **Initialization Workflow (New Plan):**
   - Scaffold the new plan file in the workspace root using the mandatory schema below.
   - Populate the header with the task title, current date (`YYYY-MM-DD`), and set status to `In Progress`.
   - Populate the **Goal** with the detailed task requirements.
   - Partition the implementation into sequential or stacked PR boundaries under **PR Strategy**.
   - Define concrete steps under **Detailed Execution Checklist**.
   - Detail verification commands (tests, linting) and rollback procedures.

3. **Revision Workflow (Existing Plan):**
   - Read the existing plan file into context.
   - Ensure a `## Revisions & Updates` section exists at the bottom.
   - Append the new user request as a checklist item with today's date:
     `- [ ] **User Request (YYYY-MM-DD):** [Detailed instructions]`
   - Update the **Goal**, **Approach & Affected Files**, **PR Strategy**, and **Detailed Execution Checklist** to integrate the new requirements while preserving completed progress.

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

## PR Strategy

To facilitate incremental review and parallel development, the implementation is organized into sequential or stacked Pull Requests:

1. [ ] **PR 1: [Logical Sub-task / Component]**
   - **Branch:** `[branch-name]` (branched from `main`)
   - **Review Focus:** [e.g., API contracts, schemas, core interface definitions]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]
2. [ ] **PR 2: [Logical Sub-task / Component]**
   - **Branch:** `[branch-name]` (branched from `main` for sequential, or stacked on PR 1 branch for stacked)
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

## Revisions & Updates

- [ ] **User Request ([YYYY-MM-DD]):** [Appended user instructions to be integrated into the main checklist]
```

---

## Verification Checklist

Prior to beginning work on the plan, verify that:

1. [ ] **PR Strategy Defined:** The task is partitioned into atomic PR boundaries using either sequential or stacked delivery.
2. [ ] **Execution Checklist Defined:** The sub-tasks correspond to the defined PR sequence.
3. [ ] **Verification Commands Included:** Specific shell commands for testing are written down.
4. [ ] **Agent Anchored:** The agent refers back to this plan at the beginning and end of each turn.
