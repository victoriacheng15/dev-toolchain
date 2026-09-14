---
name: fresh-eye
description: Analyzes git diffs to perform local code quality reviews, outputting feedback directly to standard output.
version: 1.0.0
license: MIT
inputs: {}
outputs: []
on_failure:
  policy: retry
  max_retries: 3
---

# Code Review Sanity Checks

## Overview

Self-review is a critical step in the software development lifecycle. This skill automates the analysis of staged and unstaged code modifications (`git diff`) to identify common errors, logic gaps, debug statements, and coverage omissions before code is committed. It prints findings directly to standard output (`stdout`).

---

## Review Workflow

When performing a sanity code review, follow these procedural steps:

1. **Inspect Workspace Diffs:**
   - Run `git status` to identify all staged, unstaged, and untracked files.
   - Run `git diff HEAD` (or inspect `git diff --cached` and `git diff` separately) to review the modified lines.

2. **Evaluate Against Review Rubric:**
   - **Scope of Changes:** Summarize affected files and modified entry points.
   - **Blocker / High Priority Issues:** Identify leftover debug code (e.g., `console.log`, `fmt.Println`, `print()`), hardcoded credentials, broken error handling, or security vulnerabilities. If present, flag that the commit should be halted.
   - **Minor / Refactoring Suggestions:** Identify style inconsistencies, dead code, poor naming, or unnecessary complexity.
   - **Test Coverage Audit:** Audit whether new functions, methods, or modified logic have corresponding test suites.

3. **Render Structured Findings:**
   - Output the review directly to standard output matching the structure below.

---

## Output Structure

Print findings directly to standard output using the following format:

- **Scope of Changes:** Summary of modified files.
- **Blocker / High Priority Issues:** Critical logic errors, debug code, or safety risks.
- **Minor / Refactoring Suggestions:** Code smell detections, style improvements, or optimization recommendations.
- **Test Coverage Audit:** Flags modules or exports missing associated tests.
- **Verdict:** `READY TO COMMIT` (no blockers detected) or `BLOCKED` (critical issues or leftover debug code present).

---

## Verification Checklist

Prior to completing the review, verify that:

1. [ ] **Diff Audited:** The full diff between the working tree and HEAD has been reviewed.
2. [ ] **Blockers Flagged:** Leftover debug statements and critical regressions are identified.
3. [ ] **Coverage Verified:** Any un-tested code paths or missing test files are explicitly flagged.
4. [ ] **Output Formatted:** The review follows the structured sections above and includes a final Verdict.
