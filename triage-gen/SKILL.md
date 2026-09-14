---
name: triage-gen
description: Guides the agent to resolve an upstream issue using a local issue-[num].md file tracking reproduction, fix, and verification states.
version: 1.0.0
license: MIT
inputs:
  issue_number:
    type: integer
    description: The target GitHub issue number.
    required: true
  issue_title:
    type: string
    description: The raw title of the issue.
    required: true
outputs:
  - "issue-[issue_number].md"
on_failure:
  policy: retry
  max_retries: 3
---

# Open Source Contributor Triage

## Overview

Contributing to open-source repositories requires systematic triage, local bug reproduction, code implementation, and compliance with upstream project standards. This skill standardizes tracking this process in a single, local, non-committed `issue-[num].md` file in the workspace root.

---

## Execution Workflow

When triaging a new issue, follow these procedural steps:

1. **Identify Issue Context:**
   - Extract the target GitHub issue number (e.g., `452`) and title.
   - Clean the issue number to numeric digits to form `[num]`.

2. **Collision Check:**
   - Verify if `issue-[num].md` already exists in the workspace root.
   - If it exists, abort creation to prevent overwriting ongoing triage state.

3. **Scaffold Issue File:**
   - Create `issue-[num].md` in the workspace root using the mandatory template below.
   - Populate the header with the issue number, title, current date (`YYYY-MM-DD`), and set status to `In Progress`.

4. **Progressive State Updates:**
   - Progressively update metadata headers (Issue Link, PR Link, Target Branch, Subsystem) as work proceeds.
   - Document reproduction steps and raw failure output in `## Bug Repro`.
   - Outline the goal, architectural approach, and step-by-step tasks in `## Fix`.
   - Record verification commands, test output summaries, upstream compliance checks, and cleanup tasks in `## Verify`.

---

## Mandatory Issue Template Structure

All issue triage files must adhere to the following schema:

````markdown
# Issue [num]: [Issue Title]

- **Status:** In Progress
- **Date:** [YYYY-MM-DD]
- **Issue Link:** [Link to upstream issue]
- **PR Link:** [Link to upstream PR once drafted]
- **Target Branch:** [e.g., fix/issue-[num] or feature/descriptive-name]
- **Subsystem:** [e.g., api | cli | core]

## Bug Repro

- **Failure Analysis:** [Describe the exact failure observed]
- **Reproduction Steps:**
  - [ ] Run command to reproduce: `[Command]`
- **Failure Output:**

```text
[Paste raw compilation error, stack trace, or failure logs here]
```

## Fix

- **Goal:** [Summary of the planned bug fix]
- **Approach:** [Explanation of code modifications and files modified]
- **Detailed Execution Checklist:**
  - [ ] **Task 1:** [Step-by-step implementation changes]
  - [ ] **Task 2:** [Verify build passes locally]

## Verify

- **Test Command:** `[e.g., make test or go test ./...]`
- **Test Output Summary:**

```text
[Paste clean test run outputs or summary statistics here]
```

- **Upstream Compliance:**
  - [ ] **DCO Sign-off:** (If required) Confirm commit includes -s flag
  - [ ] **Lint & Format:** [Confirm styling complies with repository rules]
  - [ ] **Tests:** (If applicable) Add new tests and verify all test suites pass successfully
- **Cleanup:**
  - [ ] **Reproduction Assets:** [Remove temporary reproduction scripts, manifests, or docker-compose configs]
  - [ ] **Debug Logs/Prints:** [Ensure temporary debug statements or prints are removed from code]
````

---

## Verification Checklist

Prior to completing the triage workflow, verify that:

1. [ ] **Issue File Created:** The file `issue-[num].md` exists in the workspace root.
2. [ ] **Reproduction Documented:** The `Bug Repro` section contains the reproduction command and failure logs.
3. [ ] **Upstream Compliance Checked:** Commit sign-offs and linting checks are logged in `Verify`.
4. [ ] **Workspace Cleaned:** All temporary reproduction stubs, scripts, and logs outside of source modifications are removed.
