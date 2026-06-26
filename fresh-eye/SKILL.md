---
name: fresh-eye
description: Analyzes git diffs to perform local code quality reviews, outputting feedback directly to standard output.
---

# Code Review Sanity Checks

## Overview

Self-review is a critical step in the software development lifecycle. This skill automates the analysis of staged and unstaged code modifications (`git diff`) to identify common errors, logic gaps, debug statements, and coverage omissions before code is committed. It prints findings directly to standard output (`stdout`) and sets exit codes to gate commits.

---

## Automated Execution

To run the automated code review script, execute it from the root of the workspace:

```bash
./fresh-eye/fresh-eye.sh
```

### Exit Codes

- **`0`**: Success. No blocker or high-priority issues were detected.
- **`1`**: Failure. Blocker or high-priority issues were detected, indicating the commit should be halted.

---

## Output Structure

The script prints a structured review directly to standard output using the following format:

- **Scope of Changes:** Summary of modified files.
- **Blocker / High Priority Issues:** Critical logic errors, debug code (e.g., `console.log`, `print`), or safety risks. If present, these trigger a non-zero exit code.
- **Minor / Refactoring Suggestions:** Code smell detections, style improvements, or optimization recommendations.
- **Test Coverage Audit:** Flags exports or modules missing associated test files.

---

## Verification Checklist

Prior to completing the review, verify that:

1. [ ] **Exit Code Correct:** The script exits with status `1` if and only if high-priority blockers are present.
2. [ ] **Stdout Formatted:** Output is clean and readable in the terminal.
