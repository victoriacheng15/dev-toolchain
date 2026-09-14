---
name: pr-review
description: Performs a detailed review of PR changes against a base branch, checks and runs tests, and runs local dev to verify stability.
version: 1.0.0
license: MIT
inputs:
  pr_number:
    type: integer
    description: The target PR number.
    required: true
  base_branch:
    type: string
    description: The base branch to compare current changes against (e.g., main, master).
    required: false
    default: "main"
  run_dev:
    type: boolean
    description: Whether to attempt running the local development build or compile check.
    required: false
    default: true
outputs:
  - "pr-[pr_number].md"
on_failure:
  policy: retry
  max_retries: 2
---

# Pull Request Review & Verification

## Overview

High-quality code reviews require verifying not just static code diffs, but also the dynamic correctness of the changes. This skill standardizes comparing changes against a base branch, executing workspace test suites, compiling or building locally, and generating a comprehensive review report in `pr-[pr_number].md`.

---

## Execution Workflow

When reviewing a pull request, follow these procedural steps:

1. **Resolve Branches and Diff Range:**
   - Determine `base_branch` (defaults to `main` if not specified).
   - Identify the merge-base: `git merge-base [base_branch] HEAD`.
   - List modified files: `git diff --name-only [merge-base] HEAD`.

2. **Execute Tests and Build Verification:**
   - Detect project test framework (e.g., `make test`, `npm test`, `go test ./...`, `pytest`, `cargo test`) and run tests.
   - Detect project build command (e.g., `make build`, `npm run build`, `go build ./...`, `cargo build`) and verify compilation.
   - Capture exit status and summarized output for both checks.

3. **Scaffold or Refresh Review Report:**
   - Create or overwrite `pr-[pr_number].md` in the workspace root using the mandatory schema below.
   - Re-running the skill updates the file with fresh test, build, and diff telemetry.
   - Populate metadata headers, scope of changes, and verification test/build outputs.

4. **Perform Deep-Dive Code Review:**
   - Inspect the complete diff: `git diff [merge-base] HEAD`.
   - Populate `## 4. Detailed Code Review` analyzing:
     1. **Logic & Correctness:** Potential edge cases, off-by-one errors, resource leaks, or race conditions.
     2. **Safety & Security:** Injection risks, unvalidated inputs, or insecure configuration.
     3. **Performance:** Algorithmic complexity, unnecessary allocations, or blocking operations.
     4. **Style & Maintainability:** Idiomatic language patterns, clean architectural boundaries, and naming.
   - Render a clear recommendation under `## 5. Summary & Recommendation`: `Approved` or `Request Changes`.

---

## Mandatory Report Structure

The generated `pr-[pr_number].md` file must strictly adhere to the following schema:

````markdown
# Pull Request Review Report: PR #[num]

- **Target Branch:** `[current-branch]`
- **Base Branch:** `[base-branch]`
- **Compare Commits:** `[merge-base]`...HEAD
- **Review Date:** [YYYY-MM-DD]
- **Issue Link:** [Link to related issue]

## 1. Scope of Changes

The following files were modified, added, or deleted between `[base-branch]` and `HEAD`:

```text
[List of modified files]
```

## 2. Test Verification Status

- **Test Command Detected/Run:** `[Command]`
- **Status:** [Passed | Failed | No Tests Found]
- **Output Summary:**

```text
[Test command output]
```

## 3. Build & Dev Verification Status

- **Build/Dev Command Detected/Run:** `[Command]`
- **Status:** [Passed | Failed | Not Applicable]
- **Output Summary:**

```text
[Build command output]
```

## 4. Detailed Code Review

### Logic & Correctness

[Analysis of potential bugs, edge cases, and runtime behavior]

### Safety & Security

[Evaluation of security practices and input handling]

### Performance & Scalability

[Analysis of computational complexity and resource usage]

### Style & Maintainability

[Review of idiomatic language usage and code structure]

## 5. Summary & Recommendation

- **Verdict:** [Approved | Request Changes]
- **Key Actions Required:**
  - [ ] [Action item 1]
````

---

## Verification Checklist

Prior to completing the PR review task, verify that:

1. [ ] **Report Created:** `pr-[pr_number].md` exists in the workspace root.
2. [ ] **Tests Executed:** The test execution section lists actual commands and status output.
3. [ ] **Build Verified:** Build/dev verification status is explicitly captured.
4. [ ] **Code Review Populated:** The detailed review section contains specific, actionable feedback on code quality.
5. [ ] **Verdict Rendered:** A clear recommendation (Approved / Request Changes) is provided at the bottom of the report.
