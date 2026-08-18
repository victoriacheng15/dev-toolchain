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
    description: The base branch to compare the current changes against (e.g. main, master).
    required: false
    default: "main"
  run_dev:
    type: boolean
    description: Whether to attempt running the local development build/server check.
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

High-quality code reviews require verifying not just static code diffs, but also the dynamic correctness of the changes. This skill automates the process of comparing changes against a base branch, identifying and running tests, compiling/building the application locally, and generating a detailed review report.

---

## Automated Execution

To run the automated PR review script, execute it from the root of the workspace:

```bash
./pr-review/pr-review.sh <pr_number> [base_branch]
```

Where `<pr_number>` is the identifier of the PR (used to name the output file `pr-[pr_number].md`), and `[base_branch]` is the target branch of the PR (defaults to `main` if not specified).

---

## Script Behavior

* **Diff Analysis:** The script determines the merge-base between the current branch and the base branch, listing all modified files.
* **Test Detection & Execution:** It scans the changes for test files (e.g., `*_test.go`, `*.test.js`, `test_*.py`) and executes the workspace's test suite, capturing the outcome.
* **Build/Dev Verification:** If configured, the script attempts to compile/build the project to ensure no build regressions are introduced.
* **Report Generation:** It outputs a markdown report `pr-[pr_number].md` in the workspace root with execution logs and a skeleton for the detailed review.

---

## Agent Analysis & Review Duties

After running the script, the AI agent must edit the generated `pr-[pr_number].md` to provide a professional, deep-dive code review under **## 4. Detailed Code Review**. The review must analyze:

1. **Logic & Correctness:** Potential edge cases, off-by-one errors, resource leaks, or race conditions.
2. **Safety & Security:** SQL injection risks, unsafe pointer usage, unvalidated inputs, or insecure configuration.
3. **Performance:** Suboptimal time/space complexity, unnecessary allocations, or blocking calls in synchronous paths.
4. **Style & Maintainability:** Compliance with idiomatic language patterns, clear naming conventions, and proper documentation/comments.

---

## Verification Checklist

Prior to completing the PR review task, verify that:

1. [ ] **Report Created:** `pr-[pr_number].md` exists in the workspace root.
2. [ ] **Tests Executed:** The test execution section lists actual commands and status output.
3. [ ] **Build Verified:** Build/dev verification status is explicitly captured.
4. [ ] **Code Review Populated:** The detailed review section contains specific, actionable feedback on code quality.
5. [ ] **Verdict Rendered:** A clear recommendation (Approved / Request Changes) is provided at the bottom of the report.
