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
   - Populate the **Goal** with the primary objective, including **Specifications** and **Acceptance Criteria** subsections.
   - Partition the implementation into sequential or stacked PR boundaries under **PR Strategy**, scheduling initial PRs for interface contracts, no-op methods (stubs), and their baseline unit tests prior to functional implementation when applicable.
   - Define concrete steps under **Detailed Execution Checklist**, sequencing no-op method scaffolding and unit tests before concrete business logic where applicable.
   - **Note on Applicability:** No-op scaffolding is suited for tasks introducing new interfaces, public APIs, or multi-component contracts. For localized bug fixes, configuration tweaks, or minor refactors with existing contracts, the no-op phase may be omitted.
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

### Specifications

- [Technical requirements, behavioral constraints, and interface boundaries]

### Acceptance Criteria

- [ ] [Measurable condition validating completion]
- [ ] [Measurable condition validating edge cases or performance criteria]

## Approach & Affected Files

- **Affected Components:** [List of files or packages]
- **Key Constraints:** [e.g., performance targets, backwards compatibility, no external dependencies]
- **Assumptions:** [Assumptions about the current implementation]

## PR Strategy

To facilitate incremental review and parallel development, the implementation is organized into sequential or stacked Pull Requests:

1. [ ] **PR 1: [Interface Contracts & No-Op Stubs]**
   - **Branch:** `[branch-name]` (branched from `main`)
   - **Review Focus:** [e.g., API contracts, schemas, no-op method stubs, initial unit test suites]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]
2. [ ] **PR 2: [Functional Implementation]**
   - **Branch:** `[branch-name]` (branched from `main` for sequential, or stacked on PR 1 branch for stacked)
   - **Review Focus:** [e.g., business logic replacing no-op methods, downstream handlers]
   - **Affected Files:** [List paths]
   - **Verification:** [Command to run]

## Detailed Execution Checklist

- [ ] **Step 1: Preparation & Contract Scaffolding**
  - [ ] Analysis of existing implementation and schema design
  - [ ] Scaffold interfaces and no-op methods (stubs)
  - [ ] Implement initial unit tests asserting expected stub behaviors
- [ ] **Step 2: Functional Implementation**
  - [ ] Implement concrete logic for PR 1 / PR 2 replacing no-op methods
  - [ ] Expand unit test suites for business logic and edge cases
- [ ] **Step 3: Verification & Hardening**
  - [ ] Validate full test suite coverage across all PR boundaries
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
2. [ ] **No-Op Scaffolding Evaluated:** Interface contracts, no-op methods (stubs), and baseline unit tests are sequenced prior to functional logic where applicable (or intentionally bypassed if no new interfaces/contracts are created).
3. [ ] **Execution Checklist Defined:** The sub-tasks correspond to the defined PR sequence.
4. [ ] **Verification Commands Included:** Specific shell commands for testing are written down.
5. [ ] **Agent Anchored:** The agent refers back to this plan at the beginning and end of each turn.
